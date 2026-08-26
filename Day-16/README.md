<div align="center">

# Day 16 — Infrastructure as Code & API as Code

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch-red?logo=youtube)](https://www.youtube.com/watch?v=G1BRnIHBBig&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=19) [![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla) [![Day](https://img.shields.io/badge/Day-16%2F90-success)](https://github.com/cloudwithpreetham/devops-90-days-challenge/blob/main/Day-16) [![Topic](https://img.shields.io/badge/Topic-Terraform-purple)](https://github.com/cloudwithpreetham/devops-90-days-challenge/blob/main/Day-16)

</div>

---

## Table of Contents

- [Overview](#overview)
- [The Problem: One Cloud Provider, One Tool](#the-problem-one-cloud-provider-one-tool)
- [The Problem Gets Worse: Hybrid Cloud](#the-problem-gets-worse-hybrid-cloud)
- [Enter Terraform](#enter-terraform)
- [What Is an API? (A Quick Detour)](#what-is-an-api-a-quick-detour)
- [How Terraform Uses API as Code](#how-terraform-uses-api-as-code)
- [Infrastructure as Code vs API as Code](#infrastructure-as-code-vs-api-as-code)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                                                  |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **Day**        | 16 / 90                                                                                                                          |
| **Topic**      | Infrastructure as Code \| API as Code \| Why Terraform Exists                                                                    |
| **Video**      | [Day-16 \| Infrastructure as Code](https://www.youtube.com/watch?v=G1BRnIHBBig&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=19) |
| **Instructor** | Abhishek Veeramalla                                                                                                              |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)                             |
| **Status**     | Completed (theory) — Terraform installation & live project next                                                                  |

Day 16 is a theory-only session that sets up _why_ Terraform exists before touching it hands-on. Using a running "Flipkart" example, it walks through the real pain of cloud-specific automation tools, why hybrid cloud makes that pain worse, and how Terraform's "API as code" approach solves it. The hands-on Terraform installation and live project are saved for the next video.

---

## The Problem: One Cloud Provider, One Tool

Picture being the DevOps engineer for a company like Flipkart, deciding to host all infrastructure on AWS. To automate resource creation (EC2 instances, S3 buckets, RDS databases) instead of clicking through the console, the natural choice is **AWS CloudFormation Templates (CFT)** — and over time, hundreds of CFT scripts get written and stabilized.

Then leadership decides to move from AWS to Microsoft Azure — maybe over support quality, maybe over cost. Every one of those CFT scripts is now dead weight, because CFT is AWS-specific. The same automation has to be rewritten from scratch using **Azure Resource Manager (ARM)**.

Then leadership decides to move again — this time to an on-premises OpenStack setup. Same story again: everything gets rewritten a third time, now using OpenStack's **Heat Templates**.

Each cloud provider (or platform) has its own infrastructure-as-code tool, and none of them transfer to the next one.

---

## The Problem Gets Worse: Hybrid Cloud

In practice, most organizations don't even pick just one cloud — they run a **hybrid cloud** model: part of the infrastructure on AWS (say, because AWS's storage services are strong), part on Azure (say, because Azure's DevOps tooling is strong), possibly part on-prem for specific secure workloads.

That means a DevOps engineer doesn't get to learn just one automation tool — they need CFT **and** ARM **and** whatever the on-prem platform needs, simultaneously, and that list only grows as more providers get added to the mix.

---

## Enter Terraform

**Terraform**, built by HashiCorp, exists specifically to solve this "too many tools" problem. Instead of learning a different infrastructure-as-code language for every provider, the pitch is: learn **one** tool, and Terraform handles talking to whichever provider you point it at — AWS, Azure, GCP, OpenStack, and beyond.

You write Terraform scripts, declare which provider you're targeting (e.g. in a `provider.tf` file), and Terraform translates that into the right calls for that specific platform.

Migrating between clouds is still not _zero_ effort with Terraform — provider blocks and provider-specific modules still need updating — but it's a far smaller lift than rewriting hundreds of scripts in an entirely different tool and syntax each time.

---

## What Is an API? (A Quick Detour)

Since this came up as a common question from the previous class: an **API (Application Programming Interface)** is how software talks to other software, as opposed to how a human talks to software through a UI.

- **Manual/UI way:** open a browser, go to google.com, interact with the page.
- **Programmatic/API way:** a script sends a request directly to Google's (or GitHub's, or any service's) API — no browser, no clicking — and gets a response back, ready to be used in automation.

Any modern platform (GitHub, cloud providers, etc.) exposes an API specifically so scripts and tools can interact with it without a human driving a UI.

---

## How Terraform Uses API as Code

AWS has its own API. Azure has its own API. Every provider does. Talking to those APIs directly usually means writing custom code — Python, shell scripts, handling authentication, building the right HTTP calls yourself.

Terraform removes that step. You write a Terraform file describing what you want (e.g. "an EC2 instance" using AWS's EC2 module) in a much simpler, declarative syntax. Terraform then:

1. Takes your Terraform configuration
2. Converts it into the correct API call for the provider you specified
3. Sends that request to the provider's API
4. Returns the result back to you

You never touch the raw API yourself — Terraform sits between you and every provider's API, which is why this approach is described as **"API as code."**

---

## Infrastructure as Code vs API as Code

- **Infrastructure as Code (IaC)** is the broader concept: managing infrastructure through code instead of manual clicks. AWS CFT, Azure ARM, and OpenStack Heat Templates are all examples of IaC — each one, however, locked to a single provider.
- **API as Code** is Terraform's specific approach to IaC: one unified language that compiles down to whichever provider's API you're targeting, so you're not relearning a new tool every time the underlying provider changes.

Terraform is still infrastructure as code — it just adds the API-as-code layer on top so the same skill transfers across providers.

---

## Key Takeaways

- Every cloud/platform-specific IaC tool (CFT, ARM, Heat Templates) locks your automation to that one provider
- Migrating providers historically meant rewriting all your automation from scratch in a new tool
- Hybrid cloud setups make this worse — engineers end up needing to know several provider-specific tools at once
- Terraform (by HashiCorp) solves this by being provider-agnostic: one syntax, many providers
- An API is how software talks to software programmatically, without a human-driven UI in the loop
- Terraform's "API as code" approach means your `.tf` files get translated into the correct API calls for whichever provider you declare — you never write those API calls yourself
- Terraform doesn't make cross-cloud migration completely free, but it's a far smaller lift than a full tool rewrite
- Today was theory-only — Terraform installation and a live project come next

---

## Progress Tracker

- [x] Watched the video
- [x] Understood the problem with provider-specific IaC tools (CFT, ARM, Heat Templates)
- [x] Understood how hybrid cloud multiplies that problem
- [x] Learned why Terraform was created and what problem it solves
- [x] Understood what an API is and why it matters for automation
- [x] Understood Terraform's "API as code" model
- [x] Documented Day 16 notes
- [x] Terraform installation + live project — carries over to Day 17

---

## Resources

- [Day 16 Video](https://www.youtube.com/watch?v=G1BRnIHBBig&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=19)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
