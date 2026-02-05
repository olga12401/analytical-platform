# Analytical Data Platform

This repository contains an analytical data platform built from scratch,
following production-oriented principles and data engineering practices.

The project focuses on **analytics, transformations, orchestration, and BI**.
Data ingestion is treated as a separate system and is intentionally out of scope.

This repository represents the **current working state** of the platform.

---

## Project goals

- Build a production-like analytical platform end to end
- Separate human access from service-to-service authentication
- Apply workload isolation and least-privilege principles
- Make the project reproducible via Git and documented step by step
- Document architectural decisions and their evolution

---

## Project status

**Current state:**

- Local Docker-based setup for development ✅
- dbt project with layered models (staging → intermediate → marts) ✅
- CI/CD with GitHub Actions ✅
- Airflow deployed as orchestration layer (manual DAG runs) ✅
- Scheduled Airflow runs ❌
- Automated loading into production Snowflake ❌
- BI layer (Metabase) ❌

The platform is under active development.
Architecture evolves as new components are introduced.

---

## Scope and boundaries

### Included in this project

- Analytical data modeling with dbt
- Orchestration and scheduling with Airflow
- CI/CD automation with GitHub Actions
- Secure secret management (AWS Secrets Manager, GitHub Secrets)
- Snowflake as the analytical warehouse
- BI layer (planned)

### Explicitly out of scope

- Data ingestion and extraction
- Source system connectors
- Streaming or batch ingestion pipelines

Raw data is assumed to be delivered automatically into an AWS S3 bucket.
This repository starts **after data is already available in cloud storage**.

---

## High-level architecture

At a high level, the platform follows this flow:

1. **Raw data storage**
   - Data files arrive in an AWS S3 bucket

2. **Analytics warehouse**
   - Snowflake is the central analytical database
   - Two logical databases:
     - `DEV_DB` — development and experimentation
     - `PROD_DB` — production analytics
   - Three warehouses for workload isolation:
     - `DEV_WH` — development and testing
     - `PROD_WH` — scheduled production transformations
     - `BI_WH` — BI queries and dashboards (read-only)

3. **Transformations**
   - dbt is used to build analytics-ready models
   - dbt runs as an **ephemeral job**, not a long-lived service

4. **Orchestration**
   - Airflow acts as the orchestration layer
   - dbt jobs are triggered by Airflow using DockerOperator
   - dbt containers are started on demand and do not persist

5. **CI/CD**
   - GitHub Actions validates and executes dbt workflows
   - CI ensures consistency across environments

6. **Business Intelligence (planned)**
   - Metabase will be deployed in AWS
   - BI connects directly to `PROD_DB` using `BI_WH`

---

## Authentication and security model

The platform uses a **dual authentication model**.

### Human access
- Human users authenticate interactively using login/password
- Access is used for development, administration, and debugging
- Human credentials are never used by automated systems

### Service access
- All automated components use dedicated service accounts:
  - dbt
  - Airflow
  - CI/CD
  - BI
- Service accounts authenticate using RSA key-pair authentication
- No passwords are used for services
- Shared users and shared credentials are explicitly prohibited

Secrets are stored only in:
- GitHub Secrets (CI/CD)
- AWS Secrets Manager (cloud services)

Secrets are never committed to the repository.

---

## Docker Compose usage

Docker Compose is used as a **deployment and execution mechanism**, not as an architectural component.

- `docker-compose.yml`  
  Provides a lightweight dbt development environment (optional, dev-only)

- `docker-compose.airflow.yml`  
  Deploys the Airflow orchestration stack

In the current architecture:
- Airflow is the primary execution layer
- dbt runs as an ephemeral container job triggered by Airflow

---

## Repository structure
```
├── docker-compose.yml
├── docker-compose.airflow.yml
├── dbt/
│ ├── dbt_project.yml
│ └── models/
│ ├── staging/
│ ├── intermediate/
│ └── marts/
├── airflow/
│ ├── dags/
│ └── plugins/
├── .github/
│ └── workflows/
├── docs/
│ ├── 01_bootstrap.md
│ ├── 02_ci_cd.md
│ ├── 03_airflow.md
│ └── architecture.md
├── .env.example
├── README.md
└── SOURCE_OF_TRUTH.md
```
---
## Documentation and blog series

This repository is accompanied by a blog series that documents the platform step by step,
including architectural decisions, trade-offs, and evolution over time.

- Part 1 — Local bootstrap and initial design
- Part 2 — CI/CD and environment separation
- Part 3 — Introducing Airflow as orchestration layer

The blog explains **why** decisions were made.
The repository reflects **how the system currently works**.

---

## Source of truth

This repository is the single source of truth for the project.

Documentation and blog posts describe the evolution of the architecture.
The code reflects the latest and most complete state of the platform.




