# Cloud Infrastructure - Data Platform

## Overview

This repository manages the **cloud infrastructure layer** for the Data Platform.

The purpose of this repository is to provision and manage:

* AWS infrastructure required for Databricks
* Terraform backend (S3 + DynamoDB locking)
* IAM roles and policies
* Storage required for Databricks
* Databricks MWS (Account-level) configuration
* Databricks workspace creation

This repository is the **foundation layer** of the data platform.

---

## Architecture Responsibility

This repo manages:

✅ AWS Infrastructure

* S3 buckets
* IAM roles
* Networking (if applicable)
* Terraform backend

✅ Databricks Account Resources

* MWS credentials
* Storage configuration
* Network configuration
* Workspace provisioning

This repo does NOT manage:

❌ Unity Catalog objects
❌ Catalogs / Schemas / Tables
❌ Databricks Jobs or Pipelines

These are handled in separate repositories.

---

## Repository Structure

```
cloud-infra/
│
├── environments/
│   └── dev/
│       ├── backend.tf
│       ├── provider.tf
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
│
├── modules/
│   ├── iam/
│   ├── s3/
│   ├── network/
│   └── databricks-workspace/
│
└── README.md
```

---

## Prerequisites

Before running Terraform:

* Terraform >= 1.4 installed
* AWS CLI configured
* Databricks account admin access
* AWS permissions to create IAM, S3, and networking resources

Verify setup:

```
terraform version
aws sts get-caller-identity
```

---

## Setup Instructions

### 1. Clone Repository

```
git clone <repo-url>
cd cloud-infra/environments/dev
```

### 2. Create Variables File

```
cp terraform.tfvars.example terraform.tfvars
```

Update values as required.

---

### 3. Initialize Terraform

```
terraform init
```

---

### 4. Plan Infrastructure

```
terraform plan
```

---

### 5. Apply Infrastructure

```
terraform apply
```

---

## Important Notes

* Databricks workspace creation is a heavy operation.
* Workspaces should not be destroyed frequently.
* This repository is executed only during environment setup or major infrastructure changes.

---

## State Management

Terraform remote backend:

* S3 bucket for state storage
* DynamoDB table for state locking

State files must never be committed to Git.

---

## Related Repositories

* data-platform-infra → Unity Catalog, schemas, permissions
* data-pipelines → Jobs and workflows

---

## Maintainers

Data Platform Engineering
