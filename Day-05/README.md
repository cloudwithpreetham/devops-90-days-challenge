<div align="center">

# Day 05 — Connecting to & Automating EC2 Instances

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch%20Video-red?logo=youtube)](https://www.youtube.com/watch?v=cN4pt5KQ9eA&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=7)
[![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla)
[![Day](https://img.shields.io/badge/Day-05%2F90-success)]()
[![Topic](https://img.shields.io/badge/Topic-EC2%20%26%20AWS%20CLI-orange)]()

</div>

---

## Table of Contents

- [Overview](#overview)
- [Connecting to EC2 Instances](#connecting-to-ec2-instances)
- [Automation Methods](#automation-methods)
- [Best Practices](#best-practices)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                                                  |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **Day**        | 05 / 90                                                                                                                          |
| **Topic**      | Connecting to & Automating EC2 Instances                                                                                         |
| **Video**      | [How to Connect to an EC2 Instance](https://www.youtube.com/watch?v=cN4pt5KQ9eA&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=7) |
| **Instructor** | Abhishek Veeramalla                                                                                                              |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)                             |
| **Status**     | Completed                                                                                                                        |

A practical, hands-on session on connecting to and managing EC2 instances — moving from browser-based access to terminal-based SSH, and then into automating instance management with the AWS CLI and Python.

---

## Connecting to EC2 Instances

| Method                    | Notes                                                                                                                                                                                      |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **AWS Console (browser)** | Quick, built-in connect option directly from the AWS Console — convenient but not efficient for large-scale or repeated operations                                                         |
| **Terminal via SSH**      | The recommended professional approach, using tools like iTerm, PuTTY, or MobaXterm. Requires the instance's **PEM key** for authentication, with permissions locked down using `chmod 400` |

---

## Automation Methods

| Tool                               | What It's For                                                                                                                                            |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **AWS CLI**                        | The most common way to interact with AWS services from the command line; set up via `aws configure` using an **Access Key ID** and **Secret Access Key** |
| **CloudFormation Templates (CFT)** | AWS's native Infrastructure as Code (IaC) tool — define resources declaratively through templates                                                        |
| **Boto3 (Python)**                 | The AWS SDK for Python, used to script and automate resource management tasks such as listing running instances                                          |

---

## Best Practices

- **Never share security credentials** (Access Key ID / Secret Access Key) — treat them like passwords
- **Stop or terminate instances** when they're no longer needed to avoid unnecessary billing
- Lock down PEM key file permissions with `chmod 400` before using them for SSH — AWS/SSH will reject overly-open key files

---

## Key Takeaways

- Browser-based EC2 connection is fine for quick checks, but terminal/SSH access is the standard professional workflow
- PEM key + `chmod 400` is a recurring, essential step for secure SSH access
- `aws configure` (Access Key ID + Secret Access Key) is the entry point for nearly all AWS CLI automation
- CFT and Boto3 offer two different automation styles — declarative templates vs. imperative scripting — and it's worth understanding both
- Cost hygiene (stopping/terminating unused instances) is a basic but critical habit for anyone working hands-on with AWS

---

## Progress Tracker

- [x] Watched the video
- [x] Understood EC2 connection methods (Console vs. SSH)
- [x] Understood AWS CLI setup and Boto3/CFT automation options
- [x] Documented Day 05 notes
- [x] Move on to Day 06

---

## Resources

- [Day 05 Video](https://www.youtube.com/watch?v=cN4pt5KQ9eA&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=7)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
