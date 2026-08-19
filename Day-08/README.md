<div align="center">

# Day 08 — GitHub API Integration with Shell Scripting

### DevOps 90 Days Challenge

[![Video](https://img.shields.io/badge/YouTube-Watch%20Video-red?logo=youtube)](https://www.youtube.com/watch?v=OuyNM5-r8P8)
[![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla)
[![Day](https://img.shields.io/badge/Day-08%2F90-success)]()
[![Topic](https://img.shields.io/badge/Topic-GitHub%20API-orange)]()

</div>

---

## Table of Contents

- [Overview](#overview)
- [API vs. UI](#api-vs-ui)
- [Working with API Documentation](#working-with-api-documentation)
- [Practical Project: List Repository Collaborators](#practical-project-list-repository-collaborators)
- [Implementation Steps](#implementation-steps)
- [Best Practices & Improvements](#best-practices--improvements)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)
- [Resources](#resources)

---

## Overview

|                |                                                                                                      |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| **Day**        | 08 / 90                                                                                              |
| **Topic**      | GitHub API Integration with Shell Scripting                                                          |
| **Video**      | [Day-8 \| GitHub API Integration with Shell Scripting](https://www.youtube.com/watch?v=OuyNM5-r8P8)  |
| **Instructor** | Abhishek Veeramalla                                                                                  |
| **Series**     | [DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk) |
| **Status**     | Completed                                                                                            |

Day 8 moves from AWS automation into **GitHub API integration** — using shell scripting to programmatically manage and audit repository access, a genuinely common real-world DevOps task.

---

## API vs. UI

The UI is great for manual, one-off checks, but **APIs** let engineers interact with platforms like GitHub programmatically — which is exactly what makes automation possible. Anything you can click through in a UI, an API can typically do faster and repeatably from a script.

---

## Working with API Documentation

To use any API effectively, engineers need to reference the platform's **API documentation** to find:

- The correct **endpoints**
- The correct **HTTP methods** (GET, POST, etc.) for each action

Reading and navigating API docs is itself a core DevOps skill — not something to skip past.

---

## Practical Project: List Repository Collaborators

The core hands-on project: write a script to **list all users with access to a specific repository**.

This maps directly to a real-world scenario — e.g., after an employee resigns, confirming exactly who still has repository access, so it can be revoked if needed.

---

## Implementation Steps

1. **Environment Setup** — Using an EC2 instance, export your GitHub `username` and a **Personal Access Token (PAT)** as environment variables for authentication
2. **Script Execution** — The script accepts the **organization name** and **repository name** as command-line arguments to fetch collaborator data
3. **Data Processing** — Uses **jq** to parse the raw JSON API response, filtering it down to just what's needed — e.g. each collaborator's login name

---

## Best Practices & Improvements

- Add **helper functions** for input validation and clear error messages if the script is run incorrectly (e.g. missing arguments)
- Add **comments** documenting the script's purpose and required parameters, so it's usable by others without reading the whole script line by line

---

## Key Takeaways

- APIs are what turn manual UI actions into automatable, repeatable tasks
- Reading API documentation (endpoints + HTTP methods) is a prerequisite skill for any API integration work
- PAT-based authentication + environment variables is the standard pattern for scripting against GitHub
- `jq` continues to be the go-to tool for extracting usable data from JSON API responses
- Input validation and documentation turn a working script into a genuinely reusable tool

---

## Progress Tracker

- [x] Watched the video
- [x] Understood API vs. UI and reading API documentation
- [x] Understood PAT-based GitHub authentication
- [x] Documented Day 08 notes
- [x] Move on to Day 09

---

## Resources

- [Day 08 Video](https://www.youtube.com/watch?v=OuyNM5-r8P8)
- [Full Playlist — DevOps 90 Days Challenge](https://www.youtube.com/playlist?list=PLdpzxOOAlwvIc1TjTwopNSjRJkzES2ZXk)

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
