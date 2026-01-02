/* THE ETL PROCESS
Refining raw strings into high-quality business data.
*/

CREATE OR REPLACE VIEW `portfolio_project.v_cleaned_retail_data` AS
WITH base_transformation AS (
  SELECT
    invoice_no,
    stock_code,
    description,
    -- Using SAFE_CAST to prevent errors if non-numeric characters exist
    SAFE_CAST(quantity AS INT64) AS quantity,
    -- Converting the string date to a real Timestamp
    PARSE_TIMESTAMP('%m/%d/%y %H:%M', invoice_date) AS invoice_timestamp,
    SAFE_CAST(unit_price AS FLOAT64) AS unit_price,
    customer_id,
    country
  FROM 
    `portfolio_project.raw_retail_data`
)

SELECT 
    *,
    -- Adding Business Logic: Total Revenue per line item
    ROUND(quantity * unit_price, 2) AS line_item_revenue,
    -- Extracting date parts for easier analysis later
    EXTRACT(DATE FROM invoice_timestamp) AS invoice_date,
    EXTRACT(MONTH FROM invoice_timestamp) AS invoice_month
FROM 
    base_transformation
WHERE 
    customer_id IS NOT NULL 
    AND quantity > 0 
    AND unit_price > 0;
