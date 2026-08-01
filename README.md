# azure-cloud-lab
![Terraform CI/CD Pipeline](https://github.com/yasmin-glitch/azure-cloud-lab/actions/workflows/terraform.yml/badge.svg)
# Enterprise Azure Infrastructure Automation

## Overview
This repository contains the Infrastructure as Code (IaC) configuration for deploying a production-grade, secure hub-and-spoke network topology in Microsoft Azure. The infrastructure is entirely provisioned using Terraform, with automated testing, security scanning, and deployment managed via GitHub Actions.

## Architecture
The deployment provisions a secure networking foundation suitable for enterprise environments:
*   **Hub Virtual Network:** Acts as the central point of connectivity.
*   **Spoke Virtual Networks:** Isolated environments for workloads, peered securely to the hub.
*   **Remote State Management:** Terraform state is securely stored in an Azure Storage Account with state locking enabled to prevent concurrent modification issues.

## Technologies & Tools
*   **Cloud Provider:** Microsoft Azure
*   **Infrastructure as Code:** Terraform
*   **CI/CD Pipeline:** GitHub Actions
*   **DevSecOps / Static Analysis:** tfsec

## CI/CD Pipeline (GitHub Actions)
The automated workflow is triggered on pull requests and pushes to the `main` branch. The pipeline consists of the following stages:
1.  **Format & Validate:** Runs `terraform fmt` and `terraform validate` to ensure syntactical correctness.
2.  **Security Scan:** Executes `tfsec` to perform static analysis and identify potential security vulnerabilities in the Terraform code before deployment.
3.  **Plan:** Generates a speculative execution plan (`terraform plan`) for review.
4.  **Apply:** Automatically applies the infrastructure changes upon merging into the `main` branch (`terraform apply -auto-approve`).

## Local Setup & Prerequisites

To run or modify this project locally, ensure you have the following installed:
*   [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
*   [Terraform](https://developer.hashicorp.com/terraform/downloads) (macOS users can install via Homebrew: `brew tap hashicorp/tap && brew install hashicorp/tap/terraform`)
*   [tfsec](https://aquasecurity.github.io/tfsec/v1.28.1/guides/installation/) (macOS users can install via Homebrew: `brew install tfsec`)

### Authentication
Login to your Azure account and set your subscription:
```bash
az login
az account set --subscription="<YOUR_SUBSCRIPTION_ID>"