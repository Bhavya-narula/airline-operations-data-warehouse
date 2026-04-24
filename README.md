# Airline Operations Data Warehouse

An end-to-end data warehousing and analytics project built on a public airline operations dataset (~98,600 flight records). The project covers dimensional modelling, a full Python ETL pipeline, a PostgreSQL star schema, seven business queries, Tableau dashboards, and association rule mining using the Apriori algorithm.

---

## Project Overview

Flight disruptions — delays and cancellations — impose significant operational and reputational costs on airlines and airports. This project builds an analytical data warehouse to explore patterns in flight performance across time, geography, and passenger demographics, producing insights relevant to airline operators, airport managers, and civil aviation policymakers.

**Key questions answered:**
- Which countries and airports generate the most flight activity?
- How does flight volume vary by month, and when are disruption rates highest?
- Which airports have the worst delay and cancellation performance?
- Do passenger demographics or geography predict flight outcomes?

---

## Tech Stack

| Layer | Tools |
|---|---|
| Data Processing & ETL | Python (pandas) |
| Data Warehouse | PostgreSQL |
| Analytics & Visualisation | Tableau, SQL |
| Machine Learning | Python (mlxtend — Apriori algorithm) |
| Version Control | Git / GitHub |

---

## Repository Structure

```
airline-operations-data-warehouse/
│
├── ETL_CLEANING.ipynb        # Full ETL pipeline — cleaning, transformation, dimension/fact table creation
├── DATA_MINING.ipynb         # Association rule mining using Apriori algorithm
├── queries.sql               # 7 business queries executed against the PostgreSQL warehouse
│
├── dim_date.csv              # Date dimension table
├── dim_location.csv          # Location dimension table (airport → country → continent)
├── dim_passenger.csv         # Passenger dimension table
├── dim_flight.csv            # Flight status dimension table
│
├── tableau_visualisations.pdf  # All 7 Tableau dashboard outputs
└── README.md
```

---

## Data Warehouse Design

The warehouse follows **Kimball's four-step dimensional modelling methodology**, implemented as a **star schema** in PostgreSQL.

### Schema

A central fact table (`fact_flight`) connects to four dimension tables:

| Dimension | Table | Hierarchy |
|---|---|---|
| Date | `dim_date` | Day → Month → Quarter → Year |
| Location | `dim_location` | Airport → Country → Continent |
| Passenger | `dim_passenger` | Nationality → Age Group / Gender |
| Flight | `dim_flight` | Flight Status (On Time / Delayed / Cancelled) |

The fact table stores one row per passenger flight event, with measures for `flight_count`, `delay_flag`, and `cancel_flag`.

A **star schema** was chosen over snowflake for three reasons: fewer joins for OLAP-style aggregations, simpler Tableau connectivity, and negligible storage overhead given dataset size.

---

## ETL Pipeline

Implemented entirely in Python using pandas (`ETL_CLEANING.ipynb`):

- **Extract** — loaded raw CSV (~100k rows) into a DataFrame
- **Clean** — removed duplicates, standardised text casing, filtered invalid age values, dropped a corrupted arrival airport column (source ETL error — contained departure IATA code instead)
- **Transform** — derived `Age_Group`, `is_weekend`, `delay_flag`, `cancel_flag`, and full date hierarchy attributes
- **Load** — built dimension and fact tables, exported to CSV for PostgreSQL ingestion via psycopg2

---

## Business Queries & Key Findings

Seven SQL queries were run against the warehouse and visualised in Tableau. See `queries.sql` and `tableau_visualisations.pdf` for full detail.

| Query | Finding |
|---|---|
| Q1 — Country demand | US dominates at 41.7% of all flight events; Australia 2nd at 12% |
| Q2 — Monthly trends | Peak in July–August (Northern Hemisphere summer); trough in February |
| Q3 — Weekend vs weekday | Near-uniform distribution (~14% per day) — reflects synthetic dataset characteristics |
| Q4 — Airport delay rate | Santa Rosa Airport leads at 57.1% delay rate (filter: >25 flights) |
| Q5 — Passenger demographics | Gender-balanced across all age groups; Adults (18–59) are the largest segment |
| Q6 — Nationality analysis | Chinese passengers account for 31.8% of records, followed by Indonesian (18.4%) |
| Q7 — Cancellation rate | Kiunga Airport (Papua New Guinea) leads at 52% cancellation rate |

---

## Association Rule Mining

Implemented using the **Apriori algorithm** (`DATA_MINING.ipynb`) on four categorical attributes: Age Group, Continent, Weekend Indicator, and Flight Status.

**Parameters:** min support = 0.5%, min confidence = 30%, rules filtered to Flight Status as sole consequent.

**Top 5 rules (ranked by lift):**

| Antecedent | Consequent | Confidence | Lift |
|---|---|---|---|
| Europe + Young passengers | Delayed | 34.9% | 1.049 |
| South America + Weekend | Cancelled | 34.9% | 1.044 |
| South America + Adult passengers | Cancelled | 34.7% | 1.038 |
| Europe + Weekend | On Time | 34.4% | 1.033 |
| Oceania + Weekend | On Time | 34.3% | 1.030 |

All lift values hover near 1.0 — a direct consequence of the dataset's near-uniform flight status distribution (~33% each for On Time, Delayed, Cancelled), which constrains the algorithm's ability to surface strong predictive rules. When all outcomes are approximately equally probable, no antecedent combination can strongly predict any single outcome. The consistent South America cancellation signal appearing across two independent rules is the most robust finding, and warrants further investigation with richer operational data.

---

## Dataset

**Source:** [Airline Dataset (Updated v2) — Kaggle](https://www.kaggle.com/datasets/iamsouravbanerjee/airline-dataset)

This is a publicly available synthetic dataset. Findings are used to demonstrate data warehouse design and analytical methodology rather than to draw real-world operational conclusions.

---

## Author

**Bhavya Narula**
Data Science & Business Analytics — University of Western Australia
[LinkedIn](https://linkedin.com/in/bhavya-narula1) · [GitHub](https://github.com/Bhavya-narula)

