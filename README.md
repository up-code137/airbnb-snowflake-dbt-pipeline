# Airbnb Data Engineering Pipeline | AWS S3 + dbt + Snowflake

A hands-on end-to-end Data Engineering project built to learn and implement modern data engineering concepts using **Snowflake**, **dbt** and **AWS S3**. This project processes Airbnb listings, bookings and hosts data through a Medallion Architecture — Bronze → Silver → Gold — implementing incremental loading, SCD Type 2 snapshots, custom macros and Jinja templating.

---

## What I Learned Building This

- How to connect AWS S3 as an external stage to Snowflake
- How dbt manages transformations across Bronze, Silver and Gold layers
- How incremental models work — loading only new/changed records
- How SCD Type 2 snapshots track historical changes with valid_from and valid_to
- How to write custom macros and use Jinja templating in SQL
- How ephemeral models work as CTEs — no physical table created
- How One Big Table (OBT) is built using Jinja loops dynamically
- How dbt tests validate data quality automatically

---

## Architecture

```
CSV Files → AWS S3 → Snowflake Staging → Bronze → Silver → Gold
                                              ↓          ↓        ↓
                                         Raw Data   Cleaned   Analytics Ready
```

---

## Tech Stack

| Tool | Purpose |
|---|---|
| AWS S3 | Raw data storage — source files |
| Snowflake | Cloud data warehouse |
| dbt | Data transformation layer |
| Python | Environment setup |
| Git + GitHub | Version control |

---

## Data Model — Medallion Architecture

### Bronze Layer — Raw Data
Ingested directly from Snowflake staging with minimal transformation:
- `bronze_bookings` — raw booking transactions
- `bronze_hosts` — raw host information
- `bronze_listings` — raw property listings

### Silver Layer — Cleaned Data
Validated, standardized and enriched data:
- `silver_bookings` — validated booking records
- `silver_hosts` — enhanced host profiles with quality metrics
- `silver_listings` — standardized listings with price categorization

### Gold Layer — Analytics Ready
Business ready datasets:
- `obt` — One Big Table joining bookings, listings and hosts using Jinja loop
- `fact` — Fact table for dimensional modeling
- Ephemeral models as intermediate CTEs

### Snapshots — SCD Type 2
Historical tracking for all dimension tables:
- `dim_bookings` — booking changes over time
- `dim_hosts` — host profile changes over time
- `dim_listings` — listing changes over time

---

## Key Concepts Implemented

**Incremental Loading:**
```sql
{{ config(materialized='incremental') }}
{% if is_incremental() %}
    WHERE CREATED_AT > (SELECT COALESCE(MAX(CREATED_AT), '1900-01-01') FROM {{ this }})
{% endif %}
```
Only new or changed records are processed — no full reload every time.

**Custom Macros:**
- `tag()` — categorizes price into low, medium, high
- `trimmer()` — string cleaning utility
- `multiply()` — math operations
- `generate_schema_name()` — dynamic schema naming per layer

**One Big Table with Jinja Loop:**
Dynamic SQL generation using Jinja — no hardcoded column lists. Config dictionary drives which columns come from which table.

**SCD Type 2 Snapshots:**
Full history maintained with `dbt_valid_from`, `dbt_valid_to` and `dbt_is_current` columns.

---

## Project Structure

```
AWS_SNOWFLAKE_DBT/
├── SourceData/
│   ├── bookings.csv
│   ├── hosts.csv
│   └── listings.csv
├── DDL/
│   ├── ddl.sql
│   └── resources.sql
└── aws_dbt_snowflake_project/
    ├── models/
    │   ├── bronze/
    │   ├── silver/
    │   └── gold/
    ├── snapshots/
    ├── macros/
    ├── tests/
    └── dbt_project.yml
```

---

## Setup Instructions

**1. Clone the repo:**
```bash
git clone https://github.com/up-code137/AWS_SNOWFLAKE_DBT.git
cd AWS_SNOWFLAKE_DBT
```

**2. Create virtual environment:**
```bash
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install dbt-core dbt-snowflake
```

**3. Configure Snowflake connection in `~/.dbt/profiles.yml`:**
```yaml
aws_dbt_snowflake_project:
  outputs:
    dev:
      type: snowflake
      account: <your-account>
      user: <your-username>
      password: <your-password>
      database: AIRBNB
      schema: dbt_schema
      warehouse: COMPUTE_WH
      role: ACCOUNTADMIN
      threads: 4
  target: dev
```

**4. Run DDL scripts in Snowflake** to create staging tables.

**5. Load CSVs** from `SourceData/` to Snowflake staging schema.

**6. Run dbt:**
```bash
dbt debug          # test connection
dbt deps           # install packages
dbt run            # run all models
dbt test           # run data quality tests
dbt snapshot       # run SCD Type 2 snapshots
dbt docs generate  # generate documentation
dbt docs serve     # view lineage in browser
```

---

## Run Specific Layers

```bash
dbt run --select bronze.*    # Bronze only
dbt run --select silver.*    # Silver only
dbt run --select gold.*      # Gold only
dbt run --full-refresh       # Full reload
```

---

## Coming Soon
- Power BI dashboard connected to Snowflake Gold tables
- CI/CD pipeline integration

---

## Author

**Sameer Sinha**
- GitHub: [up-code137](https://github.com/up-code137)
- LinkedIn: [sameersinha-de](https://linkedin.com/in/sameersinha-de)
- Email: sameersinha137@gmail.com
- Startup: [PhonePlus+](https://phoneplus.in)

---

*Built as a hands-on learning project to understand modern data engineering with Snowflake, dbt and AWS S3.*
