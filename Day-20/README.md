# Day 20: GitHub Actions Zero to Hero — Workflows, Matrix Builds, Secrets & Self-Hosted Runners

> **Reference Video:** [Day-20 | GitHub Actions | Actions vs Jenkins | 3 Projects with examples | Configure your own runner (Abhishek Veeramalla)](https://youtu.be/K3RqgDPCjYs)

---

## 📌 Table of Contents

1. [Overview & What is GitHub Actions?](#-1-overview--what-is-github-actions)
2. [GitHub Actions vs. Jenkins: Comprehensive Comparison](#-2-github-actions-vs-jenkins-comprehensive-comparison)
3. [Architecture & Workflow Directory Layout](#-3-architecture--workflow-directory-layout)
4. [Hands-On Project 1: Python Multi-Version Test Matrix Pipeline](#-4-hands-on-project-1-python-multi-version-test-matrix-pipeline)
5. [Hands-On Project 2: Enterprise CI/CD Pipeline (Maven + SonarQube + K8s)](#-5-hands-on-project-2-enterprise-cicd-pipeline-maven--sonarqube--k8s)
6. [Managing Encrypted Secrets in GitHub Actions](#-6-managing-encrypted-secrets-in-github-actions)
7. [Configuring Custom Self-Hosted Runners](#self-hosted-runners)
8. [Common Pitfalls & Troubleshooting](#common-pitfalls-troubleshooting)
9. [Interview Q&A](#-9-interview-qa)

---

## 🚀 1. Overview & What is GitHub Actions?

**GitHub Actions** is an event-driven automation platform natively embedded inside GitHub. It allows engineers to automate continuous integration (CI), continuous delivery/deployment (CD), issue triaging, code formatting checks, and release management without hosting or operating dedicated CI master nodes.

```text
  ┌──────────────────────────────────────────────────────────────┐
  │                        GitHub Event                          │
  │     (git push, pull_request, issue, schedule, dispatch)     │
  └──────────────────────────────┬───────────────────────────────┘
                                 │ Triggers
                                 ▼
  ┌──────────────────────────────────────────────────────────────┐
  │                 Workflow (.github/workflows/*.yaml)          │
  │  ┌─────────────────────────┐     ┌─────────────────────────┐ │
  │  │   Job 1: Lint & Unit    │     │   Job 2: Security Scan  │ │
  │  │   (runs-on: ubuntu-...) │     │   (runs-on: ubuntu-...) │ │
  │  └────────────┬────────────┘     └────────────┬────────────┘ │
  └───────────────┼───────────────────────────────┼──────────────┘
                  ▼                               ▼
       ┌─────────────────────┐         ┌─────────────────────┐
       │ Step 1: Checkout    │         │ Step 1: Checkout    │
       │ Step 2: Setup Env   │         │ Step 2: Run Trivy   │
       │ Step 3: Run Tests   │         │ Step 3: Upload SARIF│
       └─────────────────────┘         └─────────────────────┘
```

### Key Highlights

- **Zero Server Setup:** No EC2 instances or master servers to install, configure, or patch.
- **Marketplace of Actions:** Thousands of community-tested, reusable plugins (`actions/checkout`, `actions/setup-python`, `docker/build-push-action`).
- **Declarative YAML:** Workflows live right alongside your application source code under `.github/workflows/`.

---

## ⚖️ 2. GitHub Actions vs. Jenkins: Comprehensive Comparison

| Dimension                  | GitHub Actions                                                                                                        | Jenkins                                                                                                    |
| :------------------------- | :-------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------- |
| **Hosting & Ops Overhead** | **Fully Managed (SaaS)**; zero infrastructure to maintain.                                                            | **Self-Hosted**; requires provisioning VMs, OS patching, Java upgrades, and storage management.            |
| **Plugin Architecture**    | Reusable steps pulled dynamically from the **GitHub Marketplace**; isolated per workflow step via tags (e.g., `@v3`). | Installed globally via Jenkins Plugin Manager; plugin updates often break older pipelines.                 |
| **VCS Vendor Lock-in**     | Tightly coupled with the **GitHub** platform.                                                                         | **Vendor-neutral**; integrates with GitLab, Bitbucket, AWS CodeCommit, Azure DevOps, and bare-metal Git.   |
| **Trigger Mechanisms**     | Native GitHub events (`push`, `pull_request`, `issue_comment`, `release`, `workflow_dispatch`).                       | Requires Webhooks, poll SCM, or external cron plugins.                                                     |
| **Cost Model**             | Free for public repositories; generous monthly quotas (e.g., 2,000 free minutes) for private repositories.            | Open-source software, but you pay continuous AWS/cloud infrastructure costs for 24/7 master and agent VMs. |
| **Team Staffing**          | Standard developers and DevOps engineers can write YAML directly; no dedicated admin needed.                          | Typically requires a dedicated Jenkins administrator in large enterprises.                                 |

> **Architectural Decision Rule:** If your organization hosts its source code on GitHub and does not intend to migrate between code repositories, GitHub Actions provides lower operational total cost of ownership (TCO). However, if your company uses self-hosted Git servers, hybrid clouds, or multi-platform VCS, Jenkins or platform-neutral alternatives remain necessary.

---

## 📁 3. Architecture & Workflow Directory Layout

All GitHub Actions workflow files must reside inside the `.github/workflows/` directory in the root of your Git repository:

```text
devops-90-days-challenge/
├── .github/
│   └── workflows/
│       ├── pr-title-check.yaml     # Enforces branch/PR naming standards
│       ├── unit-tests.yaml         # Matrix test suite across runtimes
│       ├── sonarqube-scan.yaml     # Static code analysis & security gate
│       └── k8s-deployment.yaml     # Continuous delivery to Kubernetes
├── src/
│   ├── app.py
│   └── test_app.py
└── README.md
```

### Workflow Components Hierarchy

1. **Workflow:** An automated end-to-end process defined in a `.yaml` or `.yml` file.
2. **Events (`on`):** Repository activities that initiate the workflow (`push`, `pull_request`, `workflow_dispatch`).
3. **Jobs:** A set of sequential steps executed on a specific runner (`runs-on`). Multiple jobs execute in parallel by default.
4. **Steps:** Individual tasks inside a job that either run shell commands (`run:`) or execute reusable actions (`uses:`).

---

## 🧪 4. Hands-On Project 1: Python Multi-Version Test Matrix Pipeline

A primary feature of GitHub Actions is the **Matrix Strategy**, which lets you run tests across multiple operating systems or language versions simultaneously from a single job definition.

### 1. Application Code (`src/addition.py`)

```python
def add(a: int, b: int) -> int:
    """Returns the sum of two integers."""
    return a + b

def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0
```

### 2. Workflow Manifest (`.github/workflows/python-matrix.yaml`)

```yaml
name: Python Matrix CI Pipeline

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  unit-test-matrix:
    name: Run Pytest on Python ${{ matrix.python-version }}
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.8", "3.9", "3.10"]

    steps:
      # Step 1: Check out the repository
      - name: Checkout Repository
        uses: actions/checkout@v3

      # Step 2: Configure Python runtime dynamically
      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v2
        with:
          python-version: ${{ matrix.python-version }}

      # Step 3: Install dependencies and pytest runner
      - name: Install Dependencies
        run: |
          python -m pip install --upgrade pip
          pip install pytest

      # Step 4: Execute test suite
      - name: Run Pytest Suite
        run: |
          pytest src/addition.py -v
```

---

## 🏢 5. Hands-On Project 2: Enterprise CI/CD Pipeline (Maven + SonarQube + K8s)

In an enterprise delivery lifecycle, the pipeline builds the application, scans the codebase with SonarQube for vulnerabilities, and deploys manifests into a target Kubernetes cluster.

### Workflow Manifest (`.github/workflows/enterprise-cicd.yaml`)

```yaml
name: Enterprise Java CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  build-scan-deploy:
    name: Build, Audit and Deploy
    runs-on: ubuntu-latest

    steps:
      # Step 1: Checkout Source Code
      - name: Checkout Code
        uses: actions/checkout@v3

      # Step 2: Set up JDK 11 Runtime
      - name: Set up JDK 11
        uses: actions/setup-java@v3
        with:
          distribution: "temurin"
          java-version: "11"

      # Step 3: Compile and Package Artifact via Maven
      - name: Build with Maven
        run: |
          mvn clean package -DskipTests

      # Step 4: SonarQube Static Code Analysis
      - name: Run SonarQube Code Quality Analysis
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
        run: |
          mvn sonar:sonar \
            -Dsonar.host.url=${{ secrets.SONAR_HOST_URL }} \
            -Dsonar.login=${{ secrets.SONAR_TOKEN }}

      # Step 5: Configure Kubernetes Context via Secret Kubeconfig
      - name: Set Kubeconfig Context
        uses: azure/k8s-set-context@v2
        with:
          method: kubeconfig
          kubeconfig: ${{ secrets.KUBECONFIG_DATA }}

      # Step 6: Deploy Manifests to Kubernetes Cluster
      - name: Deploy to Kubernetes Cluster
        run: |
          kubectl apply -f k8s/deployment.yaml
          kubectl apply -f k8s/service.yaml
          kubectl rollout status deployment/java-web-app
```

---

## 🔐 6. Managing Encrypted Secrets in GitHub Actions

Sensitive variables (tokens, credentials, `kubeconfig` files) must never be committed to plain text files. GitHub provides integrated encrypted secrets.

### How to Configure Secrets

1. Navigate to your repository on GitHub.
2. Go to **Settings** > **Secrets and variables** > **Actions**.
3. Click **New repository secret**.
4. Define your secrets:
   - `SONAR_TOKEN`: Token generated in SonarQube (`My Account > Security`).
   - `SONAR_HOST_URL`: The URL of your SonarQube server (e.g., `http://sonar.mycompany.internal:9000`).
   - `KUBECONFIG_DATA`: Base64-encoded string of your `~/.kube/config` file:

     ```bash
     cat ~/.kube/config | base64 -w 0
     ```

### Referencing Secrets in YAML

```yaml
env:
  API_KEY: ${{ secrets.MY_SECRET_KEY }}
```

---

## 🖥️ 7. Configuring Custom Self-Hosted Runners

While GitHub-hosted runners are convenient, organizations frequently deploy **Self-Hosted Runners** to run pipelines inside private VPCs, access private databases, or run heavy builds that require high compute resources.

### Registration & Configuration Steps

1. Open your repository on GitHub > **Settings** > **Actions** > **Runners**.
2. Click **New self-hosted runner** and select the OS architecture (e.g., Linux x64).
3. Execute the commands on your target host / EC2 instance:

```bash
# 1. Create runner directory and download archive
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz

# 2. Configure the runner with token
./config.sh --url https://github.com/cloudwithpreetham/devops-90-days-challenge --token <RUNNER_REGISTRATION_TOKEN>

# 3. Install and run as a systemd background service
sudo ./svc.sh install
sudo ./svc.sh start
sudo ./svc.sh status
```

### Targeting the Self-Hosted Runner in Workflows

Change `runs-on` in your job configuration:

```yaml
jobs:
  build:
    runs-on: self-hosted
    steps:
      - run: echo "Running on dedicated self-hosted instance!"
```

---

## 🛠️ 8. Common Pitfalls & Troubleshooting

1. **Confusing Action Version with Runtime Version:**
   - _Mistake:_ Thinking `actions/setup-python@v2` installs Python 2.
   - _Reality:_ `@v2` is the version of the setup action itself. You declare the runtime inside `with: python-version: '3.9'`.
2. **Secrets Hidden in Forked PRs:**
   - By default, pull requests submitted from external forks do not have access to repository secrets to prevent unauthorized exfiltration.
3. **YAML Indentation Issues:**
   - GitHub Actions YAML is strictly space-sensitive. Ensure 2-space indentation and check syntax errors using linters or the GitHub Actions online editor.
4. **Runner Disk Space Exhaustion:**
   - Self-hosted runners accumulate Docker images, caches, and test artifacts. Ensure you run cleanup scripts or add `docker system prune -af` post-steps.

---

## 💼 9. Interview Q&A

### Q1: What is the difference between a Job and a Step in GitHub Actions?

**Answer:** A **Job** is a top-level execution unit that runs on an assigned runner (`runs-on`). Multiple jobs run in parallel unless linked via `needs:`. A **Step** is an individual task executed sequentially inside a specific job, sharing the same filesystem and container environment.

#### Q2: When would you recommend Jenkins over GitHub Actions?

**Answer:** Jenkins is preferable when:

- The organization uses multiple diverse VCS providers (GitLab, Bitbucket, AWS CodeCommit, Azure Repos) and needs a single central CI engine.
- Strict regulatory policies prevent running any pipeline metadata on cloud-managed SaaS infrastructure.
- Highly specialized legacy plugins exist only within the Jenkins ecosystem.

##### Q3: How do Matrix Builds improve CI performance?

**Answer:** Matrix builds run parallel job instances across an array of parameters (such as Python versions `['3.8', '3.9', '3.10']` or OS images `['ubuntu-latest', 'windows-latest']`). This eliminates duplicated workflow code and allows broad cross-platform verification in parallel.

##### Q4: How do you access private AWS/K8s resources from GitHub Actions without exposing public endpoints?

**Answer:** You can deploy **Self-Hosted Runners** directly inside your private AWS VPC / private Kubernetes cluster. The runner opens an outbound polling connection over HTTPS (port 443) to GitHub, completely eliminating the need to expose inbound ports to the public internet.
