<div align="center">

# Day 03 — Virtual Machines Part-1

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch%20Video-red?logo=youtube)](https://www.youtube.com/watch?v=lgUwYwBozow&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=4)
[![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla)
[![Day](https://img.shields.io/badge/Day-03%2F90-success)]()
[![Topic](https://img.shields.io/badge/Topic-Virtual%20Machines-orange)]()

</div>

---

## Table of Contents

- [Overview](#overview)
- [The Inefficiency Problem](#the-inefficiency-problem)
- [What is a Virtual Machine?](#what-is-a-virtual-machine)
- [The Role of the Hypervisor](#the-role-of-the-hypervisor)
- [How Cloud Providers Use VMs](#how-cloud-providers-use-vms)
- [Why VMs Matter for DevOps](#why-vms-matter-for-devops)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                                                 |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **Day**        | 03 / 90                                                                                                                         |
| **Topic**      | Virtual Machines Part-1                                                                                                         |
| **Video**      | [Day-3 \| Virtual Machines Part-1](https://www.youtube.com/watch?v=lgUwYwBozow&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=4) |
| **Instructor** | Abhishek Veeramalla                                                                                                             |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)                            |
| **Status**     | Completed                                                                                                                       |

Day 3 covers the foundational concepts of **Virtual Machines (VMs)** and why virtualization is central to how modern IT infrastructure — and cloud computing in particular — achieves efficient resource utilization.

---

## The Inefficiency Problem

Using a real-world analogy of land ownership, the video illustrates a common problem: physical servers dedicated to a single application are often massively underutilized, wasting hardware resources like RAM and CPU that sit idle most of the time. This inefficiency is the core motivation for virtualization.

---

## What is a Virtual Machine?

A **Virtual Machine (VM)** is a logical, isolated environment that behaves like a standalone computer system. VMs allow multiple users or applications to share the same underlying physical hardware without interfering with one another — each VM operates as if it has its own dedicated machine.

---

## The Role of the Hypervisor

A **hypervisor** is the software layer responsible for partitioning a single physical server into multiple virtual machines. It's the core piece of technology that makes virtualization possible.

Popular hypervisor examples mentioned:

- **VMware**
- **Xen**

---

## How Cloud Providers Use VMs

Cloud platforms like **AWS** operate massive data centers full of physical servers. When a user requests a compute instance (e.g., an **EC2 instance**), a hypervisor creates a virtual machine on one of those physical servers, sized and configured to match what the user asked for — all without the user ever needing to know (or care) which physical machine it's actually running on.

---

## Why VMs Matter for DevOps

Virtualization is central to DevOps because it maximizes resource utilization. By splitting one large physical machine into many smaller virtual ones, cloud providers and companies can serve millions of users instead of just a handful — turning wasted, idle hardware capacity into usable, billable, efficient infrastructure.

---

## Key Takeaways

- Dedicating a full physical server to a single application wastes most of its capacity
- A VM is an isolated, logical environment that shares physical hardware safely with other VMs
- The hypervisor (e.g., VMware, Xen) is what makes carving up physical hardware into VMs possible
- Cloud services like AWS EC2 are built on exactly this model — a hypervisor spins up a VM per user request
- Virtualization is the efficiency foundation that makes modern, large-scale cloud computing economically viable

---

## Progress Tracker

- [x] Watched the video
- [x] Understood VMs, hypervisors, and how cloud providers use virtualization
- [x] Documented Day 03 notes
- [x] Move on to Day 04

---

## Resources

- [Day 03 Video](https://www.youtube.com/watch?v=lgUwYwBozow&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=4)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
