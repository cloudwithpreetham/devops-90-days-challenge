# Day 25: Containerizing a Python Django Web Application — Dockerfile Deep Dive, CMD vs. ENTRYPOINT & Networking

> **Reference Video:** [Day-25 | Docker Containerization for Django (Abhishek Veeramalla)](https://youtu.be/3IAvr_O6vao)
> **Challenge Repository:** [cloudwithpreetham/devops-90-days-challenge](https://github.com/cloudwithpreetham/devops-90-days-challenge)

---

## 📌 Table of Contents

1. [Overview & Objectives](#-1-overview--objectives)
2. [Do DevOps Engineers Need Programming Skills?](#-2-do-devops-engineers-need-programming-skills)
3. [Architecture: Containerized Django Lifecycle](#-3-architecture-containerized-django-lifecycle)
4. [Step 1: Django Application Setup & Local Testing](#-4-step-1-django-application-setup--local-testing)
5. [Step 2: Writing the Dockerfile](#-5-step-2-writing-the-dockerfile)
6. [CMD vs. ENTRYPOINT: Deep Dive & Differences](#-6-cmd-vs-entrypoint-deep-dive--differences)
7. [The Host Binding Gotcha: 127.0.0.1 vs. 0.0.0.0](#-7-the-host-binding-gotcha-127001-vs-0000)
8. [Step 3: Building, Running & Verifying the Container](#-8-step-3-building-running--verifying-the-container)
9. [Handling Migrations & Persistent State](#-9-handling-migrations--persistent-state)
10. [Production Gotchas & Common Pitfalls](#-10-production-gotchas--common-pitfalls)
11. [Interview Questions & Answers](#-11-interview-questions--answers)

---

## 🎯 1. Overview & Objectives

In modern cloud platforms, moving beyond generic "Hello World" or NGINX demos to containerizing stateful, multi-tier web applications is essential. This module focuses on taking a real **Python Django** web framework application, understanding its dependencies and runtime behaviors, packaging it securely into a container image, and troubleshooting real-world runtime edge cases.

### Core Objectives

- Understand how web application dependencies (`requirements.txt`) interact with Docker layers.
- Master the difference between Docker instructions, specifically **`CMD`** vs. **`ENTRYPOINT`**.
- Understand Linux socket binding inside containers (`0.0.0.0` vs `127.0.0.1`).
- Execute database migrations (`python manage.py migrate`) cleanly in containerized workflows.
- Expose and publish ports (`-p 8000:8000`) for host-to-container connectivity.

---

## 💡 2. Do DevOps Engineers Need Programming Skills?

A recurring question in DevOps is: _"Does a DevOps or Cloud engineer need to know how to write software like Django or React?"_

- **The Short Answer:** No, you do not need to be a full-stack software engineer who writes business logic or designs complex database models.
- **The Reality:** You **must** understand the execution lifecycle, dependency management, configuration variables, and startup behavior of the applications you deploy.
  - For Python: You need to know `pip`, `venv`, `requirements.txt`, entrypoints, and WSGI/ASGI servers (Gunicorn, Uvicorn).
  - For Java: You need to know Maven/Gradle build outputs (`.jar`, `.war`) and JVM options.
  - For Node.js: You need to know `package.json`, `npm install`, and production start scripts.

If an application crashes inside a container on startup, a DevOps engineer must be able to inspect stack traces, check listening network sockets, and verify environment variable bindings without waiting for the developer.

---

## 🏗️ 3. Architecture: Containerized Django Lifecycle

```text
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │ Host System (EC2 / Local Workstation)                                       │
 │                                                                             │
 │  Incoming Request: http://localhost:8000 or http://<EC2_PUBLIC_IP>:8000     │
 │                                    │                                        │
 │                                    ▼ (Port Forwarding: -p 8000:8000)        │
 │  ┌─────────────────────────────────┴──────────────────────────────────────┐ │
 │  │ Container Namespace (Isolated Network / PID / Mount)                   │ │
 │  │                                                                        │ │
 │  │   ┌────────────────────────────────────────────────────────────────┐   │ │
 │  │   │ Django Application (manage.py runserver 0.0.0.0:8000)          │   │ │
 │  │   │ Listens on ALL network interfaces (eth0, not just lo)          │   │ │
 │  │   └───────────────┬────────────────────────────────┬───────────────┘   │ │
 │  │                   │                                │                   │ │
 │  │                   ▼                                ▼                   │ │
 │  │        ┌─────────────────────┐          ┌───────────────────────┐      │ │
 │  │        │ SQLite / DB Storage │          │ Python 3.9 Runtime    │      │ │
 │  │        │ (db.sqlite3)        │          │ pip dependencies      │      │ │
 │  │        └─────────────────────┘          └───────────────────────┘      │ │
 │  └────────────────────────────────────────────────────────────────────────┘ │
 └─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🛠️ 4. Step 1: Django Application Setup & Local Testing

### Project Directory Structure

```text
Day-25/
├── demo_project/
│   ├── demo_project/
│   │   ├── __init__.py
│   │   ├── settings.py
│   │   ├── urls.py
│   │   └── wsgi.py
│   ├── manage.py
│   └── db.sqlite3
├── Dockerfile
├── requirements.txt
└── README.md
```

### 1. Initialize Python Environment & Install Django

```bash
# Update local packages and install python virtual environment tools
sudo apt-get update -y
sudo apt-get install python3-pip python3-venv -y

# Create and activate an isolated virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Django
pip install django
```

### 2. Scaffold the Django Project

```bash
# Create a new project called 'demo_project'
django-admin startproject demo_project
cd demo_project

# Freeze project dependencies
pip freeze > requirements.txt
```

Your `requirements.txt` should contain at minimum:

```text
asgiref>=3.6.0
Django>=4.1.7
sqlparse>=0.4.3
```

---

## 📄 5. Step 2: Writing the Dockerfile

Place the `Dockerfile` inside the project directory alongside `requirements.txt` and `manage.py`:

```dockerfile
# Step 1: Use an official lightweight Python runtime
FROM python:3.9-slim

# Step 2: Prevent Python from writing .pyc files and enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Step 3: Set working directory inside the container
WORKDIR /app

# Step 4: Copy dependency list first to leverage Docker layer caching
COPY requirements.txt /app/

# Step 5: Install dependencies without caching wheels to save space
RUN pip install --no-cache-dir -r requirements.txt

# Step 6: Copy application source code into container
COPY . /app/

# Step 7: Expose port 8000 for documentation and orchestration
EXPOSE 8000

# Step 8: Define the default container execution command
ENTRYPOINT ["python", "manage.py"]
CMD ["runserver", "0.0.0.0:8000"]
```

### Key Directives Explained

1. **`ENV PYTHONUNBUFFERED=1`**: Ensures Python standard output and error streams are sent directly to terminal/container logs without buffering, making debugging with `docker logs` instantaneous.
2. **Layer Caching Optimization**: Copying `requirements.txt` and running `pip install` _before_ copying the full project directory ensures that code modifications do not invalidate the cached dependency layer.

---

## ⚖️ 6. CMD vs. ENTRYPOINT: Deep Dive & Differences

One of the most heavily tested Docker topics in technical interviews is the distinction between `ENTRYPOINT` and `CMD`.

| Feature                    | `ENTRYPOINT`                                                                            | `CMD`                                                                          |
| :------------------------- | :-------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------- |
| **Purpose**                | Defines the fixed binary or command that **always** executes when the container starts. | Defines default arguments or a fallback command that can be easily overridden. |
| **Overridable at Runtime** | Requires the explicit `--entrypoint` CLI flag to override.                              | Easily overridden by appending arguments to `docker run <image> <new_args>`.   |
| **Production Role**        | Treats the container like an executable CLI tool.                                       | Provides default parameters for the `ENTRYPOINT`.                              |

### Execution Forms (Exec vs Shell Form)

#### 1. Shell Form

```dockerfile
CMD python manage.py runserver 0.0.0.0:8000
```

- Runs inside a subshell: `/bin/sh -c "python manage.py runserver 0.0.0.0:8000"`.
- ⚠️ **Trap:** The Python process becomes a child of `/bin/sh` (PID != 1). It will not receive UNIX termination signals (`SIGTERM`, `SIGINT`) sent by `docker stop`, causing the container to hang until killed abruptly via `SIGKILL` after the 10-second grace period.

#### 2. Exec Form (Recommended)

```dockerfile
ENTRYPOINT ["python", "manage.py"]
CMD ["runserver", "0.0.0.0:8000"]
```

- Runs directly without a wrapping shell.
- Python receives PID 1 and cleanly captures OS signals for graceful termination.

### Combining Both for Flexibility

When combined:

```dockerfile
ENTRYPOINT ["python", "manage.py"]
CMD ["runserver", "0.0.0.0:8000"]
```

- Running normally:

  ```bash
  docker run -p 8000:8000 my-django-app
  # Executes: python manage.py runserver 0.0.0.0:8000
  ```

- Overriding the `CMD` to run database migrations without changing the Dockerfile:

  ```bash
  docker run my-django-app migrate
  # Executes: python manage.py migrate
  ```

- Overriding the `CMD` to run Django shell:

  ```bash
  docker run -it my-django-app shell
  # Executes: python manage.py shell
  ```

---

## 🌐 7. The Host Binding Gotcha: 127.0.0.1 vs. 0.0.0.0

A frequent beginner mistake when containerizing web applications is launching the server bound to `127.0.0.1`:

```bash
# ❌ INCORRECT inside a Docker container:
python manage.py runserver
# or
python manage.py runserver 127.0.0.1:8000
```

### Why Does This Fail?

- Inside a Docker container, `127.0.0.1` represents the container's **local loopback interface (`lo`)**.
- The port `8000` is therefore bound only to internal loopback calls inside the container namespace.
- When an external user hits `http://localhost:8000` on the host, the request is forwarded by the Docker proxy to the container's network adapter (`eth0`).
- Because Django is listening only on `lo` and not `eth0`, the container rejects the connection, resulting in:

  ```text
  curl: (52) Empty reply from server
  # or
  ERR_CONNECTION_REFUSED
  ```

### The Solution

Bind the application explicitly to **`0.0.0.0`** (INADDR_ANY):

```bash
# ✅ CORRECT inside Docker:
python manage.py runserver 0.0.0.0:8000
```

This tells Django to listen on **all** available network interfaces inside the container, allowing traffic forwarded from the host gateway to reach the application.

---

## 🚀 8. Step 3: Building, Running & Verifying the Container

### 1. Build the Docker Image

```bash
# Build the image with tag 'django-web-app:v1'
docker build -t django-web-app:v1 .

# Inspect generated image layers and size
docker images | grep django-web-app
```

### 2. Run the Container in Detached Mode

```bash
docker run -d \
  --name django-app-instance \
  -p 8000:8000 \
  django-web-app:v1
```

### 3. Check Container Status and Logs

```bash
# Verify the container is running and healthy
docker ps

# Inspect unbuffered application logs
docker logs -f django-app-instance
```

_Expected Output:_

```text
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).
October 04, 2026 - 06:15:00
Django version 4.1.7, using settings 'demo_project.settings'
Starting development server at http://0.0.0.0:8000/
Quit the server with CONTROL-C.
```

### 4. Verify External Connectivity

From host terminal or browser:

```bash
curl -I http://localhost:8000
```

_Expected Response:_

```text
HTTP/1.1 200 OK
Date: Sun, 04 Oct 2026 06:15:30 GMT
Server: WSGIServer/0.2 CPython/3.9.18
Content-Type: text/html
```

---

## 🗄️ 9. Handling Migrations & Persistent State

By default, running `python manage.py runserver` throws an unapplied migrations warning if initial tables are not set up:

```text
You have 18 unapplied migration(s). Your project may not work properly until you apply the migrations for app(s): admin, auth, contenttypes, sessions.
Run 'python manage.py migrate' to apply them.
```

### How to Run Migrations with Dockerized Django

#### Option A: Running Ephemeral Migration Container

Leveraging the `ENTRYPOINT` pattern:

```bash
docker run --rm django-web-app:v1 migrate
```

#### Option B: Executing Inside the Running Container

```bash
docker exec -it django-app-instance python manage.py migrate
```

#### Option C: Production Startup Script (`entrypoint.sh`)

In production scenarios, you can wrap startup commands in an entrypoint shell script to execute migrations automatically prior to starting the web server:

```bash
#!/bin/sh
set -e

echo "Applying database migrations..."
python manage.py migrate --noinput

echo "Starting server..."
exec "$@"
```

---

## ⚠️ 10. Production Gotchas & Common Pitfalls

1. **Running Development Server in Production:**
   - `python manage.py runserver` is single-threaded, unhardened, and unsuitable for production loads.
   - _Production Solution:_ Use a production WSGI HTTP server like **Gunicorn**:

     ```dockerfile
     RUN pip install gunicorn
     CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "demo_project.wsgi:application"]
     ```

2. **Root User Security Risks:**
   - By default, Docker executes as `root`, creating security vulnerabilities in multi-tenant or Kubernetes environments.
   - _Fix:_ Create and switch to a non-privileged system user:

     ```dockerfile
     RUN useradd -m -u 1001 appuser
     USER appuser
     ```

3. **Exposing Ports vs Publishing Ports:**
   - `EXPOSE 8000` in the Dockerfile only acts as documentation. It does **not** map the port to the host machine.
   - Always map the port explicitly using `-p <host_port>:<container_port>` when launching the container.

---

## 💼 11. Interview Questions & Answers

### Q1: What happens if you define both `ENTRYPOINT` and `CMD` in a Dockerfile?

**Answer:** When both instructions are present, `ENTRYPOINT` acts as the mandatory executable, while `CMD` provides the default arguments appended to it. If the user passes arguments during `docker run <image> <args>`, those arguments override `CMD` but are still passed directly into `ENTRYPOINT`.

### Q2: Why will `curl http://localhost:8000` fail if Django is started with `python manage.py runserver 127.0.0.1:8000` inside a Docker container?

**Answer:** `127.0.0.1` binds exclusively to the loopback interface (`lo`) inside the container's isolated network namespace. Forwarded traffic from the host hits the container's external interface (`eth0`). Because nothing is listening on `eth0`, the connection is immediately refused. The server must be bound to `0.0.0.0` to listen on all interfaces.

### Q3: Why is Exec form preferred over Shell form for `CMD` and `ENTRYPOINT`?

**Answer:** Exec form (`["executable", "param"]`) executes the process directly as PID 1 without spawning a shell interpreter. This ensures operating system signals like `SIGTERM` and `SIGINT` (sent during `docker stop` or Kubernetes rolling updates) are received directly by the application, allowing graceful connection termination and state cleanup instead of abrupt shutdown after a timeout.

### Q4: How should static files and database migrations be handled in containerized Django deployments?

**Answer:** In production:

1. Static files should be collected during the build or pipeline via `python manage.py collectstatic --noinput` and served via NGINX or an S3/CloudFront bucket.
2. Migrations should never run concurrently on multiple replicas; they should run either as a dedicated CI/CD pipeline step, an ephemeral init-container, or a Kubernetes `Job` prior to releasing new web pods.
