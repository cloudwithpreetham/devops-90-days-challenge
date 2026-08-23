<div align="center">

# Day 13 — AWS Services Every DevOps Engineer Should Know

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch%20Video-red?logo=youtube)](https://www.youtube.com/watch?v=leWJypzVyQ4&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=16)
[![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla)
[![Day](https://img.shields.io/badge/Day-13%2F90-success)]()
[![Topic](https://img.shields.io/badge/Topic-AWS%20Services-orange)]()

</div>

---

## Table of Contents

- [Overview](#overview)
- [What is AWS?](#what-is-aws)
- [Automation and Efficiency](#automation-and-efficiency)
- [Core AWS Services for DevOps](#core-aws-services-for-devops)
- [CI/CD Build Services](#cicd-build-services)
- [Governance, Auditing & Security](#governance-auditing--security)
- [Containers & Kubernetes on AWS](#containers--kubernetes-on-aws)
- [Logging: ELK Stack](#logging-elk-stack)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                                                             |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| **Day**        | 13 / 90                                                                                                                                     |
| **Topic**      | AWS Services Every DevOps Engineer Should Know                                                                                              |
| **Video**      | [Day-13 \| AWS Services for DevOps Engineers](https://www.youtube.com/watch?v=leWJypzVyQ4&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=16) |
| **Instructor** | Abhishek Veeramalla                                                                                                                         |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)                                        |
| **Status**     | Completed                                                                                                                                   |

AWS offers 200+ services, but a DevOps engineer doesn't need to know all of them. Day 13 narrows that down to the ~15 services that actually come up in DevOps work and interviews.

---

## What is AWS?

AWS is a cloud provider spanning **IaaS** and **PaaS** models. Its core value proposition: turning complex products into simple, managed services. Example: instead of manually installing, deploying, and maintaining Kubernetes yourself, AWS offers it as a managed service (EKS) — click a button, get Kubernetes, and AWS handles everything underneath while you just scale up or down.

---

## Automation and Efficiency

Two themes that run through every DevOps topic — automation and efficiency — apply directly to how AWS services should be used and evaluated, not just to scripting.

---

## Core AWS Services for DevOps

| #   | Service        | Purpose                                                                                                                                   |
| --- | -------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | **EC2**        | Virtual servers / compute — covered in earlier days                                                                                       |
| 2   | **VPC**        | Virtual Private Cloud — securing resources via security groups, CIDR blocks/subnet ranges, inbound/outbound traffic rules                 |
| 3   | **EBS**        | Block storage volumes attached to EC2 instances — used for persistent data, snapshots, and backups                                        |
| 4   | **S3**         | Object storage for files, logs, and large volumes of data — cheap, extendable, and encrypted by default                                   |
| 5   | **IAM**        | Identity and Access Management — controls who can access what, with scoped permission policies per user/role                              |
| 6   | **CloudWatch** | Monitoring and observability — tracks actions and metrics across AWS, can trigger alerts/notifications on thresholds or policy violations |
| 7   | **Lambda**     | Serverless compute for short-lived actions — AWS provisions, runs, and tears down the execution environment automatically                 |

**CloudWatch + Lambda example:** if a developer creates an unencrypted EBS volume (violating org policy), CloudWatch detects the event, and a Lambda function can automatically send a notification — or even enforce encryption — without spinning up a dedicated EC2 instance for that one-off task.

---

## CI/CD Build Services

AWS provides native CI/CD tooling as an alternative to Jenkins or GitHub Actions:

| Service          | Role                                                                          |
| ---------------- | ----------------------------------------------------------------------------- |
| **CodePipeline** | Defines the overall pipeline flow — comparable to a Jenkins pipeline          |
| **CodeBuild**    | Fully managed build service — compiles code, runs tests, produces packages    |
| **CodeDeploy**   | Handles deployment of built artifacts to EC2 instances or on-premises servers |

**Worth evaluating:** if an organization is fully on AWS, it's worth questioning whether Jenkins is still needed versus native AWS build services. But if there's any chance of multi-cloud or migrating away from AWS later, native AWS-only tooling becomes a lock-in risk.

---

## Governance, Auditing & Security

| Service                              | Purpose                                                                                                                                           |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| **AWS Config**                       | Tracks resource configurations (e.g. flags unencrypted EBS volumes or unversioned S3 buckets) and can trigger remediation actions                 |
| **Billing & Cost Management**        | Visibility into where money is being spent across services (EC2, S3, EBS, etc.) over time                                                         |
| **AWS KMS (Key Management Service)** | Manages encryption keys/secrets — used to secure S3 buckets, EBS volumes, and rotate certificates                                                 |
| **CloudTrail**                       | Records API activity across AWS for operational and risk auditing/compliance — logs retained for a defined duration (e.g. last 30 days, 6 months) |

**CloudWatch vs. CloudTrail, in short:** CloudWatch = monitoring metrics/events in near real-time; CloudTrail = an audit log of API activity over time.

---

## Containers & Kubernetes on AWS

| Service                              | What It Is                                                                                                           |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------------------- |
| **EKS (Elastic Kubernetes Service)** | AWS's managed Kubernetes offering — if you already know Kubernetes fundamentals, EKS adds very little extra to learn |
| **Fargate**                          | Serverless compute for containers — run containers without managing underlying servers                               |
| **ECS (Elastic Container Service)**  | AWS's own proprietary container orchestration solution — similar in purpose to Kubernetes, but not Kubernetes-based  |

**EKS vs. ECS (common interview question):** both are container orchestration solutions, but ECS is AWS's proprietary system, while EKS is AWS's managed version of standard, portable Kubernetes.

---

## Logging: ELK Stack

**ELK** = Elasticsearch, Logstash, Kibana. Especially relevant in microservice architectures, where hundreds or thousands of services each emit logs — a centralized, queryable logging system (like Elasticsearch) is essential for tracking errors and patterns across a large fleet of services. Splunk is a common alternative in the same space.

---

## Key Takeaways

- Nobody needs to know all 200+ AWS services — focus on the ~15 that matter for DevOps work
- EC2, VPC, EBS, S3, IAM, CloudWatch, and Lambda form the essential core
- CI/CD on AWS (CodePipeline/CodeBuild/CodeDeploy) makes sense mainly for AWS-only orgs — avoid the lock-in if multi-cloud is a possibility
- Config, Billing, KMS, and CloudTrail are the governance/security/cost layer every DevOps engineer should be aware of
- EKS is worth learning fully; if Kubernetes fundamentals are solid, EKS itself is a small additional step
- Interview prep tip: these ~15 services are what interviewers most commonly ask about

---

## Progress Tracker

- [x] Watched the video
- [x] Mapped out the ~15 core AWS services relevant to DevOps
- [x] Understood CloudWatch + Lambda automation pattern
- [x] Understood EKS vs. ECS
- [x] Documented Day 13 notes
- [x] Move on to Day 14

---

## Resources

- [Day 13 Video](https://www.youtube.com/watch?v=leWJypzVyQ4&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=16)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
