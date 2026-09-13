# Day 23: Introduction to Containers — Virtual Machines vs. Containers & Linux Internals

> **Reference Video:** [Day-23 | Introduction to Containers | Learn about containers in easy way (Abhishek Veeramalla)](https://youtu.be/7JZP345yVjw)
> **Challenge Repository:** [cloudwithpreetham/devops-90-days-challenge](https://github.com/cloudwithpreetham/devops-90-days-challenge)

---

## 📌 Table of Contents

1. [The Evolution of Application Deployment](#1-the-evolution-of-application-deployment)
2. [Virtual Machines vs. Containers: Architectural Deep Dive](#2-virtual-machines-vs-containers-architectural-deep-dive)
3. [The Secret Sauce: Linux Kernel Internals](#3-the-secret-sauce-linux-kernel-internals)
   - [Namespaces (Process & Resource Isolation)](#a-linux-namespaces-isolation)
   - [Control Groups (cgroups - Resource Limiting)](#b-control-groups-cgroups-resource-metering)
   - [Chroot & Pivot_root (Filesystem Isolation)](#c-chroot--pivot_root-isolated-filesystem)
4. [What Exactly is a Container?](#4-what-exactly-is-a-container)
5. [The Container Ecosystem & OCI Standards](#5-the-container-ecosystem--oci-standards)
6. [Hands-On Lab: Observing Isolation from the Host Terminal](#6-hands-on-lab-observing-isolation-from-the-host-terminal)
7. [Enterprise Decision Matrix: VMs vs. Containers](#7-enterprise-decision-matrix-vms-vs-containers)
8. [Production Gotchas & Common Pitfalls](#8-production-gotchas--common-pitfalls)
9. [Interview Q&A (Scenario-Based)](#9-interview-qa-scenario-based)

---

## 🏛️ 1. The Evolution of Application Deployment

To appreciate why containers dominate modern cloud-native architectures, we must examine the problems faced across each computing paradigm:

```text
┌─────────────────────────────────┐
│     1. Bare Metal Era           │  One app per physical server; 10-15% utilization;
│    (Traditional Servers)        │  dependency conflicts; extremely slow provisioning.
└────────────────┬────────────────┘
                 │
                 ▼
┌─────────────────────────────────┐
│     2. Virtual Machine Era      │  Hypervisor runs multiple Guest OSs; high resource overhead;
│     (Hardware Virtualization)   │  gigabyte image sizes; minutes to boot up.
└────────────────┬────────────────┘
                 │
                 ▼
┌─────────────────────────────────┐
│     3. Container Era            │  OS-level virtualization; shared host kernel;
│    (Process Isolation)          │  lightweight (MBs); millisecond boot times; immutable.
└─────────────────────────────────┘
```

### The "Works on My Machine" Syndrome

Before containerization, deploying applications across disparate environments (Development $\rightarrow$ QA $\rightarrow$ Staging $\rightarrow$ Production) repeatedly failed due to subtle environment discrepancies:

- Operating system library discrepancies (e.g., `glibc 2.28` vs `glibc 2.31`).
- Differing runtime engine versions (e.g., Python `3.8` on developer laptops vs `3.6` on RHEL production hosts).
- Environmental path configurations and unmanaged system dependencies.

Containers eliminate this problem by packaging the application code **together with every dependency, library, binary, and environment configuration** into a single immutable artifact.

---

## ⚖️ 2. Virtual Machines vs. Containers: Architectural Deep Dive

### High-Level Architecture Comparison

```text
        VIRTUAL MACHINE ARCHITECTURE                       CONTAINER ARCHITECTURE
 ┌─────────────────────────────────────────┐     ┌─────────────────────────────────────────┐
 │ App A     │ App B      │ App C          │     │ App A     │ App B      │ App C          │
 ├───────────┼────────────┼────────────────┤     ├───────────┼────────────┼────────────────┤
 │ Bins/Libs │ Bins/Libs  │ Bins/Libs      │     │ Bins/Libs │ Bins/Libs  │ Bins/Libs      │
 ├───────────┼────────────┼────────────────┤     ├─────────────────────────────────────────┤
 │ Guest OS  │ Guest OS   │ Guest OS       │     │     Container Runtime Engine            │
 │ (Ubuntu)  │ (RHEL)     │ (Debian)       │     │       (Docker / containerd)             │
 ├─────────────────────────────────────────┤     ├─────────────────────────────────────────┤
 │        Hypervisor (Type 1 or 2)         │     │         Host Operating System           │
 │       (KVM / VMware ESXi / Xen)         │     │             (Linux Kernel)              │
 ├─────────────────────────────────────────┤     ├─────────────────────────────────────────┤
 │             Host Hardware               │     │             Host Hardware               │
 │           (CPU, RAM, Disk)              │     │           (CPU, RAM, Disk)              │
 └─────────────────────────────────────────┘     └─────────────────────────────────────────┘
```

### Comparative Breakdown

| Metric                   | Virtual Machines (VMs)                                            | Containers                                                           |
| :----------------------- | :---------------------------------------------------------------- | :------------------------------------------------------------------- |
| **Virtualization Level** | Hardware-level (emulates physical hardware via hypervisor)        | Operating System-level (isolates user-space processes)               |
| **Kernel Model**         | Each VM runs its own independent Guest OS kernel                  | All containers share the single underlying Host OS kernel            |
| **Startup Time**         | Minutes (must boot full operating system, drivers, and services)  | Milliseconds to seconds (starts a standard Linux process)            |
| **Storage Footprint**    | Gigabytes to tens of Gigabytes (full OS disk image)               | Megabytes (only application code + essential libraries)              |
| **Resource Allocation**  | Hard allocation up-front (VM reserves 8GB RAM regardless of use)  | Elastic / Dynamic (consumes only active memory on host)              |
| **Density**              | Low to moderate (tens of VMs per high-end bare metal host)        | High (hundreds of containers per host)                               |
| **Isolation Strength**   | Complete hardware-level hypervisor boundary (very high isolation) | Process-level namespace boundary (requires proper security controls) |

---

## 🐧 3. The Secret Sauce: Linux Kernel Internals

A container is **not** a mini-virtual machine. Under the hood, containers rely on three fundamental features built natively into the Linux kernel:

```text
  ┌─────────────────────────────────────────────────────────────┐
  │                 CONTAINER RUNTIME BOUNDARY                  │
  │                                                             │
  │   ┌────────────────────┐          ┌─────────────────────┐   │
  │   │  Linux Namespaces  │          │   Control Groups    │   │
  │   │   (What you see)   │          │      (cgroups)      │   │
  │   │                    │          │  (What you can use) │   │
  │   │ - PID (Processes)  │          │ - CPU limits        │   │
  │   │ - NET (IPs, Ports) │          │ - Memory limits     │   │
  │   │ - MNT (Mounts)     │          │ - I/O throttling    │   │
  │   │ - UTS (Hostnames)  │          │ - Process quotas    │   │
  │   │ - IPC (Memory IPC) │          └─────────────────────┘   │
  │   │ - USER (User IDs)  │                     │              │
  │   └─────────┬──────────┘                     │              │
  │             └────────────────┬───────────────┘              │
  │                              ▼                              │
  │                 ┌─────────────────────────┐                 │
  │                 │    chroot / pivot_root  │                 │
  │                 │  (Isolated Filesystem)  │                 │
  │                 └─────────────────────────┘                 │
  └──────────────────────────────┬──────────────────────────────┘
                                 ▼
                     Linux Host Kernel Shared
```

### A. Linux Namespaces (Isolation)

Namespaces provide isolation by partitioning kernel resources such that a group of processes sees one set of resources while another group sees another:

1. **PID (Process ID) Namespace:**
   - Gives the container its own process tree.
   - The primary application process inside the container runs as `PID 1`.
   - On the host OS, that same process appears with its true host PID (e.g., `PID 34211`).

2. **NET (Network) Namespace:**
   - Provides an isolated virtual network stack: private loopback device, virtual Ethernet interface (`veth`), separate routing table, and firewall rules.
   - Allows two containers to bind to port `8080` simultaneously on the same host without port collisions.

3. **MNT (Mount) Namespace:**
   - Isolates filesystem mount points. The container cannot see or access host directories unless explicitly mounted via volumes.

4. **UTS (UNIX Timesharing System) Namespace:**
   - Allows the container to have its own unique hostname and domain name distinct from the host machine.

5. **IPC (Inter-Process Communication) Namespace:**
   - Prevents processes inside a container from accessing POSIX message queues or shared memory segments of host processes.

6. **USER Namespace:**
   - Maps user and group IDs between the container and the host.
   - Enables running a process as `root` (UID `0`) inside the container while mapping it to an unprivileged standard user (e.g., UID `1001`) on the host system.

---

### B. Control Groups (`cgroups` - Resource Metering)

While namespaces restrict what a container can **see**, `cgroups` restrict what a container can **consume**:

- **Memory Limits:** Prevents a rogue container from triggering an Out-Of-Memory (OOM) crash across the entire host host kernel.
- **CPU Quotas & Shares:** Restricts CPU core execution time using Completely Fair Scheduler (CFS) bandwidth controls.
- **Block I/O (Disk):** Limits read/write throughput to disks (`bps`/`iops`).
- **PIDs Limit:** Prevents fork-bomb denial-of-service attacks by capping the maximum number of child processes a container can spawn.

---

### C. Chroot / Pivot_root (Isolated Filesystem)

Changes the apparent root directory (`/`) for the running process:

- A container based on `alpine` sees only the Alpine Linux root directory structure (`/bin`, `/etc`, `/usr`), completely isolated from the host OS filesystem (`/home`, `/var/log`).

---

## 📦 4. What Exactly is a Container?

> **Fundamental Truth:** A container is simply a standard Linux process that has been enclosed in a set of **Namespaces**, restricted by **cgroups**, and rooted in an **isolated filesystem**.

When you execute:

```bash
docker run -d --name web-nginx -p 80:80 nginx
```

The container engine does **not** boot an operating system. Instead, it:

1. Downloads the image root filesystem (rootfs) layers.
2. Creates isolated namespaces (PID, NET, MNT, UTS, IPC).
3. Configures `cgroups` rules for CPU/Memory constraints.
4. Mounts the rootfs and executes `pivot_root`.
5. Starts the Nginx binary as `PID 1` inside that execution jail.

---

## 🌐 5. The Container Ecosystem & OCI Standards

To avoid vendor lock-in, the industry established the **Open Container Initiative (OCI)** in 2015:

```text
┌─────────────────────────────────────────────────────────────┐
│                 High-Level Container Tools                  │
│               (Docker CLI, Podman, nerdctl)                 │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                  Container Runtime Engine                   │
│             (containerd, CRI-O - Image pulling, lifecycle)  │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                   Low-Level OCI Runtime                     │
│              (runc - calls namespaces, cgroups)             │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                        Linux Kernel                         │
└─────────────────────────────────────────────────────────────┘
```

- **OCI Image Specification:** Defines how container images are layered, tarred, and manifested.
- **OCI Runtime Specification (`runc`):** Standardizes how containers are spawned using kernel primitives.
- **Containerd / CRI-O:** High-level container engines responsible for image distribution, network setup, and delegating execution to `runc`.

---

## 🧪 6. Hands-On Lab: Observing Isolation from the Host Terminal

### Lab Objective

Prove that container processes are visible directly on the host kernel and inspect their namespaces.

#### Step 1: Run a Detached Alpine Container

```bash
docker run -d --name test-sandbox alpine sleep 3600
```

#### Step 2: Check Process Inside the Container

```bash
docker exec test-sandbox ps aux
```

_Output:_

```text
PID   USER     TIME  COMMAND
    1 root      0:00 sleep 3600
    7 root      0:00 ps aux
```

Inside the container, `sleep 3600` is **PID 1**.

#### Step 3: Find the Process on the Host OS

```bash
ps aux | grep "sleep 3600"
```

_Output:_

```text
root     48219  0.0  0.0   1588     4 ?  Ss   10:30   0:00 sleep 3600
```

On the host system, the exact same process is visible under the real host PID (e.g., `48219`).

#### Step 4: Inspect the Namespaces via `lsns`

```bash
sudo lsns -p 48219
```

This command lists all isolated namespaces (`mnt`, `net`, `pid`, `uts`, `ipc`) bound to PID `48219`.

#### Step 5: Clean Up

```bash
docker rm -f test-sandbox
```

---

## 📊 7. Enterprise Decision Matrix: VMs vs. Containers

```text
                     IS YOUR WORKLOAD...
                              │
            ┌─────────────────┴─────────────────┐
            ▼                                   ▼
Requires a different OS kernel?         Requires rapid scaling,
(e.g., Windows app on Linux host,       high density, microservices,
or specialized legacy kernel drivers)   or integrated CI/CD?
            │                                   │
            ▼                                   ▼
     Use Virtual Machines                 Use Containers
     (AWS EC2, VMware)                    (Docker, Kubernetes)
```

| Use Case                           | Recommended Architecture       | Reason                                                                                   |
| :--------------------------------- | :----------------------------- | :--------------------------------------------------------------------------------------- |
| **Microservices Applications**     | Containers                     | Rapid auto-scaling, low memory overhead, seamless CI/CD integration.                     |
| **Multi-Tenant Public Cloud**      | VMs (or Containers inside VMs) | Strong hypervisor boundary prevents privilege escalation attacks across untrusted users. |
| **Monolithic Legacy Applications** | Virtual Machines               | Difficult to decompose dependencies; requires full OS initialization.                    |
| **Edge & IoT Devices**             | Containers                     | Constrained CPU/RAM hardware requires minimum possible OS footprint.                     |

---

## ⚠️ 8. Production Gotchas & Common Pitfalls

1. **Kernel Compatibility Issues:**
   - _Gotcha:_ Because containers share the host kernel, an application requiring specialized kernel modules (e.g., specific eBPF versions, custom file systems) cannot run on a host lacking that support.
   - _Rule:_ A Linux container cannot run natively on a Windows or macOS kernel without a virtualization translation layer (e.g., WSL2 or hypervisor-based VM).

2. **The "Container as a VM" Anti-Pattern:**
   - _Pitfall:_ Installing SSH daemons, `cron`, `systemd`, and multiple application services inside a single container.
   - _Fix:_ Follow the single-concern principle: run one process per container. Forward logs to `stdout`/`stderr` rather than storing log files inside the container.

3. **Running Containers as Root:**
   - _Pitfall:_ Default container executions run as UID `0`. If a container breakout vulnerability occurs, the attacker may gain root privilege on the host.
   - _Fix:_ Always define an unprivileged non-root user in your Dockerfile (`USER appuser`) and enable Linux user namespaces.

---

## 💼 9. Interview Q&A (Scenario-Based)

### Q1: If a container shares the host OS kernel, can you run a Windows container on a Linux host?

**Answer:** No. Containers cannot virtualize the kernel. A Windows container requires the Windows kernel APIs and system binaries, which do not exist in the Linux kernel. To run Windows containers on Linux (or vice versa), an intermediate virtual machine running the target OS kernel is required (such as Hyper-V or WSL2).

### Q2: What happens when an application running inside a container exhausts all allocated memory?

**Answer:** The Linux kernel's Out-Of-Memory (OOM) killer intervenes. Because the container is bound by a memory `cgroup`, the OOM killer terminates the offending process inside the container (yielding exit code `137` - `SIGKILL`), rather than killing host processes or crashing the entire host OS.

### Q3: How do Namespaces and cgroups differ?

**Answer:**

- **Namespaces** provide **isolation** (they dictate what resources a process can _see_, such as processes, mounts, and network devices).
- **cgroups** provide **resource enforcement and metering** (they dictate what physical hardware resources a process can _consume_, such as CPU cycles, memory bytes, and disk I/O limits).

### Q4: Why are containers considered less secure than virtual machines in multi-tenant environments?

**Answer:** Virtual machines feature a hardware-enforced boundary through a hypervisor; compromise of a guest OS kernel still leaves the hypervisor barrier intact. In containers, all tenants share a single kernel. If an attacker exploits a zero-day kernel privilege escalation flaw, they can potentially compromise the underlying host and affect all sibling containers. To mitigate this in multi-tenant setups, teams combine containers with lightweight VMs (e.g., AWS Firecracker, Kata Containers).

---

### Reference Links

- Video Link: [Day 23 - Introduction to Containers (Abhishek Veeramalla)](https://youtu.be/7JZP345yVjw)
- Open Container Initiative (OCI): [opencontainers.org](https://opencontainers.org)
- Challenge Repository: [cloudwithpreetham/devops-90-days-challenge](https://github.com/cloudwithpreetham/devops-90-days-challenge)
