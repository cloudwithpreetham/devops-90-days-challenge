<div align="center">

# Day 14 — Configuration Management With Ansible

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch-red?logo=youtube)](https://www.youtube.com/watch?v=I5_NF8nvACg&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=17) [![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla) [![Day](https://img.shields.io/badge/Day-14%2F90-success)](https://github.com/cloudwithpreetham/devops-90-days-challenge/blob/main/Day-14) [![Topic](https://img.shields.io/badge/Topic-Ansible-orange)](https://github.com/cloudwithpreetham/devops-90-days-challenge/blob/main/Day-14)

</div>

---

## Table of Contents

- [Overview](#overview)
- [The Problem Configuration Management Solves](#the-problem-configuration-management-solves)
- [How the Problem Multiplied With Cloud](#how-the-problem-multiplied-with-cloud)
- [Configuration Management Tools Landscape](#configuration-management-tools-landscape)
- [Why Ansible Won](#why-ansible-won)
- [Dynamic Inventory](#dynamic-inventory)
- [Extending Ansible: Custom Modules & Ansible Galaxy](#extending-ansible-custom-modules--ansible-galaxy)
- [Limitations of Ansible](#limitations-of-ansible)
- [Interview Questions Covered](#interview-questions-covered)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                                                                                                       |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Day**        | 14 / 90                                                                                                                                                                               |
| **Topic**      | Configuration Management With Ansible \| Puppet vs Ansible \| Live Projects                                                                                                           |
| **Video**      | [Day-14 \| Configuration Management With Ansible \| Puppet vs Ansible \| Live Projects](https://www.youtube.com/watch?v=I5_NF8nvACg&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=17) |
| **Instructor** | Abhishek Veeramalla                                                                                                                                                                   |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)                                                                                  |
| **Status**     | Completed (theory) — hands-on Ansible project continues on Day 15                                                                                                                     |

Day 14 is a theory-only session: what configuration management actually is, why it exists, the landscape of CM tools, and why Ansible became the dominant one. The instructor is explicit that this video is conceptual — the live, hands-on Ansible playbook project (creating EC2 instances, writing a playbook, pushing config to GitHub) is saved for the next video.

---

## The Problem Configuration Management Solves

Before configuration management existed as a discipline, this was the job of the system administrator, back when on-premises data centers were the norm rather than the cloud.

Picture a company running, say, 100 servers on its own data center: 50 on Linux, 25 on CentOS, 25 on Ubuntu. Managing that fleet meant constantly handling three recurring jobs:

1. **Upgrades** — moving servers to newer distro versions as they're released.
2. **Security patches** — applying fixes as vulnerabilities are discovered, the same way you'd update an app on your phone.
3. **Default installations** — pre-installing tools every developer or workload needs (e.g. Git, a database) so nobody has to do it manually per-server.

With a small team (say five admins) split across 100 servers, doing this by hand — SSH-ing into every box individually — quickly becomes unmanageable. Before dedicated CM tools existed, the workaround was writing shell scripts for Linux boxes and PowerShell scripts for Windows boxes — and even those broke down because commands differ across distributions (CentOS vs Ubuntu vs Alpine), so a script that worked on one flavor of Linux might silently fail on another.

---

## How the Problem Multiplied With Cloud

Moving to the cloud didn't shrink this problem — it multiplied it. With cloud adoption and the shift to microservice architectures, the number of servers being created roughly grew by an order of magnitude, while the size/footprint of each individual server shrank by a similar factor (many small microservice-sized instances instead of a few large monolithic ones).

That combination — far more servers, each needing the same kind of ongoing configuration — is exactly the scale at which manual administration and one-off shell scripts stop being viable, and a dedicated configuration management tool becomes necessary.

---

## Configuration Management Tools Landscape

Several tools emerged to solve this problem: **Puppet**, **Chef**, **Ansible**, and **Salt**. Puppet and Chef were the earliest and most widely adopted tools historically, but over time — particularly from around 2016–2017 onward — Ansible overtook them in popularity and became the tool most DevOps engineers gravitate toward.

Ansible is now maintained by Red Hat (it became part of Red Hat around 2018–2019), which continues to actively develop its modules. Today, if you're starting fresh in configuration management without a strong reason to pick otherwise, Ansible is the recommended starting point — the odds that a given organization already uses it are high, and it's the tool most likely to be relevant when job-hunting.

---

## Why Ansible Won

The classic interview question — "why Ansible over Puppet/Chef?" — comes down to a handful of architectural differences:

| Aspect                 | **Puppet**                                                                | **Ansible**                                                                                    |
| ---------------------- | ------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| **Model**              | Pull-based — agents on each server periodically pull config from a master | Push-based — configuration is pushed out from a control machine (e.g. your laptop) to targets  |
| **Architecture**       | Master–Slave (a Puppet master server + configured agent/slave nodes)      | Agentless — no software to install on target servers at all                                    |
| **Adding new targets** | Requires configuring each new server as a slave/agent                     | Just add the server's IP/DNS to an **inventory file**, with passwordless (SSH key) auth set up |
| **Windows support**    | Comparatively weaker                                                      | Reasonably good (via WinRM), though not as strong as its Linux support                         |
| **Config language**    | A dedicated Puppet DSL — a new language to learn                          | Plain YAML — a format most DevOps engineers already know from other tools (e.g. Kubernetes)    |

The agentless, push-based model is the biggest practical win: since nothing has to be pre-installed on target machines, scaling from 10 servers to 100 or 1,000 is just a matter of adding IPs to the inventory file and having SSH access — which matters a lot in dynamic, autoscaling cloud environments where servers are constantly created and torn down.

---

## Dynamic Inventory

Beyond a static inventory file, Ansible also supports **dynamic inventory** — configuring Ansible (via an `.ini`-style config) to automatically detect new servers created in a given AWS region/availability zone, rather than requiring someone to manually add each new IP to the inventory file. This removes even the small manual step of inventory management in fast-scaling environments.

---

## Extending Ansible: Custom Modules & Ansible Galaxy

Ansible itself is written in Python, and engineers can write their own custom Ansible modules — for example, an organization using a specific load balancer (like an F5 or Nginx setup) could write modules to install, configure, or remove that load balancer's configuration.

These custom modules can be shared publicly through **Ansible Galaxy**, which acts as a bridge between organizations: a module one company writes for its own tooling can be reused by engineers anywhere else, similar to contributing to any other open-source project (Terraform, Kubernetes, etc.).

---

## Limitations of Ansible

Ansible isn't without downsides, and it's worth knowing these for interviews as much as the advantages:

- **Windows support isn't as mature as Linux support** — even with WinRM and improving Windows modules, managing Windows fleets is noticeably trickier than Linux.
- **Debugging is weak** — when a playbook run fails, Ansible's debug/log output doesn't always make it easy to pinpoint exactly where execution went wrong.
- **Performance at very large scale** — Ansible can manage thousands of servers, but parallel execution across very large fleets (tens of thousands of servers) can run into performance issues.

---

## Interview Questions Covered

- What programming language is Ansible written in, and have you written custom modules? → _Python; custom modules can be written and shared via Ansible Galaxy._
- Does Ansible support Linux and Windows? → _Yes — Linux via SSH, Windows via WinRM._
- What's the difference between Puppet and Ansible (or Chef vs Ansible)? → _Pull vs push model, master-slave vs agentless, DSL vs YAML._
- Is Ansible push or pull? → _Push._
- What language does Ansible use for playbooks? → _YAML._
- Does Ansible support all cloud providers (AWS/Azure/GCP)? → _Ansible doesn't care which cloud a server is on — it only needs the server to be reachable via SSH (or WinRM for Windows) from the Ansible control machine._

---

## Key Takeaways

- Configuration management exists to solve the problem of consistently managing packages, patches, and installs across many servers — a problem that scaled up dramatically with cloud and microservices
- Puppet, Chef, Ansible, and Salt are the major CM tools; Ansible became the most widely adopted, especially after Red Hat took over its development
- Ansible's core advantages: push-based, agentless (just IP + SSH in an inventory file), decent Windows + strong Linux support, and plain YAML instead of a custom DSL
- Dynamic inventory lets Ansible auto-detect new servers instead of requiring manual inventory updates
- Custom modules can be written in Python and shared via Ansible Galaxy
- Ansible's weak points: imperfect Windows support, weak debugging output, and possible performance issues at very large scale
- Today was theory-only — the hands-on live project (EC2 instances + a real playbook) is Day 15

---

## Progress Tracker

- [x] Watched the video
- [x] Understood the original problem configuration management solves
- [x] Understood how cloud + microservices multiplied that problem
- [x] Compared Puppet vs Ansible (pull vs push, master-slave vs agentless, DSL vs YAML)
- [x] Learned about dynamic inventory and Ansible Galaxy
- [x] Reviewed common Ansible interview questions
- [x] Documented Day 14 notes
- [x] Live Ansible project (EC2 + playbook) — carries over to Day 15

---

## Resources

- [Day 14 Video](https://www.youtube.com/watch?v=I5_NF8nvACg&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=17)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
