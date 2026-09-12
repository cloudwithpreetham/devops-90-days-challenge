# Day 22: Project Management Tools for DevOps — Agile, Jira, ServiceNow & The First Week Onboarding Blueprint

> **Reference Video:** [Day-22 | Project Management tools for DevOps | What a DevOps Engineer does in the first week? (Abhishek Veeramalla)](https://youtu.be/h4HdQBnEO04)
> **Challenge Repository:** [cloudwithpreetham/devops-90-days-challenge](https://github.com/cloudwithpreetham/devops-90-days-challenge)

---

## 📌 Table of Contents

1. [Overview: The Non-Technical Reality of Enterprise DevOps](#-1-overview-the-non-technical-reality-of-enterprise-devops)
2. [Day 1 to Day 30: What a DevOps Engineer Actually Does in the First Month](#-2-day-1-to-day-30-what-a-devops-engineer-actually-does-in-the-first-month)
3. [Agile Framework & Scrum Ceremonies in DevOps](#-3-agile-framework--scrum-ceremonies-in-devops)
4. [Jira for DevOps: Epics, Stories, Kanban vs. Scrum](#-4-jira-for-devops-epics-stories-kanban-vs-scrum)
5. [ServiceNow (ITSM): Change Management, Incidents & CAB Approvals](#-5-servicenow-itsm-change-management-incidents-cab-approvals)
6. [Jira vs. ServiceNow: Key Enterprise Distinctions](#-6-jira-vs-servicenow-key-enterprise-distinctions)
7. [Confluence & Technical Documentation Standards](#-7-confluence--technical-documentation-standards)
8. [Real-World Operational Scenario: From P1 Outage to RCA](#-8-real-world-operational-scenario-from-p1-outage-to-rca)
9. [Interview Q&A: Project Management & Operational Processes](#-9-interview-qa-project-management--operational-processes)

---

## 🌐 1. Overview: The Non-Technical Reality of Enterprise DevOps

While tutorials emphasize writing Terraform, configuring Jenkins pipelines, and debugging Kubernetes pods, real-world enterprise engineering spends **30% to 50% of time collaborating within project management and IT service management (ITSM) ecosystems**.

```text
┌────────────────────────────────────────────────────────────────────────┐
│                        Enterprise DevOps Ecosystem                     │
├──────────────────────────┬──────────────────────────┬──────────────────┤
│   Engineering Planning   │    Production Governance │  Knowledge Base  │
│          (JIRA)          │       (ServiceNow)       │   (Confluence)   │
├──────────────────────────┼──────────────────────────┼──────────────────┤
│ • Sprint Planning        │ • Change Requests (CR)   │ • Architecture   │
│ • User Stories & Epics   │ • Incident Mgmt (P1-P4)  │ • Runbooks / SOP │
│ • Bug & Tech Debt Tracking│ • Service Requests (SR) │ • Post-Mortems   │
│ • Kanban & Scrum Boards  │ • CAB Governance         │ • KT Documents   │
└──────────────────────────┴──────────────────────────┴──────────────────┘
```

A production-grade DevOps engineer must navigate:

- **Agile delivery cadences** to align infrastructure automation with application release schedules.
- **Enterprise auditability** so that every single infrastructure change maps to a ticket, approval, and commit ID.
- **Strict compliance boundaries** preventing arbitrary production changes without automated change requests.

---

## 🧭 2. Day 1 to Day 30: What a DevOps Engineer Actually Does in the First Month

A frequent question for candidates transitioning into their first DevOps role is: _"What will I actually be asked to do on Day 1, Week 1, and Month 1?"_

```text
 Week 1: Access & Setup       Week 2: Shadowing & KT       Week 3: Sandbox Tasks        Week 4: Prod Support
┌────────────────────────┐   ┌────────────────────────┐   ┌────────────────────────┐   ┌────────────────────────┐
│ • VPN & SSO access     │   │ • Architecture KT      │   │ • Minor bug fixes      │   │ • First PR to main     │
│ • Hardware / Workstation│  │ • Deep-dive into repos │   │ • Dev/QA pipeline debug│   │ • On-call shadow       │
│ • Submit Access tickets│   │ • Review Runbooks      │   │ • Terraform in Sandbox │   │ • Attend CAB meetings  │
│ • Meet team & buddy    │   │ • Shadow daily tasks   │   │ • Create first Story   │   │ • Independent standup  │
└────────────────────────┘   └────────────────────────┘   └────────────────────────┘   └────────────────────────┘
```

### Week 1: Tooling, Access Provisioning & Compliance

1. **Corporate Onboarding:** Security compliance training, NDA, multi-factor authentication (MFA), and corporate VPN configuration.
2. **Access Requests (via ServiceNow):** Raising Service Requests (SR) for:
   - Version Control System (GitHub Enterprise / GitLab / Bitbucket org permissions).
   - Cloud Provider Access (AWS IAM role, Azure Active Directory tenant access).
   - Secret Manager Access (HashiCorp Vault, AWS Secrets Manager).
   - CI/CD Servers (Jenkins Controller admin/user rights, Argo CD SSO).
   - Monitoring & Observability (Datadog, Dynatrace, Grafana).
3. **Local Workstation Configuration:**
   - Setting up SSH keys and GPG commit signing keys.
   - Installing core CLI tooling: `aws-cli`, `az-cli`, `kubectl`, `helm`, `terraform`, `docker`, and `k9s`.

### Week 2: Knowledge Transfer (KT) & Architecture Review

1. **Reading Architecture Documentation (Confluence):**
   - High-Level Design (HLD) & Low-Level Design (LLD).
   - VPC topology, transit gateways, CIDR allocations, and ingress/egress firewalls.
   - Application dependency diagrams (microservices dependencies, database endpoints, cache layers).
2. **Repository Exploration:**
   - Reviewing branching strategy (Trunk-based vs. GitFlow).
   - Inspecting CI/CD pipeline definitions (`Jenkinsfile`, `.github/workflows/`, GitLab CI).
   - Reviewing Terraform module structure and state storage backends.
3. **Shadowing Senior Engineers:**
   - Attending daily standups and sprint planning.
   - Observing production release windows and monitoring triage sessions.

### Weeks 3 & 4: Sandbox Hands-On & First Contributions

1. Replicating the infrastructure in a Sandbox/Dev environment.
2. Picking up low-risk user stories:
   - Updating stale documentation or broken test scripts.
   - Adding a security scanning step (Trivy, SonarQube) to a development pipeline.
   - Refactoring a deprecated Terraform provider argument.
3. Submitting the first Pull Request (PR) through code reviews and automated CI checks.

---

## 🔄 3. Agile Framework & Scrum Ceremonies in DevOps

Agile enables DevOps teams to deliver iterative improvements rather than monolithic, risky infrastructure shifts.

```text
                  ┌─────────────────────────────────────────┐
                  │          Product Backlog Grooming       │
                  │    (Refine Epics, User Stories, Debt)   │
                  └────────────────────┬────────────────────┘
                                       │
                                       ▼
                  ┌─────────────────────────────────────────┐
                  │             Sprint Planning             │
                  │      (Commit 2-week Sprint Scope)       │
                  └────────────────────┬────────────────────┘
                                       │
            ┌──────────────────────────┴──────────────────────────┐
            ▼                                                     ▼
┌────────────────────────┐                             ┌────────────────────────┐
│  Daily Standup (15m)   │◄───────────────────────────►│ Continuous Development │
│ • Yesterday's progress │                             │ • Terraform, CI/CD, K8s│
│ • Today's commitment   │                             │ • PRs, Peer Reviews    │
│ • Any blockers         │                             └────────────────────────┘
└────────────────────────┘                                        │
            │                                                     │
            └──────────────────────────┬──────────────────────────┘
                                       ▼
                  ┌─────────────────────────────────────────┐
                  │         Sprint Review & Demo            │
                  │   (Showcase working pipeline to team)   │
                  └────────────────────┬────────────────────┘
                                       │
                                       ▼
                  ┌─────────────────────────────────────────┐
                  │           Sprint Retrospective          │
                  │ (What went well? What didn't? Action?)  │
                  └─────────────────────────────────────────┘
```

### The 5 Core Ceremonies

1. **Backlog Refinement (Grooming):**
   - Reviewing upcoming tasks with Product Owners and Tech Leads.
   - Estimating story points using the **Fibonacci Sequence** ($1, 2, 3, 5, 8, 13$) based on complexity, uncertainty, and effort.
2. **Sprint Planning:**
   - Defining sprint goals for a 2-week iteration.
   - Pulling user stories from the Product Backlog into the active Sprint Backlog based on team velocity.
3. **Daily Scrum (Standup):**
   - A 15-minute sync focused strictly on three questions:
     1. _What did I accomplish yesterday?_ (e.g., "Configured DynamoDB state locking for Terraform dev backend.")
     2. _What will I work on today?_ (e.g., "Drafting the Jenkinsfile to execute Trivy container scans.")
     3. _Are there any blockers preventing progress?_ (e.g., "Waiting on network security approval for outbound port 443 to Docker Hub.")
4. **Sprint Review / Demo:**
   - Demonstrating working deliverables to stakeholders (e.g., automated zero-downtime deployment working on a staging Kubernetes cluster).
5. **Sprint Retrospective:**
   - Internal team post-mortem: _What went well? What slowed us down? What will we commit to improving next sprint?_

---

## 📊 4. Jira for DevOps: Epics, Stories, Kanban vs. Scrum

Atlassian Jira is the standard tool for planning and tracking software and infrastructure engineering workloads.

### Jira Issue Hierarchy

```text
┌────────────────────────────────────────────────────────┐
│                         EPIC                           │
│  "Migrate E-Commerce Infrastructure to AWS EKS Cluster"│
└───────────────────────────┬────────────────────────────┘
                            │
       ┌────────────────────┴────────────────────┐
       ▼                                         ▼
┌───────────────────────────┐       ┌───────────────────────────┐
│        USER STORY         │       │        USER STORY         │
│ "Provision Multi-AZ EKS   │       │ "Implement Argo CD GitOps │
│  Cluster via Terraform"   │       │  Deployment Pipeline"     │
└──────────────┬────────────┘       └─────────────┬─────────────┘
               │                                  │
      ┌────────┴────────┐                ┌────────┴────────┐
      ▼                 ▼                ▼                 ▼
┌───────────┐     ┌───────────┐    ┌───────────┐     ┌───────────┐
│ Sub-Task  │     │ Sub-Task  │    │ Sub-Task  │     │   BUG     │
│ Write VPC │     │ Configure │    │ Deploy    │     │ Ingress   │
│ subnets   │     │ NodeGroup │    │ Argo Helm │     │ 502 Bad   │
│ modules   │     │ IAM roles │    │ chart     │     │ Gateway   │
└───────────┘     └───────────┘    └───────────┘     └───────────┘
```

### Writing a High-Quality DevOps User Story

A professional story follows the **User Persona format** with explicit **Acceptance Criteria**:

```text
Title: Automate Docker Container Vulnerability Scanning in Jenkins CI Pipeline

Description:
As a: Cloud Security & DevOps Engineer
I want to: Integrate Trivy scanner into our Jenkins build stages
So that: Vulnerable container images containing CRITICAL CVEs are blocked before pushing to Docker Hub.

Acceptance Criteria:
[ ] Trivy is invoked as an ephemeral Docker agent in the Jenkinsfile.
[ ] Pipeline fails immediately if any CVE with severity 'CRITICAL' is identified.
[ ] Scan results are exported in HTML/JUnit format and archived as build artifacts.
[ ] Scan execution time does not exceed 3 minutes.
```

### Scrum Board vs. Kanban Board in DevOps

- **Scrum Boards:** Best suited for planned, project-driven engineering work (e.g., migrating a service to Kubernetes, writing a new CI/CD pipeline). Driven by fixed 2-week sprints.
- **Kanban Boards:** Ideal for operations, infrastructure maintenance, and production support teams. Driven by **Continuous Flow** and strict **WIP (Work In Progress) Limits** to prevent cognitive overload:
  - _Backlog_ $\rightarrow$ _Selected for Development_ $\rightarrow$ _In Progress (Max: 3)_ $\rightarrow$ _Code Review / PR (Max: 2)_ $\rightarrow$ _Done_.

---

## 🛡️ 5. ServiceNow (ITSM): Change Management, Incidents & CAB Approvals

While Jira tracks internal engineering progress, **ServiceNow is the system of record for production operations, compliance, and enterprise governance (ITIL framework)**.

```text
       Developer / DevOps Engineer                       Change Advisory Board (CAB)
      ┌───────────────────────────┐                     ┌───────────────────────────┐
      │ 1. Complete Jira Story    │                     │  Reviews:                 │
      │ 2. Test in Staging        │                     │  • Blast radius           │
      │ 3. Create ServiceNow CR   ├────────────────────►│  • Backout / rollback plan│
      └───────────────────────────┘                     │  • Maintenance window     │
                                                        └─────────────┬─────────────┘
                                                                      │ Approved
                                                                      ▼
      ┌───────────────────────────┐                     ┌───────────────────────────┐
      │ 5. Automated Deployment   │◄────────────────────┤ 4. CR Enters 'Scheduled'  │
      │    (Jenkins / Argo CD)    │                     │    State for prod window  │
      └─────────────┬─────────────┘                     └───────────────────────────┘
                    │
                    ▼
      ┌───────────────────────────┐
      │ 6. Verify Health Metrics  │
      │ 7. Mark CR as 'Closed'    │
      └───────────────────────────┘
```

### The 3 Core ServiceNow Modules in DevOps

1. **Incident Management (INC):**
   - Tracks unplanned interruptions or service degradation.
   - Classified by **Severity/Priority**:
     - **P1 (Critical):** Complete revenue/system outage (e.g., payment gateway returns HTTP 500 across all users). Immediate bridge call activated.
     - **P2 (Major):** Severe degradation with no workaround (e.g., database read-replica down, high latency).
     - **P3 (Moderate):** Minor feature impairment with acceptable workaround.
     - **P4 (Low):** Cosmetic UI bug or internal reporting glitch.
2. **Change Request Management (CR / CHG):**
   - Mandatory record raised before altering any production asset (network, compute, database, deployments).
   - **Types of Changes:**
     - **Standard Change:** Pre-approved, routine, low-risk deployments (e.g., standard container image update tested in QA with automated test suites).
     - **Normal Change:** Requires formal review and **CAB (Change Advisory Board)** sign-off (e.g., database schema migration, Kubernetes major version upgrade, VPC routing change).
     - **Emergency Change:** Approved urgently by an Emergency CAB (ECAB) to resolve an active P1 production outage.
3. **Service Request (SR / RITM):**
   - Formal user requests for resources or permissions (e.g., requesting an AWS S3 bucket, onboarding a new hire to an AWS IAM group).

---

## ⚖️ 6. Jira vs. ServiceNow: Key Enterprise Distinctions

Understanding the boundary between Jira and ServiceNow is critical for both daily work and technical interviews:

| Dimension             | Atlassian Jira                                     | ServiceNow (ITSM)                                            |
| :-------------------- | :------------------------------------------------- | :----------------------------------------------------------- |
| **Primary Audience**  | Developers, DevOps engineers, Scrum Masters, QA    | Operations, IT leadership, Security, Compliance, Auditing    |
| **Core Purpose**      | Planning, building, and tracking project tasks     | Operational governance, system stability, risk mitigation    |
| **Typical Artifacts** | Epics, Stories, Bugs, Tasks, Sub-tasks             | Incidents (INC), Change Requests (CR), Service Requests (SR) |
| **Approval Flow**     | Peer code review (Pull Request) & QA sign-off      | Formal managerial and CAB (Change Advisory Board) approval   |
| **Audit Focus**       | Velocity, burndown charts, cycle time              | SLAs, MTTR (Mean Time to Resolution), compliance audits      |
| **Automation Role**   | Triggers CI builds when story moves to "In Review" | CI/CD checks CR status via REST API before applying to Prod  |

> 💡 **Modern GitOps Integration:** In mature DevOps environments, Jenkins or GitHub Actions queries ServiceNow's API using automated plugins (`ServiceNow DevOps Integration`). The pipeline pauses before the production stage, verifies that the Change Request is in `Approved` state and within the scheduled maintenance window, deploys the code, and automatically closes the CR.

---

## 📚 7. Confluence & Technical Documentation Standards

Engineering teams lose hundreds of hours to institutional knowledge silos when architecture is not documented. Confluence serves as the single source of truth.

### What DevOps Engineers Maintain on Confluence

1. **Standard Operating Procedures (SOPs):** Step-by-step guides for routine tasks (e.g., _SOP-042: Rotating Database Master Password and Vault Secrets_).
2. **Runbooks / Playbooks:** Actionable guides for debugging production alarms (e.g., _Runbook: Resolving Kubernetes CrashLoopBackOff on Payment Service_).
3. **Architecture Decision Records (ADRs):** Documents capturing why an architectural choice was made:
   - _Context:_ Why did we switch from Jenkins VM agents to ephemeral Docker containers?
   - _Decision:_ Replaced static EC2 workers with Docker Pipeline plugin.
   - _Consequences:_ 68% reduction in EC2 idle compute costs; 45-second container boot overhead.
4. **Post-Mortem / Root Cause Analysis (RCA) Documents:** Blameless evaluations of production outages.

---

## 🚨 8. Real-World Operational Scenario: From P1 Outage to RCA

To illustrate how these tools integrate during a real production incident:

```text
[02:14 UTC] CloudWatch alarm triggers: "Production Ingress 5xx Errors > 5%"
      │
      ▼
[02:16 UTC] PagerDuty triggers alert; DevOps engineer on-call acknowledges
      │
      ▼
[02:18 UTC] ServiceNow automatically creates P1 Incident: INC0048291
      │
      ▼
[02:20 UTC] Incident Commander opens dedicated Incident Bridge (Zoom/Slack)
      │
      ▼
[02:28 UTC] Triage identifies bad configuration committed to ConfigMap
      │
      ▼
[02:32 UTC] Emergency Change Request (CHG009182) raised and approved by ECAB
      │
      ▼
[02:35 UTC] Rollback executed via Argo CD to previous Git commit SHA
      │
      ▼
[02:40 UTC] Ingress metrics return to 100% green; Incident INC0048291 resolved
      │
      ▼
[Next Day]  Team holds blameless post-mortem; publishes RCA to Confluence;
            Creates Jira story to add automated ConfigMap validation in CI
```

### The Anatomy of an RCA (Root Cause Analysis)

- **Incident Summary:** Duration, impacted customer percentage, estimated financial/reputational impact.
- **Timeline:** Precise UTC timestamps tracking detection, triage, mitigation, and resolution.
- **Root Cause (5 Whys Analysis):**
  - _Why did the service fail?_ Ingress returned HTTP 502.
  - _Why 502?_ Backend pods failed to bind to port 8080.
  - _Why?_ A new environment variable was misnamed in the production ConfigMap.
  - _Why wasn't this caught?_ Staging configuration had the variable hardcoded in the Helm chart.
  - _Why?_ Staging and Production values files diverged without automated schema linting.
- **Action Items (logged in Jira):**
  - Story: Implement `helm lint` and `kubeval` schema validation in GitHub Actions CI.
  - Story: Add automated canary analysis before full traffic shifting.

---

## 💼 9. Interview Q&A: Project Management & Operational Processes

### Q1: "What does your typical day look like as an enterprise DevOps Engineer?"

**Answer:**

> "My day typically begins with reviewing monitoring dashboards (Grafana/Datadog) and checking overnight build statuses. I join the 15-minute daily Scrum standup, where I share progress on my active Jira user stories (e.g., developing reusable Terraform modules or optimizing pipeline runtimes) and raise any blockers.
>
> Mid-day is spent on focused engineering—writing infrastructure-as-code, reviewing peer pull requests in GitHub, or refining CI/CD pipelines. If a production release is scheduled, I participate in reviewing Change Requests (CR) in ServiceNow, ensuring test logs and rollback plans are verified before release windows. When on-call, my focus shifts to monitoring alerts and responding to ServiceNow incident tickets within our SLA limits."

---

#### Q2: "Why can't organizations just use Jira for production changes? Why do we need ServiceNow?"

**Answer:**

> "Jira is designed for software development task tracking and team agility; it is not built for ITIL regulatory compliance, risk auditability, and production governance.
>
> ServiceNow provides strict separation of duties required by audits (SOC2, ISO 27001, HIPAA). In ServiceNow, a developer who writes code cannot approve their own Change Request to deploy it to production. ServiceNow centralizes risk assessment through Change Advisory Boards (CAB), maintains configuration item (CI) dependencies via the CMDB, and tracks organizational SLAs for downtime and incident remediation."

---

#### Q3: "What is the difference between a Normal Change and an Emergency Change in ServiceNow?"

**Answer:**

> - **Normal Change:** Used for planned, non-trivial modifications to production infrastructure (e.g., migrating a database cluster, applying a major Kubernetes version upgrade). It requires a documented implementation plan, risk evaluation, rollback test plan, and scheduled review by the Change Advisory Board (CAB) days in advance.
> - **Emergency Change:** Reserved strictly for restoring service during an active critical incident (P1/P2) or patching a critical zero-day security exploit. It bypasses the standard weekly CAB and only requires verbal or expedited approval from the Emergency CAB (ECAB), with full retrospective documentation completed within 24 hours of resolution.

---

#### Q4: "How do you handle story estimation in an Agile DevOps team?"

**Answer:**

> "We estimate user stories using Story Points based on the modified Fibonacci sequence ($1, 2, 3, 5, 8$). Rather than estimating pure hours, story points capture three factors: **technical complexity, effort, and uncertainty/risk**.
>
> For example, updating an existing Docker image tag is a 1-pointer because the complexity and risk are negligible. Writing a brand-new Terraform module to provision an Amazon EKS cluster with custom IAM roles, KMS encryption, and VPC CNI networking is an 8-pointer due to high complexity and external integration risks. If a story exceeds 8 points, we break it down into smaller sub-stories."

---

#### Q5: "What is a Blameless Post-Mortem and why is it important in DevOps culture?"

**Answer:**

> "A blameless post-mortem assumes that engineers are well-intentioned and make the best decisions with the information they have at the time. Instead of asking _'Who broke the pipeline?'_, the team asks _'Why did our system allow an engineer to push an unvalidated configuration to production without automated checks catching it?'_
>
> The goal is to identify systemic weaknesses, missing unit tests, architectural blind spots, and lack of alerting, resulting in actionable Jira tickets to prevent recurrence rather than punishing individuals."

---

## 🔗 Reference Links & Resources

- **Reference Video:** [Day-22 | Project Management tools for DevOps | What a DevOps Engineer does in the first week? (Abhishek Veeramalla)](https://youtu.be/h4HdQBnEO04)
- **Challenge Repository:** [cloudwithpreetham/devops-90-days-challenge](https://github.com/cloudwithpreetham/devops-90-days-challenge)
- **Atlassian Agile Coach:** [https://www.atlassian.com/agile](https://www.atlassian.com/agile)
- **ITIL Service Management Fundamentals:** [https://www.axelos.com/certifications/itil-service-management](https://www.axelos.com/certifications/itil-service-management)
