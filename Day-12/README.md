<div align="center">

# Day 12 — Deploying a NodeJS App on AWS EC2 (Guest Session with Kunal Verma)

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch%20Video-red?logo=youtube)](https://www.youtube.com/watch?v=NLmF64KdLN0&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=15)
[![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla)
[![Guest](https://img.shields.io/badge/Guest-Kunal%20Verma-purple)]()
[![Day](https://img.shields.io/badge/Day-12%2F90-success)]()
[![Topic](https://img.shields.io/badge/Topic-AWS%20Deployment-orange)]()

</div>

---

## Table of Contents

- [Overview](#overview)
- [Local Setup](#local-setup)
- [IAM: Identity and Access Management](#iam-identity-and-access-management)
- [Launching the EC2 Instance](#launching-the-ec2-instance)
- [Connecting via SSH](#connecting-via-ssh)
- [Setting Up the Server](#setting-up-the-server)
- [Exposing the App to the Internet](#exposing-the-app-to-the-internet)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                                                          |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **Day**        | 12 / 90                                                                                                                                  |
| **Topic**      | Deploying a NodeJS Application on AWS EC2                                                                                                |
| **Video**      | [Day-12 \| Deploy a NodeJS App on AWS EC2](https://www.youtube.com/watch?v=NLmF64KdLN0&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=15) |
| **Instructor** | Abhishek Veeramalla                                                                                                                      |
| **Guest**      | Kunal Verma — DevRel Intern at Devtron, Cube Simplify community ambassador                                                               |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)                                     |
| **Status**     | Completed                                                                                                                                |

A special guest session with Kunal Verma, who walks through deploying a real NodeJS application (using Stripe payment integration) end-to-end — from local testing to a live, internet-accessible app running on AWS EC2.

---

## Local Setup

Before deploying anywhere, the app is cloned and tested locally to confirm it works:

1. **`git clone`** — download the repository locally
2. **Set up a `.env` file** — used to store credentials/config that shouldn't be hardcoded or exposed (e.g. Stripe's publishable key and secret key)
3. **`npm install`** — installs all dependencies via Node Package Manager (the Node.js equivalent of Python's `pip`)
4. **`npm run start`** — runs the app locally to confirm it works before touching any cloud infrastructure

---

## IAM: Identity and Access Management

Rather than using the AWS **root account** (the full-access admin user) for everyday work, the video walks through creating a dedicated **IAM user** with scoped permissions:

- Root account = full access to everything — not meant for daily use
- **IAM** lets you create individual users and assign them only the permissions they actually need (e.g. a developer might only need EC2 access, not everything)
- Permissions can be attached directly to a user or grouped into **permission groups** for easier management across teams
- This session used Administrator Access for simplicity, but scoping to just EC2 permissions is recommended for practice

---

## Launching the EC2 Instance

Key configuration choices when launching:

| Setting              | Choice Made                                                     |
| -------------------- | --------------------------------------------------------------- |
| **OS Image**         | Ubuntu (26.04 LTS)                                              |
| **Instance Type**    | t3.micro (Free Tier eligible)                                   |
| **Key Pair**         | New `.pem` key created for SSH authentication                   |
| **Network Settings** | Left at default, with "Allow SSH traffic from anywhere" enabled |

**EC2** stands for Elastic Compute Cloud — it lets you spin up remote servers without needing powerful local hardware. This removes the maintenance overhead (patching, upgrades, hypervisor management) that comes with running your own physical servers, and makes it much easier to scale applications up by adding more instances as needed.

**Regions & Availability Zones** exist primarily to reduce latency — choosing a region close to your users (or yourself) keeps things fast.

---

## Connecting via SSH

To securely log into the new EC2 instance:

1. Locate the downloaded `.pem` key file
2. **`chmod 400 <key>.pem`** — restricts the key file so only the owner can read it (not write or execute), which SSH requires for security
3. **`ssh -i <key>.pem ubuntu@<public-ip>`** — connects to the instance using the key
4. Accept the host fingerprint prompt to add it to your known hosts

---

## Setting Up the Server

Once connected, the remote Ubuntu server is set up from scratch — essentially treating it like a brand-new machine:

1. **`sudo apt update`** — refresh package lists and update outdated packages (good practice on any fresh Linux instance)
2. **Install Git** (already present on this Ubuntu image, but not guaranteed on all images)
3. **Install Node.js and npm** — following a DigitalOcean guide for the correct install commands
4. **`git clone`** — clone the application repository onto the remote server
5. **Recreate the `.env` file** — since `.env` isn't committed to git, it has to be manually recreated on the server (using `vi`/`vim`)
6. **`npm install`** then **`npm run start`** — install dependencies and run the app on the remote server

---

## Exposing the App to the Internet

Running the app on the server isn't enough — by default, the outside internet can't reach it. This is a very common point of confusion for beginners:

- The app running on port `3000` inside the EC2 instance is invisible to the internet until explicitly allowed
- Fix: go to the instance's **Security Group → Inbound Rules → Edit inbound rules**
- Add a new rule allowing **custom TCP traffic on port 3000** from **anywhere (0.0.0.0/0)**
- Once saved, the app becomes accessible via `http://<public-ip>:3000`

This same inbound rule mechanism is what allows SSH (port 22) to work in the first place — it was pre-added when the instance was launched.

To restrict access to specific users/customers instead of the whole internet, the source can be locked down to a specific IP range or CIDR block instead of `0.0.0.0/0`.

---

## My Project: AWS-Session

I cloned and deployed Kunal's actual project repository as part of this session:

```
Day-12/AWS-Session/
├── client/           # static frontend served by the app
├── .gitignore
├── Dockerfile
├── package.json
├── server.js          # Node.js/Express server + Stripe integration
├── LICENSE
└── README.md
```

- **Source:** [github.com/verma-kunal/AWS-Session](https://github.com/verma-kunal/AWS-Session)
- **Stack:** Node.js + Express, static `client/` frontend, Stripe payment integration
- **Environment variables required (`.env`):**
  ```
  DOMAIN=""
  PORT=3000
  STATIC_DIR="./client"
  PUBLISHABLE_KEY=""
  SECRET_KEY=""
  ```
- **Run locally:** `npm install` → `npm run start`
- **Deployed following the exact flow above:** IAM user → EC2 (Ubuntu, t2.micro) → SSH via `.pem` key → install Git/Node.js/npm → clone → recreate `.env` → `npm install && npm run start` → open port 3000 in the security group's inbound rules

A `Dockerfile` is also included in the repo, which is worth revisiting later in the challenge once Docker is covered — containerizing this same app instead of running it directly on the EC2 instance.

---

## Key Takeaways

- Always test an application locally before deploying it to the cloud
- `.env` files keep secrets (API keys, credentials) out of source control — and have to be manually recreated on any new server
- Never use the AWS root account for daily work — IAM users with scoped permissions are the standard practice
- EC2 removes the maintenance burden of running physical servers, and makes scaling straightforward
- `.pem` key + `chmod 400` + SSH is the standard way to securely access a remote instance
- The single most common beginner blocker: forgetting to open the right port in the **security group's inbound rules** — the app can be running perfectly and still be completely unreachable from the internet until this is fixed
- Real deployment work involves a lot of googling, trial and error, and referring back to documentation (DigitalOcean's guides were highlighted as especially good)

---

## Progress Tracker

- [x] Watched the video
- [x] Understood the local dev → IAM → EC2 → SSH → deploy → expose flow end-to-end
- [x] Understood security groups and inbound rules
- [x] Documented Day 12 notes
- [x] Move on to Day 13

---

## Resources

- [Day 12 Video](https://www.youtube.com/watch?v=NLmF64KdLN0&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=15)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)
- Guest: Kunal Verma — DevRel Intern at Devtron, Cube Simplify community ambassador

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
