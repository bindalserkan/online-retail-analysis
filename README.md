# Online Retail Analysis: From Raw Telemetry to Business Insight

## 📌 Project Overview 

This project transforms a messy, real-world retail dataset into a structured analytical environment. Leveraging *SQL* and *BigQuery*, I performed a full *ETL (Extract, Transform, Load)* process to clean over 500k rows of transactional data, preparing it for high-level business intelligence and customer segmentation.

## 🛠 Tech Stack

- **Database:** Google BigQuery (SQL)
- **Data Source:** UCI Machine Learning Repository (Online Retail II) - Sourced via Kaggle
- **Concepts:** Data Cleaning, Schema Mapping, CTEs (Common Table Expressions), Data Validation.

## 🏗 Phase 1: ETL & Data Integrity

### Data Ingestion Challenge

Initial upload attempt using "Auto-detect schema" failed due to inconsistencies in the raw CSV (eg, non-numeric characters in numeric fields).

**Solution:** I implemented a *Manual Schema Definition*, using the following `json` definition:

[`create_manual_schema.json`](json)

Importing all fields as `STRING` types provided a "safe" landing zone for the data, allowing for controlled transformation using SQL rather than letting the database reject the file.

### The Cleaning Pipeline

I developed a SQL view to modularize the cleaning process:

[`01_create_view.sql`](sql)

Key transformations included:

- **Data Type Casting:** Used `SAFE_CAST` to convert strings to `INT64` and `FLOAT64`, ensuring the query wouldn't fail on "dirty" entries.
- **Timestamp Parsing:** Converted string dates into proper `TIMESTAMP` objects to enable time-series analysis.
- **Business Logic Filtering:** Excluded records with missing `CustomerID` and non-positive `Quantity` or `UnitPrice` to focus the analysis on successful gross sales.

### Data Audit Results

By filtering out "clutter" (canceled orders and anonymous transactions), I ensured the integrity of the downstream analysis.

| Metric | Value |
| :--- | :--- |
| **Raw Records** | 541.909 |
| **Cleaned Records** | 397.884 |
| **Data Noise Removed** | ~26% |






 
