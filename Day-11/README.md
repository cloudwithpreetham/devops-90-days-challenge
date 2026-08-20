<div align="center">

# Day 11 — Git Commands & Real-World Workflows

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch%20Video-red?logo=youtube)](https://www.youtube.com/watch?v=mT6qrAx14O4&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=14)
[![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla)
[![Day](https://img.shields.io/badge/Day-11%2F90-success)]()
[![Topic](https://img.shields.io/badge/Topic-Git%20Workflows-orange)]()

</div>

---

## Table of Contents

- [Overview](#overview)
- [Repository Initialization](#repository-initialization)
- [The Basic Workflow](#the-basic-workflow)
- [Cloning vs. Forking](#cloning-vs-forking)
- [Branching and Merging](#branching-and-merging)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                                                               |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| **Day**        | 11 / 90                                                                                                                                       |
| **Topic**      | Git Commands & Real-World Workflows                                                                                                           |
| **Video**      | [Day-11 \| Git Commands & Real-World Workflows](https://www.youtube.com/watch?v=mT6qrAx14O4&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=14) |
| **Instructor** | Abhishek Veeramalla                                                                                                                           |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)                                          |
| **Status**     | Completed                                                                                                                                     |

Day 11 builds on Day 10's branching concepts with a hands-on walkthrough of essential Git commands and real-world workflows, demonstrated using a mock `calculator.sh` project.

---

## Repository Initialization

`git init` creates a local repository and initializes the hidden **`.git`** folder — the internal structure that tracks versions and manages Git hooks behind the scenes.

---

## The Basic Workflow

The standard day-to-day Git sequence:

1. **`git add`** — stage files for the next commit
2. **`git commit`** — save the staged changes with a message
3. **`git push`** — transfer local commits to a remote repository (e.g. GitHub)

---

## Cloning vs. Forking

| Command         | What It Does                                                                                                                                               |
| --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`git clone`** | Downloads a full copy of an existing repository to your local machine                                                                                      |
| **Fork**        | Creates a **server-side** (GitHub-hosted) copy of a project — used for collaborating on or contributing to a project you don't have direct write access to |

---

## Branching and Merging

Using the `calculator.sh` project, feature branches were used to isolate individual pieces of functionality (e.g. `division`, `multiplication`) before combining them back together. Three ways to bring branches together were covered:

| Method              | Best For                                                                                     |
| ------------------- | -------------------------------------------------------------------------------------------- |
| **Git Cherry-Pick** | Selecting specific individual commits from one branch and applying them to another           |
| **Git Merge**       | Combining branches directly — results in a non-linear commit history                         |
| **Git Rebase**      | A cleaner approach — replays changes onto the base branch, producing a linear commit history |

The video also covers resolving **merge conflicts**, which come up naturally once multiple branches touch overlapping code.

---

## Key Takeaways

- `.git` is the hidden engine behind every repository — it's what actually tracks history and hooks
- `add → commit → push` is the core daily Git loop
- Clone pulls down an existing repo; forking creates your own server-side copy for contribution workflows
- Cherry-pick, merge, and rebase all combine work but produce very different histories — the right choice depends on whether a clean, linear history matters for the project
- Merge conflicts are a normal part of collaborative work, not something to fear — resolving them is a core Git skill

---

## Progress Tracker

- [x] Watched the video
- [x] Practiced the basic add/commit/push workflow
- [x] Understood clone vs. fork
- [x] Understood cherry-pick, merge, and rebase differences
- [x] Documented Day 11 notes
- [x] Move on to Day 12

---

## Resources

- [Day 11 Video](https://www.youtube.com/watch?v=mT6qrAx14O4&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=14)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
