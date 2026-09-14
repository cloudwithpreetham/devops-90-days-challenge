# Day 24: Docker Zero to Hero (Part 1) — Architecture, CLI Mastery, Dockerfile Internals & Image Management

> **Reference Video:** [Day-24 | Docker Zero to Hero Part-1 | Abhishek Veeramalla](https://youtu.be/wodLpta-hoQ)
> **Challenge Repository:** [cloudwithpreetham/devops-90-days-challenge](https://github.com/cloudwithpreetham/devops-90-days-challenge)

---

## 📌 Table of Contents

1. [Overview & What is Docker?](#-1-overview--what-is-docker)
2. [Docker Engine Architecture Under the Hood](#-2-docker-engine-architecture-under-the-hood)
3. [Virtual Machines vs. Containers: The Runtime Difference](#-3-virtual-machines-vs-containers-the-runtime-difference)
4. [Installing Docker Engine on Linux (Ubuntu 22.04 LTS)](#-4-installing-docker-engine-on-linux-ubuntu-2204-lts)
5. [Docker Lifecycle & Essential CLI Commands](#-5-docker-lifecycle--essential-cli-commands)
6. [Anatomy of a Dockerfile: Core Directives & Mechanics](#-6-anatomy-of-a-dockerfile-core-directives--mechanics)
7. [Hands-On Lab: Writing, Building & Running Your First Container](#-7-hands-on-lab-writing-building--running-your-first-container)
8. [Docker Image Layering, Caching & Copy-on-Write (CoW)](#-8-docker-image-layering-caching--copy-on-write-cow)
9. [Publishing Images to Docker Hub Registry](#-9-publishing-images-to-docker-hub-registry)
10. [Production Troubleshooting & Common Gotchas](#-10-production-troubleshooting--common-gotchas)
11. [Senior DevOps Interview Q&A](#-11-senior-devops-interview-qa)

---

## 🐳 1. Overview & What is Docker?

In traditional software delivery, teams faced the notorious **"It works on my machine"** dilemma: code tested cleanly on a developer's macOS or Windows laptop routinely crashed in staging or production Linux environments due to missing OS packages, conflicting runtime versions (e.g., Python 3.8 vs. 3.10), path mismatches, or differing shared libraries (`.so`/`.dll`).

**Docker** is an open-source platform that automates the deployment of applications inside lightweight, portable, self-contained packages called **containers**.

A container packages:

- The application code.
- The application runtime (e.g., Node.js, Python, JRE).
- System binaries and dependent system libraries.
- Environment variables and default configurations.

Because containers share the host operating system's kernel and isolate user spaces via Linux kernel primitives (`namespaces` and `cgroups`), they provide complete behavioral consistency across laptops, test runners, bare-metal servers, and multi-cloud infrastructure.

---

## 🏗️ 2. Docker Engine Architecture Under the Hood

Docker does not run as a single monolithic process. It uses a modular, decoupled **client-server architecture**:

```text
 ┌────────────────────────────────────────────────────────┐
 │                      Docker Client                     │
 │              (CLI: `docker run`, `docker build`)       │
 └───────────────────────────┬────────────────────────────┘
                             │ REST API over UNIX Socket
                             │ (`/var/run/docker.sock`)
                             ▼
 ┌────────────────────────────────────────────────────────┐
 │                    Docker Host Daemon                  │
 │                        (dockerd)                       │
 │  ┌──────────────────────────────────────────────────┐  │
 │  │ Manages: Images, Volumes, Networks, Builds       │  │
 │  └──────────────────────────┬───────────────────────┘  │
 │                             ▼                          │
 │  ┌──────────────────────────────────────────────────┐  │
 │  │               Container Runtime Engine           │  │
 │  │                     (containerd)                 │  │
 │  └──────────────────────────┬───────────────────────┘  │
 │                             ▼                          │
 │  ┌──────────────────────────────────────────────────┐  │
 │  │              Low-Level OCI Runtime               │  │
 │  │                      (runc)                      │  │
 │  └──────────────────────────┬───────────────────────┘  │
 └─────────────────────────────┼──────────────────────────┘
                               │
            ┌──────────────────┴──────────────────┐
            ▼                                     ▼
 ┌─────────────────────┐               ┌─────────────────────┐
 │ Container A (App 1) │               │ Container B (App 2) │
 │ Namespaces, Cgroups │               │ Namespaces, Cgroups │
 └─────────────────────┘               └─────────────────────┘
```

### Architectural Components

1. **Docker Client (`docker`)**: The command-line interface (CLI) that developers interact with. It translates user commands into REST API calls and sends them to the daemon.
2. **Docker Daemon (`dockerd`)**: A background service running on the host that listens for Docker API requests and manages high-level Docker objects (images, containers, networks, and storage volumes).
3. **`containerd`**: A high-level container runtime that manages the complete container lifecycle: image transfer, storage management, container execution supervision, and network attachment.
4. **`runc`**: The lightweight, CLI-based low-level OCI (Open Container Initiative) reference implementation. It interfaces directly with the Linux kernel to create namespaces, attach control groups (cgroups), set up root filesystems, and launch the actual isolated processes.
5. **Docker Registry (e.g., Docker Hub, AWS ECR, GitHub GHCR)**: A centralized, remote repository for storing, versioning, and distributing container images.

---

## ⚖️ 3. Virtual Machines vs. Containers: The Runtime Difference

| Metric                   | Virtual Machines (VMs)                                         | Docker Containers                                         |
| :----------------------- | :------------------------------------------------------------- | :-------------------------------------------------------- |
| **Virtualization Layer** | Hardware-level virtualization (Hypervisor Type 1/2)            | OS-level virtualization (Shared Host OS Kernel)           |
| **Operating System**     | Every VM boots a full Guest OS (Kernel + User Space)           | No guest kernel; containers use host kernel namespaces    |
| **Startup Latency**      | Minutes (boots BIOS, kernel, systemd services)                 | Milliseconds to seconds (launches a single process)       |
| **Storage Footprint**    | Gigabytes to tens of Gigabytes ($10\text{ GB} - 50\text{ GB}$) | Megabytes ($5\text{ MB} - 500\text{ MB}$)                 |
| **Memory Overhead**      | High (memory pre-allocated and dedicated to Guest OS)          | Extremely low (consumes only active process memory)       |
| **Density per Host**     | Tens of VMs per server                                         | Hundreds to thousands of containers per server            |
| **Isolation Boundary**   | Hard hardware isolation via CPU rings and hypervisor           | Process-level isolation via kernel namespaces and cgroups |

---

## ⚙️ 4. Installing Docker Engine on Linux (Ubuntu 22.04 LTS)

Follow production-standard installation steps via Docker's official apt repository to ensure you receive official security patches:

### Step 1: Remove Old or Unofficial Packages

```bash
sudo apt-get remove -y docker docker-engine docker.io containerd runc
```

### Step 2: Install Repository Prerequisites

```bash
sudo apt-get update -y
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

### Step 3: Add Docker Official GPG Key & Repository

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### Step 4: Install Docker Engine, containerd, and Docker Compose

```bash
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Step 5: Enable Rootless Execution for Current User

By default, the Docker daemon binds to a UNIX socket owned by user `root` and group `docker`. Add your non-root user (`ubuntu`) to the `docker` group to execute commands without `sudo`:

```bash
sudo usermod -aG docker $USER
newgrp docker

# Verify Docker installation
docker version
docker run --rm hello-world
```

---

## 🕹️ 5. Docker Lifecycle & Essential CLI Commands

```text
                 docker build
  [ Dockerfile ] ────────────► [ Image ]
                                  │
                                  │ docker run
                                  ▼
                            [ Container ]
                             │         ▲
                docker stop  │         │ docker start
                             ▼         │
                        [ Stopped ] ───┘
                             │
                             │ docker rm
                             ▼
                        [ Destroyed ]
```

### 1. Inspecting & Querying

- List running containers:

  ```bash
  docker ps
  ```

- List all containers (including stopped/exited):

  ```bash
  docker ps -a
  ```

- List locally cached images:

  ```bash
  docker images
  ```

- Inspect low-level JSON metadata (IP address, mounts, environment variables):

  ```bash
  docker inspect <container_id_or_name>
  ```

- Stream live resource metrics (CPU %, Memory usage, Network I/O):

  ```bash
  docker stats
  ```

### 2. Running & Interacting with Containers

- Run an Nginx container in detached mode with port mapping:

  ```bash
  docker run -d --name web-server -p 8080:80 nginx:alpine
  ```

  - `-d`: Run in detached mode (background).
  - `--name`: Assign an explicit container name.
  - `-p 8080:80`: Map host port `8080` to container port `80`.

- Execute an interactive Bash/Sh shell inside a running container:

  ```bash
  docker exec -it web-server /bin/sh
  ```

- Stream logs from a running container:

  ```bash
  docker logs -f --tail 50 web-server
  ```

### 3. Lifecycle & Cleanup

- Stop a running container gracefully (sends `SIGTERM`, then `SIGKILL` after 10s):

  ```bash
  docker stop web-server
  ```

- Remove a stopped container:

  ```bash
  docker rm web-server
  ```

- Force remove a running container immediately:

  ```bash
  docker rm -f web-server
  ```

- Remove an image from local storage:

  ```bash
  docker rmi nginx:alpine
  ```

- Purge all unused containers, dangling images, networks, and build caches:

  ```bash
  docker system prune -af --volumes
  ```

---

## 📝 6. Anatomy of a Dockerfile: Core Directives & Mechanics

A `Dockerfile` is a text document containing sequential instructions used by Docker to automatically assemble a container image.

| Instruction  | Purpose                                                                        | Best-Practice Note                                                                                 |
| :----------- | :----------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------- |
| `FROM`       | Specifies the parent/base image.                                               | Always pin explicit, minimal tags (e.g., `python:3.11-slim` or `alpine:3.18`), never use `latest`. |
| `WORKDIR`    | Sets the absolute working directory for instructions that follow.              | Creates directory automatically if it does not exist; avoids messy `cd` commands.                  |
| `COPY`       | Copies files or directories from host context into the container filesystem.   | Preferred over `ADD` for standard local file transfers.                                            |
| `ADD`        | Copies files, extracts local tar archives, or downloads remote URLs.           | Use only when automatic `.tar.gz` extraction is required.                                          |
| `RUN`        | Executes commands inside a new temporary layer and commits the result.         | Chain commands with `&& \` and clean package caches in the same line to reduce image size.         |
| `ENV`        | Sets persistent environment variables inside the image and containers.         | Available during image build and at container runtime.                                             |
| `EXPOSE`     | Informs Docker that the container listens on specified network ports.          | Acts purely as documentation/metadata; does **not** publish the port to the host.                  |
| `ENTRYPOINT` | Defines the fixed executable command run when the container starts.            | Preferred for executables that should always run.                                                  |
| `CMD`        | Provides default arguments for the `ENTRYPOINT` or the default launch command. | Easily overridden by CLI arguments provided at runtime via `docker run`.                           |

### Deep Dive: `ENTRYPOINT` vs. `CMD`

Understanding the interaction between `ENTRYPOINT` and `CMD` is a key DevOps competency:

```dockerfile
ENTRYPOINT ["python", "app.py"]
CMD ["--port", "8080"]
```

- **Default execution:** `python app.py --port 8080`
- **When overridden via CLI (`docker run my-image --port 9090`):** `python app.py --port 9090`
- `ENTRYPOINT` remains fixed; `CMD` acts as configurable parameters.

---

## 🧪 7. Hands-On Lab: Writing, Building & Running Your First Container

In this hands-on project, we containerize a sample lightweight Python web service.

### Directory Structure

```text
Day-24/
├── app/
│   ├── app.py
│   └── requirements.txt
├── Dockerfile
└── README.md
```

### 1. Application Source Code (`app/app.py`)

```python
import http.server
import socketserver
import os

PORT = int(os.environ.get("PORT", 8080))

class HealthCheckHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(b"Hello from Day 24 of 90DaysOfDevOps! Container is healthy.\n")
        else:
            self.send_response(404)
            self.end_headers()

with socketserver.TCPServer(("", PORT), HealthCheckHandler) as httpd:
    print(f"Server serving on port {PORT}")
    httpd.serve_forever()
```

### 2. The Dockerfile (`Dockerfile`)

```dockerfile
# Step 1: Use a minimal, secure base image
FROM python:3.11-slim

# Step 2: Set metadata
LABEL maintainer="cloudwithpreetham"
LABEL description="Day 24 Docker Zero to Hero Sample Service"

# Step 3: Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PORT=8080

# Step 4: Define working directory
WORKDIR /app

# Step 5: Copy application code
COPY app/ /app/

# Step 6: Create a non-privileged system user for container security
RUN useradd -u 1001 -m appuser && \
    chown -R appuser:appuser /app

# Step 7: Switch from root to non-root user
USER appuser

# Step 8: Document target application port
EXPOSE 8080

# Step 9: Define execution entrypoint
CMD ["python", "app.py"]
```

### 3. Build the Image

```bash
docker build -t cloudwithpreetham/devops-web-app:v1.0 .
```

### 4. Run the Container

```bash
docker run -d \
  --name my-web-app \
  -p 8080:8080 \
  --restart unless-stopped \
  cloudwithpreetham/devops-web-app:v1.0
```

### 5. Verify Application Endpoint

```bash
curl http://localhost:8080
# Output: Hello from Day 24 of 90DaysOfDevOps! Container is healthy.
```

---

## 🧱 8. Docker Image Layering, Caching & Copy-on-Write (CoW)

Every instruction in a `Dockerfile` (`FROM`, `COPY`, `RUN`) creates an immutable, read-only layer stored using union filesystems (typically `Overlay2` in modern Linux distributions).

```text
 ┌────────────────────────────────────────────────────────┐
 │   Container Read-Write Layer (Thin writable layer)     │ ◄── Changes, temp files, logs
 ├────────────────────────────────────────────────────────┤
 │   Layer 4: CMD ["python", "app.py"]                    │ ◄── Read-Only Image Layer
 ├────────────────────────────────────────────────────────┤
 │   Layer 3: COPY app/ /app/                             │ ◄── Read-Only Image Layer
 ├────────────────────────────────────────────────────────┤
 │   Layer 2: WORKDIR /app                                │ ◄── Read-Only Image Layer
 ├────────────────────────────────────────────────────────┤
 │   Layer 1: Base Image (python:3.11-slim)               │ ◄── Read-Only Image Layer
 └────────────────────────────────────────────────────────┘
```

### How Layer Caching Works

- Docker evaluates instructions from top to bottom during a build.
- If an instruction and the files it touches have not changed since the last build, Docker reuses the existing cached layer (`Using cache`).
- **Cache Invalidation:** Once a layer changes (e.g., source code modified in `COPY app/`), that layer and **every single layer following it** must be rebuilt from scratch.

### Layer Optimization Rules

1. **Order from least-frequently changed to most-frequently changed:** Install OS libraries and package dependencies (`package.json`, `requirements.txt`) _before_ copying application source code.
2. **Chain `RUN` steps together:** Avoid multiple consecutive `RUN` lines. Combining commands into a single `RUN` statement prevents temporary artifacts (like `apt-get` package lists) from persisting into lower layers.

---

## 🚀 9. Publishing Images to Docker Hub Registry

To distribute container images across clusters or CI/CD pipelines, push them to a container registry like Docker Hub:

### Step 1: Authenticate to Docker Hub

```bash
docker login -u <your-dockerhub-username>
```

### Step 2: Tag the Image with Registry Namespace

```bash
docker tag cloudwithpreetham/devops-web-app:v1.0 <your-dockerhub-username>/devops-web-app:v1.0
docker tag cloudwithpreetham/devops-web-app:v1.0 <your-dockerhub-username>/devops-web-app:latest
```

### Step 3: Push Images to Docker Hub

```bash
docker push <your-dockerhub-username>/devops-web-app:v1.0
docker push <your-dockerhub-username>/devops-web-app:latest
```

### Step 4: Verify Pull on a Clean Environment

```bash
docker run --rm -p 8080:8080 <your-dockerhub-username>/devops-web-app:v1.0
```

---

## 🛠️ 10. Production Troubleshooting & Common Gotchas

### 1. Container Exits Immediately After Starting (`Exited (0)` or `Exited (1)`)

- **Cause:** A Docker container exists only as long as its primary PID 1 process remains active in the foreground. If the command runs in the background (e.g., `service nginx start` or background shell script), PID 1 terminates and the container shuts down immediately.
- **Fix:** Run processes in the foreground. For example, use `CMD ["nginx", "-g", "daemon off;"]`.

### 2. Inability to Connect to Port (`Connection refused` or `Host Port Unreachable`)

- **Cause:**
  1. The application inside the container is bound strictly to `127.0.0.1` (localhost inside container network namespace) instead of `0.0.0.0` (all network interfaces).
  2. Forgot to specify `-p <host_port>:<container_port>` during `docker run`.
- **Fix:** Configure application servers to bind to `0.0.0.0` and confirm port mapping with `docker port <container_name>`.

### 3. Running as Root by Default

- **Cause:** Default Docker containers execute all operations as the root user (`UID 0`). If an attacker escapes the container, they inherit root privileges on the underlying host kernel.
- **Fix:** Always create an unprivileged user in the Dockerfile using `RUN useradd` and enforce `USER <username>`.

### 4. Massive Image Bloat

- **Cause:** Using complete operating system base images (e.g., `ubuntu:latest` at $80\text{ MB}+$ or full `python:3.11` at $1\text{ GB}$) and failing to clean caches.
- **Fix:** Use minimal base images like `alpine` or `-slim` variants and clean up package managers in the same layer (`rm -rf /var/lib/apt/lists/*`).

---

## 💼 11. Senior DevOps Interview Q&A

### Q1: What is the exact difference between `COPY` and `ADD` in a Dockerfile?

**Answer:** `COPY` transfers files and directories from the local build context directly into the image filesystem. `ADD` has two additional capabilities: it can unpack local compressed tar archives directly into destination folders (`tar -x`), and it can fetch files from remote URLs. Best practice dictates using `COPY` for standard transfers to maintain predictability and avoid accidental extraction or untrusted URL downloads.

### Q2: How does Docker achieve process isolation if containers share the host Linux kernel?

**Answer:** Docker utilizes two primary Linux kernel primitives:

- **Linux Namespaces:** Provide virtualized isolation for system resources:
  - `PID` (process tree isolation; container gets its own PID 1)
  - `NET` (isolated network routing, IP addresses, and iptables rules)
  - `MNT` (isolated filesystem mount points)
  - `IPC` (isolated inter-process communication)
  - `UTS` (isolated hostnames)
  - `USER` (UID/GID mappings)
- **Control Groups (`cgroups`):** Restrict and monitor physical hardware consumption (CPU limits, RAM quotas, disk I/O bandwidth).

### Q3: What happens when a container modifies a file that exists in its base image?

**Answer:** Docker utilizes the **Copy-on-Write (CoW)** storage strategy managed by storage drivers like `Overlay2`. Base image layers remain strictly read-only. When a container process attempts to modify a file belonging to an underlying layer, the storage driver copies the file upward into the container's top-level writable layer. The container modifies the copy in its writable layer while the original file in the lower image layer remains unchanged.

### Q4: Why is `EXPOSE` not sufficient to access a containerized web service from an external browser?

**Answer:** `EXPOSE` is purely documentation metadata embedded in the image configuration file indicating which port the process is listening on. It does not alter host iptables rules or open network ports. To route external traffic from the host machine to the container, the operator must explicitly bind ports at runtime using `-p <host_port>:<container_port>` (e.g., `-p 8080:80`).

---

### Reference Links

- **YouTube Video:** [Day-24 Docker Zero to Hero](https://youtu.be/wodLpta-hoQ)
- **Challenge Repository:** [cloudwithpreetham/devops-90-days-challenge](https://github.com/cloudwithpreetham/devops-90-days-challenge)
