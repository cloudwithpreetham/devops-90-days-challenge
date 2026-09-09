# Day 19: Jenkins Zero to Hero — Declarative Pipelines, Docker Agents & GitOps to Kubernetes

> **Reference Tutorial:** [Day-19 | Jenkins ZERO to HERO (Abhishek Veeramalla)](https://youtu.be/zZfhAXfBvVA)
> **Course Track:** #90DaysOfDevOps Challenge
> **Repository:** [cloudwithpreetham/devops-90-days-challenge](https://github.com/cloudwithpreetham/devops-90-days-challenge)

---

## 📌 Table of Contents

1. [Architecture Overview: VM Workers vs. Docker Agents](#1-architecture-overview-vm-workers-vs-docker-agents)
2. [Jenkins Master Setup on AWS EC2](#2-jenkins-master-setup-on-aws-ec2)
3. [Configuring Docker as an Ephemeral Agent](#3-configuring-docker-as-an-ephemeral-agent)
4. [Freestyle Projects vs. Declarative Pipelines](#4-freestyle-projects-vs-declarative-pipelines)
5. [Hands-On Project 1: Single Docker Agent Pipeline](#5-hands-on-project-1-single-docker-agent-pipeline)
6. [Hands-On Project 2: Multi-Stage, Multi-Agent Pipeline (3-Tier App)](#6-hands-on-project-2-multi-stage-multi-agent-pipeline-3-tier-app)
7. [Hands-On Project 3: End-to-End GitOps to Kubernetes (Argo CD)](#7-hands-on-project-3-end-to-end-gitops-to-kubernetes-argo-cd)
8. [Troubleshooting & Production Gotchas](#8-troubleshooting--production-gotchas)
9. [Interview Q&A (Scenario-Based)](#9-interview-qa-scenario-based)

---

## 1. Architecture Overview: VM Workers vs. Docker Agents

### The Legacy Problem: Dedicated VM Worker Nodes

Historically, Jenkins masters delegated build jobs to dedicated worker VMs (e.g., dedicated EC2 instances for Java, Node.js, and Windows workloads).

```text
                             ┌───────────────────────┐
                             │    Jenkins Master     │
                             │   (Job Scheduler)     │
                             └───────────┬───────────┘
                                         │
                 ┌───────────────────────┼───────────────────────┐
                 ▼                       ▼                       ▼
      ┌─────────────────────┐ ┌─────────────────────┐ ┌─────────────────────┐
      │   Worker VM 1       │ │   Worker VM 2       │ │   Worker VM 3       │
      │  (Java 11 / Maven)  │ │ (Node.js 16 / NPM)  │ │ (Python / Database) │
      │  [High Idle Costs]  │ │ [Version Conflicts] │ │ [OS Patch Overhead] │
      └─────────────────────┘ └─────────────────────┘ └─────────────────────┘
```

#### Major Challenges

- **Resource Underutilization & Cloud Cost:** Instances sit idle when not executing builds, yet incur 24/7 compute charges.
- **Dependency Conflicts:** Running multiple apps on the same worker causes tool collision (e.g., App A requires Node 14 while App B requires Node 18).
- **Maintenance Overhead:** DevOps teams must patch, manage storage, and update software runtimes across multiple long-lived VMs.

---

### The Modern Solution: Dynamic Ephemeral Docker Agents

Rather than provisioning long-lived VMs, the Jenkins Master instructs the local (or remote) Docker engine to spawn an ephemeral container specifically for the duration of the stage or pipeline, executing commands inside the isolated container and terminating it immediately upon completion.

```text
                              ┌─────────────────────────┐
                              │  Jenkins Master (EC2)   │
                              │     Port 8080 (Web)     │
                              └────────────┬────────────┘
                                           │
                                  Docker Pipeline Plugin
                                           │
                              ┌────────────▼────────────┐
                              │   Docker Host Engine    │
                              │    (/var/run/docker.sock)│
                              └────────────┬────────────┘
                                           │
               ┌───────────────────────────┴───────────────────────────┐
               │ Spawns Dynamic Container per Stage / Pipeline         │
               ▼                                                       ▼
      ┌─────────────────────────┐                             ┌─────────────────────────┐
      │ Container: node:16      │                             │ Container: maven:3.8    │
      │ [Stage: Frontend Build] │                             │ [Stage: Backend Build]  │
      └────────────┬────────────┘                             └────────────┬────────────┘
                   │                                                       │
                   └─────────────────────► Auto-Destroy ◄──────────────────┘
```

#### Key Advantages

- **Zero Idle Waste:** Compute is consumed only when a pipeline executes.
- **Hermetic Isolation:** Every pipeline stage runs in a clean, isolated container environment.
- **Instant Upgrades:** Upgrading a runtime version requires altering just one tag in the `Jenkinsfile` (e.g., `image 'node:16'` $\rightarrow$ `image 'node:18'`).

---

## 2. Jenkins Master Setup on AWS EC2

### Step 1: EC2 Provisioning & Security Group

1. Launch an AWS EC2 instance:
   - **AMI:** Ubuntu Server 22.04 LTS
   - **Instance Type:** `t2.medium` (minimum 2 vCPUs, 4 GB RAM recommended for Jenkins + Docker)
   - **Storage:** 20 GB gp3
2. Configure Security Group **Inbound Rules**:
   - `SSH` (Port 22): Your IP (or `0.0.0.0/0` for sandbox testing)
   - `Custom TCP` (Port 8080): `0.0.0.0/0` (Jenkins Web UI)

---

### Step 2: Install OpenJDK & Jenkins

SSH into your EC2 instance and run:

```bash
# Update system repositories
sudo apt-get update -y

# Install OpenJDK 11 / 17 (Prerequisite for Jenkins)
sudo apt-get install openjdk-11-jdk -y
java -version

# Add official Jenkins repository key and repo entry
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt-get update -y
sudo apt-get install jenkins -y

# Enable and verify Jenkins daemon
sudo systemctl enable jenkins
sudo systemctl status jenkins
```

---

### Step 3: Unlock Jenkins & Initial Configuration

1. Open your browser and navigate to:

   ```text
   http://<EC2-PUBLIC-IP>:8080
   ```

2. Retrieve the initial administrator password:

   ```bash
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   ```

3. Paste the password into the prompt.
4. Select **Install suggested plugins**.
5. Create your primary Admin User credentials, confirm the Jenkins Root URL, and finish setup.

---

## 3. Configuring Docker as an Ephemeral Agent

### Step 1: Install Docker Engine on Jenkins Host

```bash
sudo apt-get update -y
sudo apt-get install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
```

---

### Step 2: Grant Permissions to the Jenkins Daemon User

By default, Docker's UNIX domain socket (`/var/run/docker.sock`) is owned by `root:docker`. Jenkins runs under the dedicated service account `jenkins`. Add the `jenkins` user and `ubuntu` user to the `docker` group:

```bash
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu

# Restart the Docker service to enforce permissions
sudo systemctl restart docker
```

Verify that the `jenkins` user can execute Docker commands without `sudo`:

```bash
sudo su - jenkins
docker run hello-world
exit
```

---

### Step 3: Install Docker Pipeline Plugin in Jenkins

1. Go to **Manage Jenkins** $\rightarrow$ **Plugins** (or **Manage Plugins**).
2. Under the **Available plugins** tab, search for **Docker Pipeline**.
3. Select **Install without restart** (or install and restart).
4. Restart Jenkins cleanly via URL:

   ```text
   http://<EC2-PUBLIC-IP>:8080/restart
   ```

---

## 4. Freestyle Projects vs. Declarative Pipelines

| Criteria                      | Freestyle Project                            | Declarative Pipeline (`Jenkinsfile`)              |
| :---------------------------- | :------------------------------------------- | :------------------------------------------------ |
| **Configuration Format**      | Form fields & text boxes in Web GUI          | Declarative Pipeline-as-Code (`Jenkinsfile`)      |
| **Version Control**           | Stored in Jenkins internal XML files         | Tracked in Git alongside source code              |
| **Audit & Code Review**       | Changes untracked; prone to accidental edits | Full Git history, branch PR reviews, `git blame`  |
| **Disaster Recovery**         | Manual backup/export of Jenkins XML jobs     | Trivially recreated by pointing to the repository |
| **Multi-Stage Orchestration** | Clunky chaining of separate jobs             | Clean sequential and parallel stages in code      |
| **Dynamic Containers**        | Requires complex custom scripts              | Native `agent { docker { ... } }` directive       |

> 💡 **Best Practice:** Always use **Pipeline script from SCM** pointing to a versioned `Jenkinsfile`. Use the Jenkins **Pipeline Syntax Generator** (`http://<JENKINS_URL>:8080/pipeline-syntax`) to auto-generate Groovy steps for SCM checkout, credentials, and shell steps.

---

## 5. Hands-On Project 1: Single Docker Agent Pipeline

### Project 1 Objective

Verify that Jenkins can dynamically spin up an ephemeral container (`node:16-alpine`), run diagnostic commands inside the container, and destroy it cleanly after completion.

### Directory Structure

```text
Day-19/
└── project-1/
    └── Jenkinsfile
```

### `project-1/Jenkinsfile`

```groovy
pipeline {
    agent {
        docker {
            image 'node:16-alpine'
            args '-u root'
        }
    }
    stages {
        stage('Validate Docker Agent Environment') {
            steps {
                echo 'Executing commands inside dynamic Node.js Alpine container...'
                sh 'node --version'
                sh 'npm --version'
                sh 'cat /etc/os-release'
            }
        }
    }
    post {
        always {
            echo 'Build finished. Docker agent container will now be automatically destroyed.'
        }
    }
}
```

### Verification & Testing

1. In Jenkins: **New Item** $\rightarrow$ Project Name: `project-1-docker-agent` $\rightarrow$ Select **Pipeline**.
2. Under **Pipeline Definition**, select **Pipeline script from SCM**.
3. SCM: **Git**, Repository URL: `https://github.com/cloudwithpreetham/devops-90-days-challenge.git`.
4. Branch: `*/main`.
5. Script Path: `Day-19/project-1/Jenkinsfile`.
6. Click **Build Now**.
7. Observe the host terminal concurrently:

   ```bash
   watch -n 1 "docker ps"
   ```

   _Result:_ Jenkins pulls `node:16-alpine`, executes the build steps inside the container, outputs the node version, and issues a container stop/remove upon job completion.

---

## 6. Hands-On Project 2: Multi-Stage, Multi-Agent Pipeline (3-Tier App)

### Project 2 Objective

Simulate a full-stack 3-tier enterprise application where distinct lifecycle stages require completely different runtime tooling (Maven for Java backend, Node.js for frontend, MySQL CLI for database migration).

### `project-2/Jenkinsfile`

```groovy
pipeline {
    agent none // Instructs Jenkins Master to allocate agents at the individual stage level

    stages {
        stage('Backend Build (Java / Maven)') {
            agent {
                docker {
                    image 'maven:3.8.6-openjdk-11'
                }
            }
            steps {
                echo '=== Stage 1: Building Backend Services ==='
                sh 'mvn --version'
                // Real-world scenario:
                // sh 'mvn clean test package'
            }
        }

        stage('Frontend Build & Test (Node.js)') {
            agent {
                docker {
                    image 'node:16-alpine'
                }
            }
            steps {
                echo '=== Stage 2: Building Frontend UI ==='
                sh 'node --version'
                sh 'npm --version'
                // Real-world scenario:
                // sh 'npm install && npm test && npm run build'
            }
        }

        stage('Database Migration & Health Check') {
            agent {
                docker {
                    image 'mysql:8.0'
                }
            }
            steps {
                echo '=== Stage 3: Running DB Migrations ==='
                sh 'mysql --version'
                // Real-world scenario:
                // sh 'mysql -h db-host -u $DB_USER -p$DB_PASS < schema_migration.sql'
            }
        }
    }

    post {
        success {
            echo 'All multi-tier stages built successfully across distinct dynamic containers!'
        }
        failure {
            echo 'Pipeline failed. Check stage logs for errors.'
        }
    }
}
```

---

## 7. Hands-On Project 3: End-to-End GitOps to Kubernetes (Argo CD)

### Workflow Overview

Instead of giving Jenkins cluster-admin credentials to push changes directly into Kubernetes, modern CI/CD decouples **Continuous Integration (CI)** from **Continuous Delivery (CD)** via GitOps.

```text
 ┌──────────────┐         ┌──────────────┐         ┌──────────────┐
 │  Developer   │ Push    │ GitHub Repo  │ Trigger │   Jenkins    │
 │ (Code & App) ├────────►│(Source Code) ├────────►│ (CI Pipeline)│
 └──────────────┘         └──────────────┘         └──────┬───────┘
                                                          │
                                         1. Build Image   │
                                         2. Push Registry │
                                                          ▼
 ┌──────────────┐         ┌──────────────┐         ┌──────────────┐
 │  Kubernetes  │ Pull    │   Argo CD    │ Sync    │  Docker Hub  │
 │   Cluster    │◄────────┤   (GitOps)   │◄────────┤ (Image Repo) │
 └──────────────┘         └──────▲───────┘         └──────────────┘
                                 │ Watches for Drift
                          ┌──────┴───────┐
                          │ GitHub Repo  │◄── 3. Jenkins bumps image
                          │ (K8s YAMLs)  │       tag in deployment.yaml
                          └──────────────┘
```

1. **Commit:** Developer pushes Python application code changes.
2. **Jenkins CI:**
   - Checks out code.
   - Builds container image tagged with `BUILD_NUMBER`.
   - Pushes image to Docker Hub.
   - Updates `deployment.yaml` in the GitOps repository with the new image tag.
   - Commits and pushes the manifest change back to GitHub.
3. **Argo CD (GitOps):**
   - Detects the new commit in the Git repository.
   - Synchronizes the new state into the target Kubernetes cluster automatically.

---

### `project-3/Jenkinsfile`

```groovy
pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-auth') // Stored in Jenkins Credentials Store
        DOCKER_IMAGE_NAME      = 'preethamdevops/todo-app'
        GITHUB_CREDENTIALS     = credentials('github-pat')
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    echo "Building Docker Image: ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ."

                    // Log in and push image to Docker Hub
                    sh "echo ${DOCKER_HUB_CREDENTIALS_PSW} | docker login -u ${DOCKER_HUB_CREDENTIALS_USR} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }

        stage('Update GitOps Deployment Manifest') {
            steps {
                script {
                    echo "Updating Kubernetes deployment.yaml to version: ${BUILD_NUMBER}"
                    sh """
                        sed -i 's|image: .*|image: ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}|g' k8s/deployment.yaml
                        git config user.name "Jenkins CI Bot"
                        git config user.email "jenkins-ci@cloudwithpreetham.local"
                        git add k8s/deployment.yaml
                        git commit -m "chore(release): bump deployment image to build-${BUILD_NUMBER} [skip ci]"
                        git push https://${GITHUB_CREDENTIALS}@github.com/cloudwithpreetham/devops-90-days-challenge.git HEAD:main
                    """
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
    }
}
```

---

## 8. Troubleshooting & Production Gotchas

### Issue 1: `Got permission denied while trying to connect to the Docker daemon socket`

- **Root Cause:** The `jenkins` service user does not have read/write access to `/var/run/docker.sock`.
- **Solution:**

  ```bash
  sudo usermod -aG docker jenkins
  sudo systemctl restart docker
  sudo systemctl restart jenkins
  ```

---

### Issue 2: Docker Agent Container Fails to Spin Up

- **Root Cause:** The **Docker Pipeline** plugin is either missing, corrupted, or Jenkins was not restarted post-installation.
- **Solution:**
  - Verify plugin status under **Manage Jenkins** $\rightarrow$ **Plugins** $\rightarrow$ **Installed plugins**.
  - Restart Jenkins via browser: `http://<JENKINS-IP>:8080/restart`.

---

### Issue 3: Inability to Access Jenkins UI on Port 8080

- **Root Cause:** EC2 Security Group inbound rule is missing, or local OS firewall (`ufw`) is blocking port 8080.
- **Solution:**

  ```bash
  # Check if port is open locally
  sudo netstat -tlpn | grep 8080

  # Ensure UFW is not blocking traffic
  sudo ufw allow 8080/tcp
  sudo ufw status
  ```

  Ensure AWS Security Group allows inbound TCP `8080` from your IP.

---

## 9. Interview Q&A (Scenario-Based)

### Q1: Why should an organization migrate from static VM worker nodes to dynamic Docker agents?

> **Answer:** Dedicated VM worker nodes suffer from three major production issues:
>
> 1. **Resource/Cost Waste:** VMs run continuously, incurring 24/7 cloud costs even during periods with no builds.
> 2. **Dependency Drift:** Different teams and microservices require incompatible runtime versions (e.g., Python 2 vs 3, Java 8 vs 17).
> 3. **High Maintenance:** Managing, patching, and maintaining individual worker OS images introduces heavy operational overhead.
>
> Docker agents provide **on-demand, ephemeral environments**: containers are created dynamically when a job starts, run isolated steps, and are instantly terminated and purged upon completion.

---

### Q2: What is the architectural difference between `agent any`, `agent none`, and `agent { docker { ... } }`?

> **Answer:**
>
> - `agent any`: Allocates any available executor across the Jenkins cluster (usually running on the host machine OS).
> - `agent none`: Used at the top level of a Declarative Pipeline to suppress global agent allocation. This mandates that each individual `stage` declare its own dedicated agent.
> - `agent { docker { image '...' } }`: Spawns a container instance of the declared Docker image and runs all stage commands inside that container's filesystem.

---

### Q3: Why is GitOps with Argo CD preferred over Jenkins directly executing `kubectl apply`?

> **Answer:**
>
> 1. **Security (No Cluster-Admin Secrets in CI):** Exposing Kubernetes administrative `kubeconfig` or cluster credentials to Jenkins creates a massive security attack surface. With GitOps, CI only pushes images and commits manifest updates to Git; the GitOps controller (Argo CD) operates _inside_ the cluster via least privilege.
> 2. **Single Source of Truth:** The Git repository stores the exact declared state of the cluster.
> 3. **Drift Detection & Auto-Heal:** If someone manually modifies a pod or deployment via `kubectl`, Argo CD detects the configuration drift and reconciles it back to the state stored in Git. Jenkins cannot do this.
