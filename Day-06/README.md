<div align="center">

# Day 06 — Introduction to Linux & Shell Scripting

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch%20Video-red?logo=youtube)](https://www.youtube.com/watch?v=9jw9F6mcQDo&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=8)
[![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla)
[![Day](https://img.shields.io/badge/Day-06%2F90-success)]()
[![Topic](https://img.shields.io/badge/Topic-Linux%20%26%20Shell-orange)]()

</div>

---

## Table of Contents

- [Overview](#overview)
- [Understanding Operating Systems](#understanding-operating-systems)
- [Why Linux is Preferred](#why-linux-is-preferred)
- [Linux Architecture](#linux-architecture)
- [Shell Scripting Basics](#shell-scripting-basics)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                                                                 |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| **Day**        | 06 / 90                                                                                                                                         |
| **Topic**      | Introduction to Linux & Shell Scripting                                                                                                         |
| **Video**      | [Day-6 \| Introduction to Linux & Shell Scripting](https://www.youtube.com/watch?v=9jw9F6mcQDo&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=8) |
| **Instructor** | Abhishek Veeramalla                                                                                                                             |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)                                            |
| **Status**     | Completed                                                                                                                                       |

Day 6 shifts into core Linux fundamentals and basic shell commands — the essential toolkit for interacting with the servers that DevOps engineers work on daily, most of which have no graphical interface at all.

---

## Understanding Operating Systems

An **operating system** acts as the essential bridge between software applications and computer hardware — managing the CPU, RAM, and I/O so applications don't need to talk to hardware directly.

---

## Why Linux is Preferred

Linux is the dominant OS in production environments for a few key reasons:

- **Free / open-source** — no licensing cost, fully customizable
- **Secure** — a strong security model and smaller attack surface compared to alternatives
- **Fast** — lightweight and efficient, especially for server workloads

---

## Linux Architecture

At the center of Linux is the **kernel** — the heart of the operating system, responsible for:

- **Device management**
- **Memory management**
- **Process management**

Surrounding the kernel are **system libraries** and **compilers** that applications and developers interact with to actually get work done on the system.

---

## Shell Scripting Basics

Since most production servers have **no GUI**, DevOps engineers rely almost entirely on **shell commands** to interact with and manage systems.

### Common Commands

| Command   | Purpose                                                            |
| --------- | ------------------------------------------------------------------ |
| `pwd`     | Print (check) your present working directory                       |
| `ls`      | List files and directories                                         |
| `ls -ltr` | List with detailed properties — permissions, ownership, timestamps |
| `cd`      | Navigate between directories                                       |
| `touch`   | Create a new empty file                                            |
| `vi`      | Open a text editor to create/edit files                            |
| `mkdir`   | Create a new directory                                             |
| `rm`      | Remove files or directories                                        |

### System Monitoring Commands

| Command | Purpose                                         |
| ------- | ----------------------------------------------- |
| `free`  | Check memory (RAM) usage                        |
| `nproc` | Check number of CPU cores                       |
| `df -h` | Check disk space usage in human-readable format |
| `top`   | All-in-one live view of system resource usage   |

---

## Key Takeaways

- The OS is the bridge between applications and hardware — the kernel is its core, handling devices, memory, and processes
- Linux dominates production environments because it's free, secure, and fast
- Since most servers are GUI-less, shell command fluency is a non-negotiable DevOps skill
- Navigation (`pwd`, `ls`, `cd`), file management (`touch`, `vi`, `mkdir`, `rm`), and monitoring (`free`, `nproc`, `df -h`, `top`) form the essential command toolkit to start with

---

## Progress Tracker

- [x] Watched the video
- [x] Understood OS fundamentals and Linux's kernel architecture
- [x] Practiced core shell commands (navigation, file ops, monitoring)
- [x] Documented Day 06 notes
- [x] Move on to Day 07

---

## Resources

- [Day 06 Video](https://www.youtube.com/watch?v=9jw9F6mcQDo&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=8)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
