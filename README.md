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


