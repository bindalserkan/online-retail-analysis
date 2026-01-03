/* CALCULATING CUSTOMER VITAL SIGNS (RFM)
Goal: Summarize behavior for every unique customer.
*/

CREATE OR REPLACE TABLE `portfolio_project.customer_rfm_summary`
AS
SELECT
  customer_id,
  country,
  -- Days since last purchase (relative to the current date of the data)
  DATE_DIFF("2011-12-10", MAX(invoice_date), DAY) AS recency,
  -- Number of unique invoices
  COUNT(DISTINCT invoice_no) AS frequency,
  -- Total spend per customer
  ROUND(SUM(line_item_revenue), 2) AS monetary
FROM `pelagic-script-483116-m4.portfolio_project.v_cleaned_retail_data`
GROUP BY 1, 2;
