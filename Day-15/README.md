<div align="center">

# Day 15 — Ansible Zero to Hero (Hands-On)

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch-red?logo=youtube)](https://www.youtube.com/watch?v=Z6T2r3Xhk5k&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=19) [![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla) [![Day](https://img.shields.io/badge/Day-15%2F90-success)](https://github.com/cloudwithpreetham/devops-90-days-challenge/blob/main/Day-15) [![Topic](https://img.shields.io/badge/Topic-Ansible-orange)](https://github.com/cloudwithpreetham/devops-90-days-challenge/blob/main/Day-15)

</div>

---

## Table of Contents

- [Overview](#overview)
- [Installing Ansible](#installing-ansible)
- [Setting Up Passwordless Authentication](#setting-up-passwordless-authentication)
- [Ad-Hoc Commands vs Playbooks](#ad-hoc-commands-vs-playbooks)
- [Running Ansible Ad-Hoc Commands](#running-ansible-ad-hoc-commands)
- [Grouping Servers in the Inventory File](#grouping-servers-in-the-inventory-file)
- [Writing My First Playbook](#writing-my-first-playbook)
- [Running the Playbook](#running-the-playbook)
- [Why Ansible Roles Exist](#why-ansible-roles-exist)
- [Anatomy of an Ansible Role](#anatomy-of-an-ansible-role)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                                                |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| **Day**        | 15 / 90                                                                                                                        |
| **Topic**      | Ansible Zero to Hero — hands-on installation, ad-hoc commands, playbooks, and roles                                            |
| **Video**      | [Day-15 \| Ansible Zero to Hero](https://www.youtube.com/watch?v=Z6T2r3Xhk5k&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=19) |
| **Instructor** | Abhishek Veeramalla                                                                                                            |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)                           |
| **Status**     | Completed                                                                                                                      |

Day 15 picks up where Day 14 left off — this time it's fully hands-on. Starting from a blank EC2 instance, the session covers installing Ansible, setting up passwordless SSH so the control node can reach a target server, running one-off ad-hoc commands, writing a real playbook that installs and starts nginx, and finally structuring larger playbooks using Ansible roles.

---

## Installing Ansible

Two Ubuntu EC2 instances are used for this session — one acts as the Ansible control node, the other as the target server being configured.

Installation itself is straightforward using the distro's own package manager rather than the generic pip-based instructions in Ansible's official docs (which install Python, then pip, then Ansible — more moving parts than necessary):

```bash
sudo apt update
sudo apt install ansible
```

The equivalent on other platforms: `brew install ansible` on Mac, `choco install ansible` on Windows. Using the native package manager keeps Ansible on the system PATH automatically, which the generic pip route doesn't always guarantee.

Verify the install:

```bash
ansible --version
```

---

## Setting Up Passwordless Authentication

Ansible's one hard requirement is that the control node can reach every target server over SSH without a password prompt. The walkthrough sets this up manually rather than relying on `ssh-copy-id` (which can run into permission issues):

1. On the control node, generate a key pair:
   ```bash
   ssh-keygen
   ```
   This creates a public/private key pair under `~/.ssh/` (`id_rsa` and `id_rsa.pub`).
2. Copy the public key's contents:
   ```bash
   cat ~/.ssh/id_rsa.pub
   ```
3. On the target server, generate its own key pair with `ssh-keygen`, then open `~/.ssh/authorized_keys` and paste in the control node's public key.
4. Test it — `ssh <target-private-ip>` should now log in with no password prompt.

For additional target servers, the same public key just gets appended to each new server's `authorized_keys` — no need to regenerate keys on the control node.

**Important:** always use the target server's **private IP**, not the public IP, when both instances sit in the same VPC.

---

## Ad-Hoc Commands vs Playbooks

Not every Ansible task needs a full playbook — the same way you don't write a shell script just to run `ls -ltr` once. For a single one-off task, Ansible supports **ad-hoc commands** run directly from the CLI. Playbooks are for when you need to run a _sequence_ of multiple tasks together.

This distinction — ad-hoc commands for one or two tasks, playbooks for multiple, ordered tasks — is a commonly asked interview question.

---

## Running Ansible Ad-Hoc Commands

The inventory file just lists target server IPs (by default at `/etc/ansible/hosts`, though it's more convenient to keep a local copy alongside your playbooks):

```
172.31.6.228
```

General ad-hoc command shape:

```bash
ansible -i inventory <target> -m <module> -a "<arguments>"
```

- `-i` — path to the inventory file
- target — a specific host, a group name, or `all` for everything in the inventory
- `-m` — which module to use (`shell`, `apt`, `copy`, etc.)
- `-a` — the arguments/command for that module

Example — create a file on the target server using the `shell` module:

```bash
ansible -i inventory all -m shell -a "touch devopsclass"
```

Other modules demonstrated: running arbitrary shell commands (`nproc`, `df`) to inspect the target server, and using the `copy` module to transfer files between hosts. When unsure which module or arguments to use, the official Ansible module documentation is the go-to reference — it's updated constantly as the community contributes new modules.

---

## Grouping Servers in the Inventory File

For running tasks against a subset of servers (e.g. only DB servers or only web servers), the inventory file supports named groups:

```ini
[dbservers]
172.31.6.101

[webservers]
172.31.6.100
```

Targeting just one group:

```bash
ansible -i inventory webservers -m shell -a "df -h"
```

Ansible resolves the group name against the inventory and runs the command against every host in it — whether that's one server or a hundred.

---

## Writing My First Playbook

Goal: install nginx and start the service. Playbooks are written in YAML (`first-playbook.yaml`):

```yaml
---
- name: Install and start nginx
  hosts: all
  become: yes
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present

    - name: Start nginx
      service:
        name: nginx
        state: started
```

Breaking down the structure:

- `---` marks the start of a YAML file
- The top-level `-` marks the start of a play — a file can contain multiple plays
- `hosts: all` — run against every host in the inventory (could also target a specific group)
- `become: yes` — run as root, needed for package installation (equivalent to prefixing shell commands with `sudo`)
- `tasks:` — an ordered list of tasks, each with a `name` and a module call

Both `apt: {name: nginx, state: present}` and `shell: apt install nginx` achieve the same result — but using the dedicated `apt` module is preferred over raw shell commands because it's more reliable and package-manager-aware. Same logic applies to using the `service` module over a raw `systemctl start nginx` shell command.

---

## Running the Playbook

```bash
ansible-playbook -i inventory first-playbook.yaml
```

Execution order: **Gathering Facts** runs automatically first (Ansible checks connectivity and collects target server info), followed by each task in the order they're written — **Install nginx**, then **Start nginx**.

Verify on the target server:

```bash
sudo systemctl status nginx
```

For a detailed look at what Ansible is doing under the hood at each step (SSH handshake, Python dependency checks, module execution, JSON result output), add verbosity flags:

```bash
ansible-playbook -i inventory first-playbook.yaml -vvv
```

---

## Why Ansible Roles Exist

A two-task playbook is easy to read. But a playbook to configure an entire Kubernetes cluster — control plane _and_ worker nodes, with all the variables, certificates, and secrets involved — can easily balloon to 50–60 tasks in one file, which quickly becomes unreadable.

(Side note from the video: provisioning the EC2 instances themselves is typically done with **Terraform**, not Ansible — Ansible then handles configuring those instances once they exist. Both tools _can_ create infrastructure, but Terraform is purpose-built for it.)

**Ansible roles** solve the readability/maintainability problem by giving large playbooks a standard, segregated folder structure instead of one giant YAML file.

---

## Anatomy of an Ansible Role

Scaffold a new role:

```bash
ansible-galaxy role init kubernetes
```

This generates a standard folder structure:

| Folder/File  | Purpose                                                                                     |
| ------------ | ------------------------------------------------------------------------------------------- |
| `tasks/`     | The actual list of tasks (what used to live directly in the playbook)                       |
| `handlers/`  | Responses to specific events/failures — e.g. notify or clean up if a service fails to start |
| `templates/` | Jinja2 templates for generating config files dynamically                                    |
| `files/`     | Static files to copy onto target hosts (certs, `index.html`, etc.)                          |
| `vars/`      | Variables for the role                                                                      |
| `defaults/`  | Default variable values                                                                     |
| `tests/`     | Basic tests for the role                                                                    |
| `meta/`      | Metadata about the role — author info, licensing, sharing permissions                       |
| `README.md`  | Explains what the role does                                                                 |

With roles, the top-level playbook (often named `site.yaml`) shrinks down to just naming the hosts and pointing at the relevant role — all the task detail lives inside the role's own folder structure. The instructor's public GitHub repo (forked from `ansible/ansible-examples`, kept updated with more examples over time) has real role examples to reference, including a JBoss Standalone role as a good starting point for practice.

---

## Key Takeaways

- Install Ansible via your OS's native package manager (`apt`/`brew`/`choco`) rather than the generic pip route
- Passwordless SSH (public key in the target's `authorized_keys`) is the one hard prerequisite for Ansible to manage a server
- Always use private IPs between instances in the same VPC
- Ad-hoc commands (`ansible -m ... -a ...`) are for one-off tasks; playbooks are for multiple, ordered tasks
- Prefer purpose-built modules (`apt`, `service`) over raw `shell` commands where one exists
- `ansible-playbook` runs a playbook; `ansible` runs ad-hoc commands — a common interview distinction
- Inventory groups (`[webservers]`, `[dbservers]`) let you target specific subsets of hosts
- Terraform provisions infrastructure; Ansible configures it — different tools for different jobs
- Ansible roles (`ansible-galaxy role init`) exist to keep large, multi-task playbooks (like a full Kubernetes setup) organized and maintainable
- `-vvv` verbosity flags are the best way to actually understand what Ansible is doing step by step

---

## Progress Tracker

- [x] Installed Ansible on an EC2 control node
- [x] Set up passwordless SSH authentication to a target server
- [x] Ran ad-hoc commands (`shell`, `copy` modules)
- [x] Grouped servers in the inventory file
- [x] Wrote and ran my first playbook (install + start nginx)
- [x] Verified execution with the `-vvv` verbosity flag
- [x] Understood why and when to use Ansible roles
- [x] Explored the standard role folder structure (`ansible-galaxy role init`)
- [x] Documented Day 15 notes

---

## Resources

- [Day 15 Video](https://www.youtube.com/watch?v=Z6T2r3Xhk5k&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=19)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)
- [Instructor's Ansible Examples Repo](https://github.com/AbhishekVeeramalla/ansible-examples) _(forked from `ansible/ansible-examples`)_

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
