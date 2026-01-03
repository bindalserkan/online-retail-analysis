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

**Solution:** I implemented a *Manual Schema Definition*, using the following `json`:

[`Create Manual Schema`](json/create_manual_schema.json)

Importing all fields as `STRING` types provided a "safe" landing zone for the data, allowing for controlled transformation using SQL rather than letting the database reject the file.

### The Cleaning Pipeline

I developed a SQL view to modularize the cleaning process:

[`Data Cleaning`](sql/01_create_view.sql)

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

## 🏗 Phase 2: The Analytical Deep Dive

### Summarizing Customer Behaviour

I created a new SQL table to find answers to the following questions:

- **Recency(R):** How many days ago was a customer's last purchase?
- **Frequency(F):** How many unique orders did a customer place?
- **Monetary(M):** What is the total revenue a customer generated?

By calculating these three numbers, I made an "**RFM Summary**" so that we can tell "*These are our champions who bought often and recently*" or "*We are losing those who haven't bought for a while*"

[`RFM Summary`](sql/02_rfm_summary.sql)

### The RFM Scoring

We have the raw numbers (Recency, Frequency, Monetary), but from a business perspective, it is better to see where the "Risk" is. 

I used a window function, `NTILE` which splits the customers into 5 equal groups.

- A recency score of 5 is "Very Recent"
- A frequency score of 5 is "Very Loyal"
- A monetary score of 5 is "Big Spender"

[`RFM Scoring`](sql/02_rfm_scoring.sql) 

### Final Customer Segmentation

Since we graded customers according to their behaviours, it is time to give them "Human" labels. 
Here I created another SQL table to segment the customers:

[`Customer Segments`](sql/04_final_segment.sql)

### Analysis Results

| Customer Segment | Number |
| :--- | :--- |
| **Big Spenders at Risk** | 341 |
| **Champions** | 973 |
| **Loyal Customers** | 983 |
| **Lost/Hibernating** | 1015 |
| **Regular Customers** | 1034 |
 
