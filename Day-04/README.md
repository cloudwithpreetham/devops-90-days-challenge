<div align="center">

# Day 04 — AWS & Azure: How to Create Virtual Machines

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch%20Video-red?logo=youtube)](https://www.youtube.com/watch?v=NJkMe9cdYEQ&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=5)
[![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla)
[![Day](https://img.shields.io/badge/Day-04%2F90-success)]()
[![Topic](https://img.shields.io/badge/Topic-VM%20Provisioning-orange)]()

</div>

---

## Table of Contents

- [Overview](#overview)
- [Conceptual Overview](#conceptual-overview)
- [Importance of Automation](#importance-of-automation)
- [Methods of Automation](#methods-of-automation)
- [Practical Demonstration](#practical-demonstration)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                                                                      |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Day**        | 04 / 90                                                                                                                                              |
| **Topic**      | AWS & Azure - How to Create Virtual Machines                                                                                                         |
| **Video**      | [Day-4 \| AWS & Azure - How to Create Virtual Machines](https://www.youtube.com/watch?v=NJkMe9cdYEQ&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=5) |
| **Instructor** | Abhishek Veeramalla                                                                                                                                  |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)                                                 |
| **Status**     | Completed                                                                                                                                            |

Building on Day 3's VM fundamentals, Day 4 gets practical — covering how VMs are actually created in cloud environments like AWS and Azure, and why automating that process matters far more than clicking through a console.

---

## Conceptual Overview

Creating a VM, at its core, is simply a **request to a cloud provider** — you specify the configuration you want, and the provider returns an IP address and the provisioned resource. Manual creation through a UI (like the AWS Console) is possible and useful for learning, but it doesn't scale — doing this by hand for dozens or hundreds of VMs is slow and error-prone.

---

## Importance of Automation

As a DevOps engineer, the priority is **efficiency and eliminating manual errors**. Cloud providers expose **APIs** specifically so that resource provisioning — including VM creation — can be automated instead of done by hand through a console every time.

---

## Methods of Automation

Several approaches are available for automating VM creation:

| Method                             | Description                                                              |
| ---------------------------------- | ------------------------------------------------------------------------ |
| **AWS CLI**                        | Direct command-line interaction with AWS services                        |
| **Programming SDKs**               | Using libraries like Python's `boto3` to make API calls programmatically |
| **CloudFormation Templates (CFT)** | AWS's native declarative infrastructure templates                        |
| **AWS CDK**                        | Code-based infrastructure development kit                                |
| **Terraform**                      | A popular open-source, multi-cloud infrastructure-as-code tool           |

A key point raised: **Terraform** is powerful for multi-cloud setups, but if an organization operates on a single cloud provider, it's worth evaluating whether native tools (CLI, SDKs, CFT) might be a simpler, more direct fit before reaching for Terraform by default.

---

## Practical Demonstration

The video walks through launching an **EC2 instance** on the AWS Console, highlighting a few practical essentials:

- Selecting **Free Tier eligible** options to avoid unexpected costs
- Creating a **key pair** for secure SSH authentication into the instance
- Choosing an operating system — **Ubuntu** is used in the demo

---

## Key Takeaways

- Creating a VM is fundamentally just a configuration request to a cloud provider
- Manual, UI-based VM creation doesn't scale — automation is the DevOps-native approach
- Multiple automation paths exist (CLI, SDKs, CFT, CDK, Terraform) — the right choice depends on whether the environment is single-cloud or multi-cloud
- Don't reach for Terraform by default — evaluate whether native tooling already solves the problem for a single-cloud setup
- Practical basics matter: Free Tier selection, key pairs, and OS choice are the first real steps in provisioning a usable VM

---

## Progress Tracker

- [x] Watched the video
- [x] Understood automation methods for VM provisioning (CLI, SDK, CFT, CDK, Terraform)
- [x] Understood the EC2 launch basics (Free Tier, key pairs, OS selection)
- [x] Documented Day 04 notes
- [x] Move on to Day 05

---

## Resources

- [Day 04 Video](https://www.youtube.com/watch?v=NJkMe9cdYEQ&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=5)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
