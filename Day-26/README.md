# Day 26: Multi-Stage Docker Builds & Distroless Container Images — Image Optimization & Security Hardening

> **Reference Video:** [Day-26 | Multi Stage Docker Builds | Reduce Image Size by 800 % | Distroless Container Images (Abhishek Veeramalla)](http://www.youtube.com/watch?v=yyJrZgoNal0)
> **Challenge Repository:** [cloudwithpreetham/devops-90-days-challenge](https://github.com/cloudwithpreetham/devops-90-days-challenge)

---

## 📌 Table of Contents

1. [Overview & The Production Image Problem](#-1-overview--the-production-image-problem)
2. [Understanding Multi-Stage Docker Builds](#-2-understanding-multi-stage-docker-builds)
3. [Deep Dive into Distroless Container Images](#-3-deep-dive-into-distroless-container-images)
4. [Compiled Languages vs. Runtime-Dependent Languages](#4-compiled-languages-vs-runtime-dependent-languages)
5. [Hands-On Lab: Single-Stage vs. Multi-Stage Distroless Go Build](#-5-hands-on-lab-single-stage-vs-multi-stage-distroless-go-build)
   - [The Calculator Application Code](#the-calculator-application-code)
   - [Single-Stage Build Analysis (861 MB)](#single-stage-build-analysis-861-mb)
   - [Multi-Stage Distroless Build with `scratch` (1.83 MB)](#multi-stage-distroless-build-with-scratch-183-mb)
   - [Benchmark & Size Metrics](#benchmark--size-metrics)
6. [Multi-Stage Build Pattern for Java & Microservices](#-6-multi-stage-build-pattern-for-java--microservices)
7. [Enterprise Security & Vulnerability Hardening](#-7-enterprise-security--vulnerability-hardening)
8. [Common Production Pitfalls & Gotchas](#-8-common-production-pitfalls--gotchas)
9. [Senior DevOps Scenario Interview Q&A](#-9-senior-devops-scenario-interview-qa)

---

## 🛑 1. Overview & The Production Image Problem

When engineering container images for production services, developers commonly begin with a familiar operating system base image, such as `ubuntu`, `debian`, or `centos`. While this provides an easy environment to install toolchains using package managers like `apt` or `yum`, it causes severe inefficiencies in enterprise production environments:

1. **Severe Image Bloat:** Compilers (e.g., `gcc`, Go SDK, JDK), package managers, intermediate build caches, documentation, and system headers persist in the deployed artifact. A microservice binary requiring a few megabytes ends up wrapped inside hundreds of megabytes of unnecessary OS files.
2. **Network Latency & Storage Overhead:** Pushing and pulling gigabyte-sized containers slows down CI/CD test runners, delays automated rollouts, and degrades horizontal pod autoscaling (HPA) responsiveness in Kubernetes.
3. **Massive Attack Surface:** Including shell utilities (`/bin/sh`, `/bin/bash`), network downloaders (`curl`, `wget`), and administration utilities (`find`, `sudo`) equips potential attackers with built-in tools for post-exploitation discovery, lateral movement, and privilege escalation.
4. **Vulnerability Scanner Noise:** Security scanners (such as Trivy, Clair, or Snyk) flag dozens or hundreds of OS-level CVEs stemming from packages that the application runtime never invokes.

```text
Traditional Single-Stage Image:
┌────────────────────────────────────────────────────────────────────────┐
│ Ubuntu OS + Compilers + SDKs + apt + curl + Source + Static Binary     │ ➔ ~861 MB
└────────────────────────────────────────────────────────────────────────┘

Multi-Stage Image with scratch:
┌─────────────────┐
│  Static Binary  │ ➔ ~1.83 MB (Only pure runtime executable)
└─────────────────┘
```

---

## 🏗️ 2. Understanding Multi-Stage Docker Builds

Introduced in Docker 17.05, **Multi-Stage Builds** allow developers to organize a single `Dockerfile` into distinct phases using multiple `FROM` instructions.

```text
  ┌─────────────────────────────────────────┐
  │ Stage 1: Build Phase                    │
  │ FROM ubuntu / golang AS builder         │
  │ - Compilers, package managers, tools    │
  │ - Compiles application static binary    │
  └────────────────────┬────────────────────┘
                       │
                       │ Artifact Transfer
                       │ (COPY --from=builder)
                       ▼
  ┌─────────────────────────────────────────┐
  │ Stage 2: Final Minimal Runtime          │
  │ FROM scratch / distroless               │
  │ - No compilers, no package managers     │
  │ - Copies ONLY the compiled binary       │
  │ - Only this layer becomes final image   │
  └─────────────────────────────────────────┘
```

### Key Principles

- Each `FROM` directive resets the filesystem state and initializes a new stage with a clean base image.
- Stages can be assigned aliases using `FROM <image> AS <stage_name>`.
- Artifacts compiled in earlier stages are selectively copied into the current stage using `COPY --from=<stage_name> <src> <dest>`.
- Intermediate stages, temporary caches, compilers, and source code are discarded. Only the final stage constitutes the output image.

---

## 🛡️ 3. Deep Dive into Distroless Container Images

**Distroless images** (developed and maintained by GoogleContainerTools) contain strictly an application and its minimal runtime dependencies. They intentionally omit:

- System shells (`bash`, `sh`, `ash`)
- Linux utilities (`ls`, `find`, `cat`, `curl`, `wget`)
- Package managers (`apt`, `dpkg`, `apk`, `rpm`, `yum`)

### Base Image Hierarchy

| Image Type              | Example                    | Typical Footprint | Shell Included? | Package Manager? | Ideal Workload                          |
| :---------------------- | :------------------------- | :---------------- | :-------------- | :--------------- | :-------------------------------------- |
| **Full OS**             | `ubuntu:22.04`             | 70 – 120 MB       | Yes (`bash`)    | Yes (`apt`)      | Heavy compilation stages                |
| **Slim Linux**          | `alpine:3.18`              | 5 – 7 MB          | Yes (`ash`)     | Yes (`apk`)      | Microservices requiring shell debugging |
| **Language Distroless** | `gcr.io/distroless/java17` | 30 – 150 MB       | No              | No               | Java, Python, Node runtimes             |
| **Pure Empty**          | `scratch`                  | 0 MB              | No              | No               | Statically compiled Go / Rust binaries  |

---

## ⚙️ 4. Compiled Languages vs. Runtime-Dependent Languages

Selecting the appropriate final runtime base image depends on how the application executes:

| Runtime Model                  | Examples              | Build Output                 | Final Stage Target          | Expected Size        |
| :----------------------------- | :-------------------- | :--------------------------- | :-------------------------- | :------------------- |
| **Statically Compiled**        | Go, Rust, C (static)  | Self-contained static binary | `scratch`                   | **~1.5 MB – 20 MB**  |
| **Virtual Machine / Bytecode** | Java, Kotlin, Scala   | `.jar` or `.war` archive     | `gcr.io/distroless/java17`  | **~100 MB – 200 MB** |
| **Interpreted**                | Python, Ruby, Node.js | Source scripts & wheels      | `gcr.io/distroless/python3` | **~50 MB – 120 MB**  |

---

## 🧪 5. Hands-On Lab: Single-Stage vs. Multi-Stage Distroless Go Build

### The Calculator Application Code

Create a lightweight command-line Go application inside `calculator.go`:

```go
package main

import (
 "fmt"
)

func main() {
 var num1, num2 float64
 var op string

 fmt.Println("=== CLI Calculator ===")
 fmt.Print("Enter first number: ")
 if _, err := fmt.Scanln(&num1); err != nil {
  fmt.Println("Invalid input.")
  return
 }

 fmt.Print("Enter operator (+, -, *, /): ")
 if _, err := fmt.Scanln(&op); err != nil {
  fmt.Println("Invalid input.")
  return
 }

 fmt.Print("Enter second number: ")
 if _, err := fmt.Scanln(&num2); err != nil {
  fmt.Println("Invalid input.")
  return
 }

 switch op {
 case "+":
  fmt.Printf("Result: %.2f\n", num1+num2)
 case "-":
  fmt.Printf("Result: %.2f\n", num1-num2)
 case "*":
  fmt.Printf("Result: %.2f\n", num1*num2)
 case "/":
  if num2 == 0 {
   fmt.Println("Error: Division by zero.")
   return
  }
  fmt.Printf("Result: %.2f\n", num1/num2)
 default:
  fmt.Println("Error: Unsupported operator.")
 }
}
```

---

### Single-Stage Build Analysis (861 MB)

Create `Dockerfile.single`:

```dockerfile
# Single-stage build using Ubuntu
FROM ubuntu:22.04

# Update packages and install full Golang compiler suite
RUN apt-get update && apt-get install -y golang-go && rm -rf /var/lib/apt/lists/*

ENV GO111MODULE=off
WORKDIR /app

# Copy application source
COPY calculator.go /app/calculator.go

# Compile binary
RUN go build -o calculator calculator.go

# Define entrypoint
ENTRYPOINT ["/app/calculator"]
```

Build and inspect the image:

```bash
docker build -t calculator:single-stage -f Dockerfile.single .
docker images | grep calculator
```

Output:

```text
REPOSITORY    TAG            IMAGE ID       CREATED          SIZE
calculator    single-stage   a41e9b21f3cd   20 seconds ago   861MB
```

_Result:_ **861 MB** for a basic calculator because the final image bundles Ubuntu, the Go compiler, system headers, and package manager databases.

---

### Multi-Stage Distroless Build with `scratch` (1.83 MB)

Create `Dockerfile.multistage`:

```dockerfile
# Stage 1: Build & Compilation Environment
FROM ubuntu:22.04 AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y golang-go && rm -rf /var/lib/apt/lists/*

ENV GO111MODULE=off
WORKDIR /app

COPY calculator.go .

# Compile a statically linked binary (disable dynamic C bindings)
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o calculator calculator.go

# Stage 2: Minimal Distroless Runtime
FROM scratch

WORKDIR /

# Copy ONLY the static binary compiled in Stage 1
COPY --from=builder /app/calculator /calculator

# Container entrypoint
ENTRYPOINT ["/calculator"]
```

Build and inspect the multi-stage image:

```bash
docker build -t calculator:multi-stage -f Dockerfile.multistage .
docker images | grep calculator
```

Output:

```text
REPOSITORY    TAG            IMAGE ID       CREATED          SIZE
calculator    multi-stage    9f8c1b34e2ab   10 seconds ago   1.83MB
calculator    single-stage   a41e9b21f3cd   2 minutes ago    861MB
```

---

### Benchmark & Size Metrics

| Strategy                    | Base Image     | Components Present                          | Final Size  | Reduction Factor                     |
| :-------------------------- | :------------- | :------------------------------------------ | :---------- | :----------------------------------- |
| **Single-Stage**            | `ubuntu:22.04` | Ubuntu OS, apt, Go SDK, source code, binary | **861 MB**  | Baseline (1x)                        |
| **Multi-Stage (`scratch`)** | `scratch`      | Compiled static executable only             | **1.83 MB** | **~470x Smaller (~99.8% reduction)** |

---

## ☕ 6. Multi-Stage Build Pattern for Java & Microservices

For languages that require an execution runtime (like Java), multi-stage builds compile artifacts with a heavy SDK image and execute them inside an optimized JRE or Distroless base:

```dockerfile
# Stage 1: Maven Builder
FROM maven:3.8.6-openjdk-17-slim AS builder

WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Distroless Java Runtime
FROM gcr.io/distroless/java17-debian11:nonroot

WORKDIR /app
COPY --from=builder /build/target/*.jar /app/application.jar

USER nonroot:nonroot
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/application.jar"]
```

_Outcome:_ The final image size drops from **>1 GB** (Maven + JDK + Debian) down to **~150–200 MB** (only the JRE and `.jar` artifact).

---

## 🔒 7. Enterprise Security & Vulnerability Hardening

1. **Elimination of Living-off-the-Land (LotL) Tools:** Attackers who identify an application-level vulnerability (e.g., remote code execution or file inclusion) cannot spawn an interactive shell (`/bin/sh`) or download scripts (`curl`, `wget`).
2. **Immutability of the Filesystem:** Without package managers (`apt`, `apk`), no untrusted binaries or packages can be installed inside running pods.
3. **Drastic CVE Reduction:** Enterprise security policies block images with Critical or High severity CVEs. By stripping out OS packages, vulnerabilities are reduced to near zero.
4. **Least-Privilege Non-Root Execution:** Distroless images ship with a predefined non-root user (`nonroot:nonroot` UID/GID 65532), ensuring containers do not run with root permissions by default.

---

## ⚠️ 8. Common Production Pitfalls & Gotchas

1. **Dynamically Linked C Libraries with `scratch`:**
   - _Problem:_ Running a Go binary on `scratch` throws `exec /calculator: no such file or directory`.
   - _Cause:_ The binary was dynamically linked to the host's `glibc` library, which does not exist in `scratch`.
   - _Fix:_ Explicitly compile with `CGO_ENABLED=0` to ensure all system dependencies are statically linked into the executable.
2. **Missing Root CA Certificates:**
   - _Problem:_ Applications running on `scratch` fail when making HTTPS outbound requests (`x509: certificate signed by unknown authority`).
   - _Fix:_ Copy root certificates from the builder stage:
     `COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/`
3. **Attempting to Shell into Distroless Containers:**
   - _Problem:_ Running `kubectl exec -it <pod> -- /bin/sh` or `docker exec -it <container> sh` returns an error: `executable file not found in $PATH`.
   - _Remedy:_ Use Kubernetes ephemeral debug containers (`kubectl debug`) or utilize `:debug` tags of Distroless images during development (`gcr.io/distroless/base:debug`).

---

## 💼 9. Senior DevOps Scenario Interview Q&A

### Q1: What are multi-stage Docker builds and how do they benefit CI/CD and production environments?

**Answer:** Multi-stage builds divide a `Dockerfile` into distinct logical stages using multiple `FROM` instructions. Build tools, compilers, and test dependencies remain isolated to temporary builder stages, while only the compiled static binaries or application packages are copied into a clean, minimal runtime stage (`COPY --from=builder`). This significantly reduces image size, accelerates image push/pull operations across CI/CD runners, and hardens the container attack surface.

### Q2: What is the core difference between Alpine Linux and Distroless images?

**Answer:** Alpine Linux is a lightweight Linux distribution based on `musl libc` and BusyBox. It includes a basic package manager (`apk`) and an interactive shell (`ash`). A Distroless image (such as Google Distroless) is not an operating system distribution; it contains strictly the application and its direct runtime dependencies (e.g., Python or JRE), completely omitting package managers, interactive shells, and Linux command-line utilities.

### Q3: How do Distroless containers enhance container security in Kubernetes clusters?

**Answer:** By excluding shells (`/bin/sh`, `/bin/bash`), network downloaders (`curl`, `wget`), and core utilities (`find`, `chmod`), distroless containers prevent attackers from executing shell injection payloads, pulling malicious scripts, or establishing interactive terminal sessions if an application is compromised. Furthermore, eliminating hundreds of OS-level libraries minimizes the attack surface and reduces CVE scanner findings.

### Q4: Can every programming stack be deployed on `FROM scratch`?

**Answer:** No. The `scratch` base image is an empty starting point with zero bytes. It is suitable only for statically compiled, self-contained binaries such as those generated by Go or Rust (with `CGO_ENABLED=0`). Interpreted languages (Python, Node.js) and virtual-machine languages (Java) require language-specific runtimes, interpreters, and dynamic shared libraries, requiring language-specific Distroless images or slim base images instead.
**Answer:** Multi-stage builds divide a `Dockerfile` into distinct logical stages using multiple `FROM` instructions. Build tools, compilers, and test dependencies remain isolated to temporary builder stages, while only the compiled static binaries or application packages are copied into a clean, minimal runtime stage (`COPY --from=builder`). This significantly reduces image size, accelerates image push/pull operations across CI/CD runners, and hardens the container attack surface.
