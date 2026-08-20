<div align="center">

# Day 10 — Git Branching Strategies

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch%20Video-red?logo=youtube)](https://www.youtube.com/watch?v=MCyvYT8FS5w&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=13)
[![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla)
[![Day](https://img.shields.io/badge/Day-10%2F90-success)]()
[![Topic](https://img.shields.io/badge/Topic-Git%20Branching-orange)]()

</div>

---

## Table of Contents

- [Overview](#overview)
- [What is a Branch?](#what-is-a-branch)
- [Essential Branch Types](#essential-branch-types)
- [Practical Real-World Example: Kubernetes](#practical-real-world-example-kubernetes)
- [Uber Analogy](#uber-analogy)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                                                    |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| **Day**        | 10 / 90                                                                                                                            |
| **Topic**      | Git Branching Strategies                                                                                                           |
| **Video**      | [Day-10 \| Git Branching Strategies](https://www.youtube.com/watch?v=MCyvYT8FS5w&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=13) |
| **Instructor** | Abhishek Veeramalla                                                                                                                |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)                               |
| **Status**     | Completed                                                                                                                          |

Building on Day 9's Git fundamentals, Day 10 covers **branching strategies** — how professional teams isolate work, stabilize releases, and ship reliably without breaking what's already in production.

---

## What is a Branch?

A **branch** is a workspace separation — it lets developers build new features or make changes without impacting the stable code currently being used by customers. Changes happen in isolation until they're ready to be merged back in.

---

## Essential Branch Types

| Branch Type          | Purpose                                                                                                                   |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **Master/Main**      | The primary, always up-to-date branch — the single source of truth for the project                                        |
| **Feature Branches** | Used to develop a specific new feature in isolation; merged back into master once tested and approved                     |
| **Release Branches** | Created when the team is ready to ship a specific version — stabilizes code for final testing before it reaches customers |
| **Hotfix Branches**  | Short-lived branches created to quickly fix critical bugs found in production                                             |

---

## Practical Real-World Example: Kubernetes

The video uses the **Kubernetes** GitHub repository as a real-world case study — showing how a massive open-source project, with thousands of contributors, manages multiple concurrent feature and release branches to ship reliable, periodic version updates without chaos.

---

## Uber Analogy

To make the branching lifecycle concrete, the video walks through adding a new feature to a cab application — like introducing "bike" or "intercity" services. This illustrates why a parallel development flow (a feature branch) is necessary: new functionality is built and tested separately, then eventually converges back into the main product once it's ready.

---

## Key Takeaways

- Branches exist to isolate in-progress work from stable, customer-facing code
- Master/Main is the source of truth; feature branches are where new work actually happens
- Release branches stabilize a version for final testing before shipping; hotfix branches handle urgent production fixes
- Real-world projects at scale (like Kubernetes) rely heavily on disciplined branching to coordinate thousands of contributors
- Every new feature effectively lives a "parallel life" in its own branch until it's ready to merge back into the main product

---

## Progress Tracker

- [x] Watched the video
- [x] Understood the four essential branch types
- [x] Studied how Kubernetes manages branching at scale
- [x] Documented Day 10 notes
- [x] Move on to Day 11

---

## Resources

- [Day 10 Video](https://www.youtube.com/watch?v=MCyvYT8FS5w&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=13)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
