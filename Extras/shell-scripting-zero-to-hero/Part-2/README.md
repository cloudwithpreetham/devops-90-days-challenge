<div align="center">

# Extra — Shell Scripting for DevOps: Zero to Hero (Part-2)

### DevOps 90 Days Challenge — Extras

[![Instructor](https://img.shields.io/badge/Instructor-Abhishek%20Veeramalla-blue)](https://www.youtube.com/@AbhishekVeeramalla)
[![Type](https://img.shields.io/badge/Type-Extra-lightgrey)]()
[![Topic](https://img.shields.io/badge/Topic-Advanced%20Bash%20Scripting-orange)]()

</div>

---

## Table of Contents

- [Overview](#overview)
- [Node Health Monitoring](#node-health-monitoring)
- [Scripting Best Practices](#scripting-best-practices)
- [Process Management](#process-management)
- [Error Handling](#error-handling)
- [Remote Log Analysis](#remote-log-analysis)
- [System Utility Commands](#system-utility-commands)
- [Signal Trapping](#signal-trapping)
- [Key Takeaways](#key-takeaways)
- [Progress Tracker](#progress-tracker)

---

## Overview

|                |                                                                 |
| -------------- | --------------------------------------------------------------- |
| **Series**     | Shell Scripting for DevOps — Zero to Hero                       |
| **Part**       | Part-2                                                          |
| **Topic**      | Advanced Bash Scripting for DevOps                              |
| **Instructor** | Abhishek Veeramalla                                             |
| **Related to** | [Part-1](../Part-1/README.md) — Introduction to Shell Scripting |
| **Status**     | Completed                                                       |

Part-2 builds on the fundamentals from Part-1, moving into advanced Bash scripting techniques and practical, real-world DevOps use cases — monitoring, process management, robust error handling, and troubleshooting.

---

## Node Health Monitoring

A practical script is built to analyze a node's health across three dimensions:

- **Disk space**
- **Memory usage**
- **CPU usage**

This is a common real-world DevOps pattern — scripting basic health checks that can run repeatedly across a fleet of servers.

---

## Scripting Best Practices

- **Metadata & comments** — documenting what a script does and why, so it's maintainable by others (or future you)
- **`set -x`** — enables debug mode, printing each command as it executes, making it much easier to trace what a script is actually doing when something goes wrong

---

## Process Management

Covers filtering and inspecting running processes using a common command chain:

- **`ps -ef`** — lists all running processes
- Combined with **`grep`** — to filter for a specific process by name
- Combined with **`awk`** — to extract specific fields, such as the process ID (PID)

This combination is a standard pattern for finding and acting on specific processes from a script.

---

## Error Handling

Two key options for making scripts more robust:

- **`set -e`** — causes the script to exit immediately if any command fails, instead of silently continuing
- **`set -o pipefail`** — ensures that a failure anywhere in a piped command chain is caught, not just the last command's exit status

Together, these prevent scripts from continuing on in a broken or inconsistent state after an error.

---

## Remote Log Analysis

Demonstrates retrieving and parsing remote log files using:

- **`curl`**
- **`wget`**

Used together with text-processing commands to scan remote logs for errors — a practical technique for troubleshooting issues on systems you don't have direct shell access to.

---

## System Utility Commands

- **`find`** — searching for files across the filesystem
- **`sudo` / `su`** — switching users and managing elevated permissions
- **if-else** and **for loops** — basic control flow and iteration, the building blocks for any non-trivial script

---

## Signal Trapping

Introduces the **`trap`** command — used to intercept and handle signals like a keyboard interrupt (**Ctrl+C**), allowing a script to clean up gracefully instead of dying mid-execution.

---

## Key Takeaways

- Real DevOps scripts combine monitoring, process filtering, and error handling — not just single commands in isolation
- `set -e` and `set -o pipefail` are essential defaults for any script meant to run unattended or in automation
- `ps -ef | grep ... | awk ...` is a foundational pattern worth memorizing for process management
- `trap` turns a fragile script into one that can shut down cleanly, which matters a lot for scripts touching shared infrastructure

---

## Progress Tracker

- [x] Watched Part-2
- [x] Built a basic node health monitoring script
- [x] Practiced process filtering (`ps -ef`, `grep`, `awk`)
- [x] Understood error handling (`set -e`, `set -o pipefail`) and `trap`
- [x] Documented Part-2 notes

---

<div align="center">

_Part of my 90 Days DevOps Challenge journey — documenting daily learnings as I go._

</div>
