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

**Solution:** I implemented a *Manual Schema Definition*, importing all fields as `STRING` types. This provided a "safe" landing zone for the data, allowing for controlled transformation using SQL rather than letting the database reject the file.

### The Cleaning Pipeline

I developed a SQL view to modularize the cleaning process. Key transformations included:

- **Data Type Casting:** Used `SAFE_CAST` to convert strings to `INT64` and `FLOAT64`, ensuring the query wouldn't fail on "dirty" entries.
- **Timestamp Parsing:** Converted string dates into proper `TIMESTAMP` objects to enable time-series analysis.
- **Business Logic Filtering:** Excluded records with missing `CustomerID` and non-positive `Quantity` or `UnitPrice` to focus the analysis on successful gross sales.

```sql
/* THE ETL PROCESS
Refining raw strings into high-quality business data.
*/

CREATE OR REPLACE VIEW `portfolio_project.v_cleaned_retail_data` AS
WITH base_transformation AS (
  SELECT
    InvoiceNo,
    StockCode,
    Description,
    -- Using SAFE_CAST to prevent errors if non-numeric characters exist
    SAFE_CAST(Quantity AS INT64) AS Quantity,
    -- Converting the string date to a real Timestamp
    PARSE_TIMESTAMP('%m/%d/%Y %H:%M', InvoiceDate) AS invoice_timestamp,
    SAFE_CAST(UnitPrice AS FLOAT64) AS UnitPrice,
    CustomerID,
    Country
  FROM 
    `portfolio_project.raw_retail_data`
)

SELECT 
    *,
    -- Adding Business Logic: Total Revenue per line item
    ROUND(Quantity * UnitPrice, 2) AS line_item_revenue,
    -- Extracting date parts for easier analysis later
    EXTRACT(DATE FROM invoice_timestamp) AS invoice_date,
    EXTRACT(MONTH FROM invoice_timestamp) AS invoice_month
FROM 
    base_transformation
WHERE 
    CustomerID IS NOT NULL 
    AND Quantity > 0 
    AND UnitPrice > 0;
```
### Data Audit Results

By filtering out "clutter" (canceled orders and anonymous transactions), I ensured the integrity of the downstream analysis.

| Metric | Value |
| :--- | :--- |
| **Raw Records** | 541.909 |
| **Cleaned Records** | 397.884 |
| **Data Noise Removed** | ~26% |






 
