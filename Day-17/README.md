# Day 17: Infrastructure as Code (IaC) with Terraform — Zero to Hero

![Terraform](https://img.shields.io/badge/Terraform-1.3+-623CE4?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws&logoColor=white)
![DynamoDB](https://img.shields.io/badge/Amazon-DynamoDB-4053D6?logo=amazondynamodb&logoColor=white)
![S3](https://img.shields.io/badge/Amazon-S3-569A31?logo=amazons3&logoColor=white)
![Challenge](https://img.shields.io/badge/90DaysOfDevOps-Day--17-blue)

Comprehensive notes, hands-on architectural implementations, and interview preparation from **Day 17** of Abhishek Veeramalla's *DevOps Zero to Hero / 90 Days of DevOps* course.

---

## 📌 Table of Contents

1. [Core Concepts: What is Infrastructure as Code (IaC)?](#core-concepts-what-is-infrastructure-as-code-iac)
2. [Why Terraform over CloudFormation / Azure ARM / CLI?](#why-terraform-over-cloudformation--azure-arm--cli)
3. [The Terraform Core Lifecycle](#the-terraform-core-lifecycle)
4. [Lab 1: First Infrastructure Deployment (Local State)](#lab-1-first-infrastructure-deployment-local-state)
   - [Project Structure](#project-structure)
   - [Configuration Files](#configuration-files)
5. [Deep Dive: The Terraform State File (`terraform.tfstate`)](#deep-dive-the-terraform-state-file-terraformtfstate)
   - [Why Storing State in Git or Local Machines is Dangerous](#why-storing-state-in-git-or-local-machines-is-dangerous)
6. [Lab 2: Production-Grade Remote Backend & State Locking](#lab-2-production-grade-remote-backend--state-locking)
   - [Architecture Workflow](#architecture-workflow)
   - [Remote Backend Configuration](#remote-backend-configuration)
7. [Terraform Modules](#terraform-modules)
8. [Real-World Limitations & Production Bottlenecks](#real-world-limitations--production-bottlenecks)
9. [Key Interview Questions & Answers](#key-interview-questions--answers)
10. [Commands Cheat Sheet](#commands-cheat-sheet)

---

## Core Concepts: What is Infrastructure as Code (IaC)?

Infrastructure as Code (IaC) allows provisioning, updating, and destroying cloud resources (compute, networking, storage, security) declaratively through version-controlled configuration files rather than manual dashboard clicks or ad-hoc scripts.

### Core Value Proposition

- **Repeatability**: Eliminate configuration drift across Development, Staging, and Production.

- **Collaboration & Auditability**: Review infrastructure changes via Pull Requests (PRs) before execution.
- **Standardization**: Enforce naming conventions, tagging, and network boundaries systematically.

---

## Why Terraform over CloudFormation / Azure ARM / CLI?

| Feature | HashiCorp Terraform | CloudFormation / ARM | Cloud CLI / Bash |
| :--- | :--- | :--- | :--- |
| **Cloud Scope** | **Cloud-Agnostic** (AWS, Azure, GCP, Alibaba, Kubernetes) | Vendor-locked (AWS / Azure) | Vendor-locked |
| **Language** | HashiCorp Configuration Language (HCL) | JSON / YAML | Shell / Bash / Python |
| **State Tracking** | Native state management (`.tfstate`) | Managed under the hood | None (manual check required) |
| **Dry-Run Capability** | Explicit deterministic plan (`terraform plan`) | Change Sets | None |
| **Provider Ecosystem** | Over 3,000+ community & verified providers | Cloud-specific | Cloud-specific |

---

## The Terraform Core Lifecycle

```text
  ┌───────────────┐
  │   main.tf     │
  │  (HCL Code)   │
  └───────┬───────┘
          │
          ▼
   terraform init       --> Downloads plugins & initializes backend
          │
          ▼
   terraform plan       --> Performs dry run against current state & target API
          │
          ▼
   terraform apply      --> Provisions infrastructure & updates .tfstate
          │
          ▼
   terraform destroy    --> Tears down managed infrastructure cleanly
```

1. **`terraform init`**: Scans `.tf` files, identifies required providers (e.g., `hashicorp/aws`), downloads plugin binaries into `.terraform/`, and initializes backends.
2. **`terraform plan`**: Refreshes current state against real cloud infrastructure, evaluates differences, and outputs an execution plan (+ add, ~ change, - destroy).
3. **`terraform apply`**: Translates HCL blocks into provider API calls, provisions resources in the specified cloud environment, and writes the resulting metadata to the state file.
4. **`terraform destroy`**: Reads the state file and deletes all resources previously created by the project.

---

## Lab 1: First Infrastructure Deployment (Local State)

### Project Structure

```text
Day-17/
├── local-state/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
```

### Configuration Files

#### 1. `main.tf`

```hcl
terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name        = var.instance_name
    Environment = "Dev"
  }
}
```

#### 2. `variables.tf`

```hcl
variable "aws_region" {
  description = "Target AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
  default     = "ami-08e2d37b6a0129927" # Update based on region
}

variable "instance_type" {
  description = "Compute instance size"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Tag Name for the EC2 Instance"
  type        = string
  default     = "Terraform-Demo-Instance"
}
```

#### 3. `outputs.tf`

```hcl
output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.app_server.private_ip
}
```

---

## Deep Dive: The Terraform State File (`terraform.tfstate`)

The state file is the **single source of truth** mapping declarative HCL configurations to real-world cloud resource IDs and attributes.

### Why Storing State in Git or Local Machines is Dangerous

1. **Plain-Text Secrets Exposure**: State files store database credentials, private keys, and sensitive resource parameters unencrypted. Pushing state files to GitHub causes severe credential leaks.
2. **Concurrent Overwrite (Race Conditions)**: If Engineer A and Engineer B run `terraform apply` concurrently with local state files, the last person to push overwrites the previous configuration, resulting in orphaned resources and silent production corruption.
3. **Out-of-Sync State**: A local state file on a single laptop prevents CI/CD pipelines and team members from understanding the true state of infrastructure.

---

## Lab 2: Production-Grade Remote Backend & State Locking

To safely enable team collaboration, Terraform state must be stored in a centralized, encrypted, remote location with distributed locking.

### Architecture Workflow

```text
  Developer / CI/CD Pipeline
            │
      terraform apply
            │
            ├──────────────► Acquires Lock in DynamoDB
            │                (Prevents concurrent execution)
            ▼
    Reads/Writes State
            │
            ├──────────────► S3 Bucket (Encrypted, Versioned)
            ▼
   Provisions Resources
            │
            ├──────────────► AWS Target Infrastructure
            ▼
    Releases Lock in DynamoDB
```

### 1. Provision Backend Storage & Locking Table

```hcl
resource "aws_s3_bucket" "terraform_state" {
  bucket        = "my-unique-devops-tf-state-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

### 2. Configure Backend in Main Project

```hcl
terraform {
  backend "s3" {
    bucket         = "my-unique-devops-tf-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}
```

---

## Terraform Modules

Modules are self-contained packages of Terraform configurations that group related resources into reusable components.

### Structure

```text
modules/
└── ec2-instance/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

### Calling a Module

```hcl
module "web_server" {
  source        = "./modules/ec2-instance"
  instance_type = "t2.micro"
  instance_name = "Prod-Web-Server"
  aws_region    = "us-west-2"
}
```

### Benefits

- **DRY (Don't Repeat Yourself)**: Define complex architectures once; reuse them across multiple environments (`dev`, `stage`, `prod`).

- **Blast Radius Reduction**: Segment state files and module calls by environment to isolate failures.

---

## Real-World Limitations & Production Bottlenecks

1. **State as a Single Point of Failure (SPOF)**: A corrupted state file halts all infrastructure automation until manually recovered or rebuilt.
2. **Out-of-Band Cloud Changes (Configuration Drift)**: If an engineer makes manual changes via the AWS Console, Terraform cannot automatically detect and revert them unless a manual `terraform refresh` or `terraform plan` is executed.
3. **Not Natively Bi-directional**: Unlike GitOps tools (e.g., ArgoCD for Kubernetes) that continuously reconcile live state against Git, Terraform runs only on demand (`apply`).
4. **Tool Overreach**: Treating Terraform as a configuration management tool (e.g., running complex package management scripts via `local-exec` / `remote-exec`) creates brittle setups. Use **Ansible** or **Packer** for OS/software configuration, and Terraform purely for infrastructure provisioning.

---

## Key Interview Questions & Answers

### Q1: What is the purpose of `terraform.tfstate` and where should it be stored?
>
> **Answer**: `terraform.tfstate` tracks metadata, resource dependencies, and mappings between declared HCL configurations and actual cloud resource IDs. It should **never** be stored locally or committed to Git due to plain-text secrets and sync issues. In production, it must be stored in a remote backend (like AWS S3 or Azure Blob Storage) with versioning, server-side encryption, and state locking enabled.

### Q2: Why is DynamoDB used with AWS S3 for remote backends?
>
> **Answer**: S3 alone does not provide distributed locking. If two team members or CI/CD pipelines run `terraform apply` concurrently, state file corruption can occur. DynamoDB provides state locking by acquiring an exclusive lock via the `LockID` primary key during execution and releasing it upon completion.

### Q3: How do you handle configuration drift in Terraform?
>
> **Answer**: Terraform detects drift by comparing live infrastructure attributes against the state file during `terraform plan` or `terraform refresh`. Running `terraform apply` updates the cloud provider back to the desired state declared in the configuration files.

### Q4: What is the difference between `variables.tf` and `terraform.tfvars`?
>
> **Answer**: `variables.tf` declares the variable definitions, types, descriptions, and optional fallback defaults. `terraform.tfvars` provides the actual values assigned to those declared variables for specific environments.

---

## Commands Cheat Sheet

| Command | Description |
| :--- | :--- |
| `aws configure` | Set up local AWS credentials (`~/.aws/credentials`) |
| `terraform init` | Initialize working directory, backend, and provider plugins |
| `terraform init -migrate-state` | Migrate local state to a remote backend |
| `terraform fmt` | Auto-format HCL code to adhere to standard conventions |
| `terraform validate` | Validate HCL syntax and internal consistency |
| `terraform plan` | Generate and show an execution plan without applying changes |
| `terraform apply -auto-approve` | Execute changes directly without interactive confirmation |
| `terraform output` | Read and display values defined in `outputs.tf` |
| `terraform destroy` | Destroy all infrastructure managed by the current state file |

---

## 🔗 References & Credits

- Course Video: [Day 17 | Everything about Terraform](https://youtu.be/CzdfdKWRDB8)

- Instructor: [Abhishek Veeramalla](https://github.com/iam-veeramalla)
- Challenge Repo: [devops-90-days-challenge](https://github.com/cloudwithpreetham/devops-90-days-challenge)
