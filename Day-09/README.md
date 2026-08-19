<div align="center">

# Day 09 — Introduction to Git & GitHub

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch%20Video-red?logo=youtube)](https://www.youtube.com/watch?v=fIMySI_gZJU&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=12)
[![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla)
[![Day](https://img.shields.io/badge/Day-09%2F90-success)]()
[![Topic](https://img.shields.io/badge/Topic-Git%20%26%20GitHub-orange)]()

</div>

---

## Table of Contents

- [Overview](#overview)
- [Version Control Basics](#version-control-basics)
- [Centralized vs. Distributed VCS](#centralized-vs-distributed-vcs)
- [Git vs. GitHub](#git-vs-github)
- [Practical Git Workflow](#practical-git-workflow)
- [Sharing Code](#sharing-code)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                                                            |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| **Day**        | 09 / 90                                                                                                                                    |
| **Topic**      | Introduction to Git & GitHub                                                                                                               |
| **Video**      | [Day-9 \| Version Control with Git & GitHub](https://www.youtube.com/watch?v=fIMySI_gZJU&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=12) |
| **Instructor** | Abhishek Veeramalla                                                                                                                        |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)                                       |
| **Status**     | Completed                                                                                                                                  |

Day 9 lays the foundation for **Version Control Systems (VCS)**, focused on Git and GitHub — the tools underpinning nearly every collaborative software and DevOps workflow.

---

## Version Control Basics

Version control exists to solve two core team problems:

- **Sharing code** efficiently among multiple developers
- **Managing multiple versions** of an application — tracking what changed, and being able to revert if something breaks

---

## Centralized vs. Distributed VCS

| Type                | Example | Key Characteristic                                                                         |
| ------------------- | ------- | ------------------------------------------------------------------------------------------ |
| **Centralized VCS** | SVN     | A single central server holds the repository — if it fails, all work stops                 |
| **Distributed VCS** | Git     | Every developer has a **full copy** of the repository locally — no single point of failure |

This distributed model is a core reason Git became the industry standard — work isn't blocked by a single server going down.

---

## Git vs. GitHub

A common point of confusion, clarified:

- **Git** — the open-source version control **software**, installed and run locally
- **GitHub** — a **cloud-based platform** built on top of Git, adding project management, code reviews, and UI-based collaboration features on top of Git's core functionality

---

## Practical Git Workflow

Essential commands for managing a project locally:

| Command      | Purpose                                             |
| ------------ | --------------------------------------------------- |
| `git init`   | Initializes a local repository                      |
| `git status` | Checks the current state of tracked/untracked files |
| `git add`    | Stages changes to be tracked                        |
| `git commit` | Saves a snapshot (version) of the code              |
| `git diff`   | Views differences between versions/changes          |
| `git log`    | Reviews the commit history                          |

---

## Sharing Code

The video wraps up by covering how to **push** local code to GitHub to enable collaboration, and introduces the concept of a **Fork** — creating a full, independent copy of a repository to work on separately from the original.

Future sessions will dive deeper into GitHub-specific features, CI/CD, and more advanced workflows.

---

## Key Takeaways

- Version control solves two core problems: sharing code and tracking/reverting changes
- Git's distributed model (every dev has a full repo copy) is fundamentally more resilient than centralized systems like SVN
- Git is the local tool; GitHub is the cloud platform built on top of it — they're not the same thing
- `init → status → add → commit → diff → log` is the essential local Git loop worth memorizing
- Forking enables independent work on a copy of a repository — foundational for open-source and team contribution workflows

---

## Progress Tracker

- [x] Watched the video
- [x] Understood centralized vs. distributed VCS
- [x] Practiced the core local Git workflow
- [x] Understood forking and pushing to GitHub
- [x] Documented Day 09 notes
- [x] Move on to Day 10

---

## Resources

- [Day 09 Video](https://www.youtube.com/watch?v=fIMySI_gZJU&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=12)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
