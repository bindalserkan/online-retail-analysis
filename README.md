# Online Retail Analysis: From Raw Telemetry to Business Insight

## 📌 Project Overview 

This project transforms a messy, real-world retail dataset into a structured analytical environment. Leveraging *SQL* and *BigQuery*, I performed a full **ETL (Extract, Transform, Load)** process to clean over 500k rows of transactional data, followed by an **RFM (Recency, Frequency, Monetary)** analysis to segment customers and drive strategic business value.

## 🛠 Tech Stack

- **Database:** Google BigQuery (SQL)
- **Data Source:** Online Retail II (via Kaggle)
- **Concepts:** Schema Mapping, ETL, Data Cleaning, CTEs (Common Table Expressions), Data Validation, Window Functions, Customer Segmentation

## 🏗 Phase 1: ETL & Data Integrity

### Data Ingestion Challenge

Initial upload attempt using "Auto-detect schema" failed due to inconsistencies in the raw CSV.

- **Solution:** I implemented a **Manual Schema Definition** (loading all fields as `STRING`). This provided a stable "landing zone," allowing for programmatic cleaning via SQL.

🔗[`View Schema Definition`](json/create_manual_schema.json)

Importing all fields as `STRING` types provided a "safe" landing zone for the data, allowing for controlled transformation using SQL rather than letting the database reject the file.

### The Cleaning Pipeline

I developed a modular SQL view to standardize the data.

Key transformations included:

- **Data Type Casting:** Leveraged `SAFE_CAST` to handle non-numeric noise.
- **Timestamp Parsing:** Converted string dates into proper `TIMESTAMP` objects to enable time-series analysis.
- **Business Logic Filtering:** Excluded records with missing `CustomerID` and non-positive `Quantity` or `UnitPrice` to focus the analysis on successful gross sales.

🔗[`View Transformation Query`](sql/01_create_view.sql)

### Data Audit Results

By filtering out "clutter" (canceled orders and anonymous transactions), I ensured the integrity of the downstream analysis.

| Metric | Value |
| :--- | :--- |
| **Raw Records** | 541.909 |
| **Cleaned Records** | 397.884 |
| **Data Noise Removed** | ~26% |

## 📊 Phase 2: Customer Intelligence (RFM Analysis)

### Summarizing Customer Behaviour

To move beyond basic reporting, I implemented an RFM Model to categorize customers based on their behavior. Creating a SQL table, I found answers to the following questions that build our RFM summary:

- **Recency(R):** How many days ago was a customer's last purchase?
- **Frequency(F):** How many unique orders did a customer place?
- **Monetary(M):** What is the total revenue a customer generated?
  
🔗[`View RFM Summarization Query`](sql/02_rfm_summary.sql)

### The RFM Scoring

We have the raw numbers (Recency, Frequency, Monetary), but from a business perspective, it is better to see where the "Risk" is. 

<img src="predictive_segments.png" alt="Predictive Segments" width="500" height="400">

Using the SQL `NTILE` window function, I assigned a score of 1–5 for each metric.

🔗[`View RFM Scoring Query`](sql/02_rfm_scoring.sql) 

### Customer Segmentation

I then applied a `CASE` statement to categorize customers into strategic segments.

| Customer Segment | Count | Strategic Action |
| :--- | :---: | :--- |
| **Champions** |973| Reward and use for referral programs |
| **Loyal Customers** |983| Upsell premium products |
| **Regular Customers** |1034| Marketing engagement standard |
| **Big Spenders at Risk** |341| Immediate re-engagement discount needed |
| **Lost/Hibernating** |1015| Low-cost automated win-back campaign |
 
🔗[`View Customer Segmentation Query`](sql/04_final_segment.sql)
