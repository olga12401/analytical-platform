# Analytical-platform

## PHASE 1 — Build DEV Environment

Build a local analytical platform where:

```
CSV files
 → Airflow (orchestration)
 → dbt (transformations)
 → PostgreSQL (DEV warehouse)
 → Metabase (engineer validation)
```

## Prerequisites
```
Docker + Docker Compose
Python 3.9+
pip install dbt-postgres
```



```
                    ┌────────────────────┐
                    │   GitHub Actions   │
                    │  dbt CI (DEV only)│
                    └─────────┬──────────┘
                              │
                              ▼
┌──────────────┐     ┌──────────────────┐
│ Source Data  │ --> │ Snowflake DEV    │
│ (CSV / S3)   │     │ RAW/STG/INT/MART │
└──────────────┘     └──────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │ Snowflake PROD   │
                    │ RAW/STG/INT/MART │
                    └─────────┬────────┘
                              │
                ┌─────────────┴─────────────┐
                │                           │
        ┌──────────────┐          ┌────────────────┐
        │ Apache       │          │ Metabase       │
        │ Airflow      │          │ (AWS ECS)      │
        │ (prod runs)  │          │ read-only      │
        └──────────────┘          └────────────────┘

```
## High-level build order

1. Snowflake  → foundation
2. dbt        → transformations
3. GitHub CI  → safety gate
4. Airflow    → production execution
5. Metabase   → consumption
6. Docs       → explain everything


## GitHub Actions (dbt CI)

This repository uses GitHub Actions to run Continuous Integration (CI) checks for dbt projects against Snowflake.
The CI pipeline ensures that dbt models and tests are validated before changes are merged into the `main` branch.

Authentication to Snowflake is performed using key-pair authentication (private key + passphrase).

---

### Workflows

- `.github/workflows/dbt-ci.yml` — Development (DEV) dbt CI pipeline

---

### Triggers

The DEV CI pipeline runs on:
- `push` to the `developing` branch
- `pull_request` targeting the `main` branch

Development workflow: developing → push → CI checks → pull request → main

### CI Pipeline Steps

The dbt CI workflow performs the following steps:

1. Checkout repository code using `actions/checkout`
2. Set up Python runtime
3. Install `dbt-snowflake`
4. Write the Snowflake private key from GitHub Secrets into a temporary file on the runner
5. Dynamically generate `profiles.yml` from GitHub Secrets
6. Execute:
   - `dbt debug`
   - `dbt run`
   - `dbt test`

---

### Secrets Management (DEV)

Secrets are stored in: Repository → Settings → Secrets and variables → Actions

Required secrets for the DEV environment:

- `SNOWFLAKE_ACCOUNT`
- `SNOWFLAKE_DBT_DEV_USER`
- `SNOWFLAKE_DBT_DEV_ROLE`
- `SNOWFLAKE_DEV_DATABASE`
- `SNOWFLAKE_DEV_WAREHOUSE`
- `SNOWFLAKE_DEV_SCHEMA`
- `SNOWFLAKE_DBT_DEV_PRIVATE_KEY`
- `SNOWFLAKE_DBT_DEV_PRIVATE_KEY_PASSPHRASE`

---

### Security Model

- Snowflake private keys are **never committed** to the repository.
- During CI execution, the private key is written to a temporary file on the GitHub-hosted runner.
- The runner environment is ephemeral; all files are destroyed after the job completes.
- dbt requires an absolute path for `private_key_path`, which is explicitly configured in CI.

---

### Common Failure Modes

- **Profile name mismatch**:  
  The `profile` value in `dbt_project.yml` must match the top-level profile key in `profiles.yml`.

- **Missing or misnamed secrets**:  
  Any missing secret resolves to `None` and causes profile validation to fail.

- **Invalid key path**:  
  dbt does not expand `~` in paths; absolute paths must be used.

---

### Status

The DEV dbt CI pipeline is active and validated via successful merges into the `main` branch.