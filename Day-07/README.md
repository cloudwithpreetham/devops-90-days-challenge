<div align="center">

# Day 07 — AWS Resource Tracker with Shell Scripting

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch%20Video-red?logo=youtube)](https://www.youtube.com/watch?v=CyQtk9f646Q&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=10)
[![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla)
[![Day](https://img.shields.io/badge/Day-07%2F90-success)]()
[![Topic](https://img.shields.io/badge/Topic-AWS%20%2B%20Shell%20Scripting-orange)]()

</div>

---

## Table of Contents

- [Overview](#overview)
- [The Necessity of Cloud Monitoring](#the-necessity-of-cloud-monitoring)
- [Shell Scripting & AWS CLI](#shell-scripting--aws-cli)
- [Code Optimization](#code-optimization)
- [Automation with Cron](#automation-with-cron)
- [My Project: AWS Resource Tracker](#my-project-aws-resource-tracker)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                                                                     |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Day**        | 07 / 90                                                                                                                                             |
| **Topic**      | AWS Resource Tracker with Shell Scripting                                                                                                           |
| **Video**      | [Day-7 \| AWS Resource Tracker using Shell Scripting](https://www.youtube.com/watch?v=CyQtk9f646Q&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=10) |
| **Instructor** | Abhishek Veeramalla                                                                                                                                 |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)                                                |
| **Status**     | Completed                                                                                                                                           |

Day 7 puts Shell Scripting to real use — building an **AWS Resource Tracker** that helps DevOps engineers monitor resource usage and keep cloud costs under control.

---

## The Necessity of Cloud Monitoring

Managing cloud costs is a core DevOps responsibility. Organizations frequently accumulate unused resources — orphan EBS volumes, unutilized EC2 instances — that quietly rack up unnecessary expenses if nobody's tracking them.

---

## Shell Scripting & AWS CLI

The tutorial walks through building a Bash script (`AWS_resource_tracker.sh`) that uses the **AWS CLI** to list out:

- **S3 buckets**
- **EC2 instances**
- **Lambda functions**
- **IAM users**

---

## Code Optimization

To make the script more usable and maintainable, the video covers:

- Adding **echo statements** for readability and progress visibility
- Using **debug mode** (`set -x`) to trace execution
- Parsing complex JSON output from the AWS CLI using **jq** to extract specific fields — e.g. pulling out Instance IDs cleanly instead of raw JSON

---

## Automation with Cron

To keep the resource report current without manual effort, the script is scheduled using a **Cron job** — a Linux utility for running commands on a fixed schedule (e.g. daily at 6 PM). The final script writes its output to a text file, acting as a simple, automated dashboard managers can check for resource status.

---

## My Project: AWS Resource Tracker

Building on this video, I implemented my own version of the AWS Resource Tracker:

```
Day-07/aws-shell-scripting/
├── aws-resource-tracker.sh    # main tracking script
├── aws-resource-tracker.log   # generated report output
└── screenshots/                # execution/output screenshots
```

- **`aws-resource-tracker.sh`** — Bash script using the AWS CLI to pull resource details (S3, EC2, Lambda, IAM) and generate a status report
- **`aws-resource-tracker.log`** — sample output log from running the script
- **`screenshots/`** — visual proof of the script running and its output

---

## Key Takeaways

- Cost visibility is a hands-on DevOps responsibility, not just a finance concern
- A simple Bash + AWS CLI script can already surface real, actionable resource data
- `jq` is essential for turning verbose AWS CLI JSON output into something readable and usable
- Cron turns a one-off script into a recurring, hands-off monitoring habit
- Small automation scripts like this are exactly the kind of practical project worth showcasing in a portfolio

---

## Progress Tracker

- [x] Watched the video
- [x] Understood cloud cost monitoring and its importance
- [x] Built my own AWS Resource Tracker script
- [x] Documented Day 07 notes
- [x] Move on to Day 08

---

## Resources

- [Day 07 Video](https://www.youtube.com/watch?v=CyQtk9f646Q&list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk&index=10)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
