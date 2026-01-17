-- Identify the date gap to set a proper time for RFM Analysis
SELECT MAX(invoice_date) AS max_date, MIN(invoice_date) AS min_date
FROM online_retail;
-- The max date is 2011-12-09 and the min date is 2010-12-01. 
-- Conduct the RFM as if the current date is 2011-12-10

WITH rfm_table AS (
    SELECT
        *
    FROM
        online_retail
    WHERE
        invoice_cancelled IS FALSE
        AND unit_price_0 IS FALSE
        AND is_adjustment IS FALSE
        AND customer_id <> 'Guest'
),
customer_rfm AS (
    SELECT
        customer_id,
        country,                              
        '2011-12-09'::date - MAX(invoice_date) AS recency, 
        COUNT(DISTINCT invoice_no) AS frequency,          
        SUM(quantity * unit_price) AS monetary            
    FROM
        rfm_table
    WHERE
        customer_id IS NOT NULL
        AND customer_id <> 'Guest'
        AND quantity > 0
    GROUP BY
        customer_id,
        country                                
),
rfm_scores AS (
    SELECT
        customer_id,
        country,                               
        recency,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM
        customer_rfm
),
rfm_segments AS (
    SELECT
        *,
        CONCAT(r_score, f_score, m_score) AS rfm_score,
        CASE       
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
            WHEN r_score = 1 AND (f_score >= 4 OR m_score >= 4) THEN 'Cannot Lose Them'
            WHEN f_score >= 4 AND r_score >= 2 THEN 'Loyal Customers'
            WHEN r_score >= 4 AND f_score <= 2 THEN 'New Customers'
            WHEN r_score >= 4 AND f_score = 3 THEN 'Potential Loyalists'
            WHEN r_score = 3 AND f_score >= 2 THEN 'Promising'
            WHEN r_score = 3 AND f_score = 1 THEN 'Needs Attention'
            WHEN r_score = 2 THEN 'At Risk'
            WHEN r_score = 1 AND f_score >= 2 AND f_score <= 3 THEN 'Hibernating'
            WHEN r_score = 1 AND f_score = 1 THEN 'Lost'
            ELSE 'Unclassified'
        END AS customer_segment
    FROM
        rfm_scores
)
SELECT * FROM rfm_segments;

