/* RFM SCORING
Ranking customers from 1-5 based on their behavior.
*/

CREATE OR REPLACE TABLE `portfolio_project.customer_rfm_scores` AS
SELECT
    *,
    -- We want LOW recency to have a HIGH score (5 = most recent)
    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    -- We want HIGH frequency to have a HIGH score (5 = most frequent)
    NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
    -- We want HIGH monetary to have a HIGH score (5 = highest spend)
    NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
FROM
    `portfolio_project.customer_rfm_summary`;
