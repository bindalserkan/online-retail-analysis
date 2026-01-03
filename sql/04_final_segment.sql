/* CREATING FINAL CUSTOMER SEGMENTATION
  NOW, THE CUSTOMERS HAVE HUMAN LABELS RATHER THAN JUST SCORES
*/
CREATE OR REPLACE TABLE `portfolio_project.final_customer_segments` AS
SELECT
    *,
    (r_score + f_score + m_score) AS total_rfm_score,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score <= 2 AND m_score >= 4 THEN 'Big Spenders at Risk'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost/Hibernating'
        ELSE 'Regular Customers'
    END AS customer_segment
FROM
    `portfolio_project.customer_rfm_scores`;
