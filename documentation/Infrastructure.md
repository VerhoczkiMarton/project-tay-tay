# Infrastructure

## Introduction

This document serves as a comprehensive guide to the underlying infrastructure supporting our full-stack web application. This application is developed using JavaScript with React on the frontend and Java with Spring Boot on the backend. The infrastructure is containerized with Docker and managed via Docker Compose for local development. In a production environment, it is hosted on AWS and orchestrated through Terraform.

## Local Development Environment

Our local development environment mirrors the following components:

- **Docker Containers Orchestrated with Docker Compose:**
    - **Backend Service Container:** Our backend service, built with Java and Spring Boot on port 8080.
    - **Frontend Service Container:** The frontend, designed with React on port 5173.
    - **PostgreSQL Database Container:** Housing our database needs on port 5432.

## Production Environment

In the production environment, our application resides on a hosted VPS on Hetzner that is running Coolify.

The infrastructure encompasses:

- **Virtual Private Cloud (VPC):** Our VPC securely hosts all resources.
- **Coolify Instance:** To orchestrate running sub-services.
- **Postgres database:** Not exposed to the public internet.
- **Frontend container:**Available on https://tay-tay-client.martonverhoczki.site
- **Backend container:** Available on https://tay-tay-server.martonverhoczki.site

## Deployment Strategy
### TODO
