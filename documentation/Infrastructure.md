# Infrastructure

## Introduction

This document serves as a comprehensive guide to the underlying infrastructure supporting our full-stack web application. This application is developed using JavaScript with React on the frontend and Java with Spring Boot on the backend. The infrastructure is containerized with Docker and managed via Docker Compose for local development. In a production environment, it is hosted on AWS and orchestrated through Terraform.

## Local Development Environment

Our local development environment mirrors the following components:

- **Docker Containers Orchestrated with Docker Compose:**
    - **Reverse Proxy Container:** It expertly routes requests, directing `/api/v1/` requests to the backend while forwarding all other requests to the frontend.
    - **Backend Service Container:** Our backend service, built with Java and Spring Boot.
    - **Frontend Service Container:** The frontend, designed with React.
    - **PostgreSQL Database Container:** Housing our database needs.

## Production Environment

In the production environment, our application resides on AWS, specifically in the Frankfurt (eu-central-1) region. While Terraform takes care of most infrastructure provisioning, some critical resources are managed independently. These include:

- **S3 Bucket for Terraform State:** This repository stores our Terraform state files.
- **DynamoDB Table for Terraform State Locking:** Ensuring secure and exclusive access to Terraform state.
- **ACM Certificate for the Domain Name:** Guarantees secure SSL/TLS encryption for domain connections.
- **Route53 Hosted Zone for the Domain Name:** Facilitating DNS record management.

The infrastructure configuration encompasses:

- **Virtual Private Cloud (VPC):** Our VPC securely hosts all resources.
- **Amazon Elastic Container Registry (ECR):**
    - Two ECR registries manage frontend and backend Docker images.
    - Automated image builds are triggered upon merging to the main branch via GitHub Actions, each tagged with a commit SHA.
    - Only the last 50 images are kept
- **Amazon Elastic Container Service (ECS):**
    - Our application operates within ECS Fargate, delivering serverless container orchestration.
    - Two tasks, representing the server (backend) and client (frontend), retrieve Docker images from ECR registries.
- **Amazon RDS (Relational Database Service):** A PostgreSQL RDS instance serves as the application's database.
- **Amazon Application Load Balancer (ALB):** This component efficiently connects public-facing resources.
- **Amazon CloudWatch:** CloudWatch monitors and logs all resources.

## Deployment Strategy

Our deployment process is executed exclusively through a GitHub Actions job, providing a streamlined and efficient approach. It involves defining the image tag, which aligns with the tag used when building the image. Typically, the commit SHA is used as the image tag for versioning.

The deployment job accomplishes the following steps:

1. **Image Tag Definition:** A specific image tag, often derived from the commit SHA, is specified for deployment.

2. **Task Definition Update:** The deployment job expertly updates the ECS task definition with the new image tag, effectively triggering the ECS Cluster to replace the existing task with the updated revision.

This single, automated deployment strategy ensures consistent and reliable updates to our application while maintaining version control and minimizing manual intervention.
