 -- Recency calculate
   SELECT
    CustomerID,
    DATEDIFF(
        (SELECT MAX(InvoiceDate) FROM orders),
        MAX(InvoiceDate)
    ) AS recency
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY recency;
   
 -- Frequency calculate
 SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS frequency
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY frequency DESC;
 
 -- Monetary calculate
 SELECT
    CustomerID,
    SUM(Quantity * UnitPrice) AS monetary
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY monetary DESC;
 
 -- RFM scores
 WITH rfm AS (
    SELECT
        CustomerID,
        DATEDIFF(
            (SELECT MAX(InvoiceDate) FROM orders),
            MAX(InvoiceDate)
        ) AS recency,
        COUNT(DISTINCT InvoiceNo) AS frequency,
        SUM(Quantity * UnitPrice) AS monetary
    FROM orders
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT
    CustomerID,
    recency,
    frequency,
    monetary,

    NTILE(5) OVER (ORDER BY recency DESC) AS R_score,
    NTILE(5) OVER (ORDER BY frequency) AS F_score,
    NTILE(5) OVER (ORDER BY monetary) AS M_score

FROM rfm;
 
 -- Customer segmentation
 WITH rfm AS (
    SELECT
        CustomerID,
        DATEDIFF(
            (SELECT MAX(InvoiceDate) FROM orders),
            MAX(InvoiceDate)
        ) AS recency,
        COUNT(DISTINCT InvoiceNo) AS frequency,
        SUM(Quantity * UnitPrice) AS monetary
    FROM orders
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),

rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS R_score,
        NTILE(5) OVER (ORDER BY frequency) AS F_score,
        NTILE(5) OVER (ORDER BY monetary) AS M_score
    FROM rfm
)

SELECT
    *,
    CASE
        WHEN R_score >= 4 AND F_score >= 4 AND M_score >= 4
            THEN 'Champions'

        WHEN R_score >= 3 AND F_score >= 4
            THEN 'Loyal Customers'

        WHEN R_score <= 2 AND F_score >= 3
            THEN 'At Risk'

        WHEN R_score <= 2 AND F_score <= 2 AND M_score <= 2
            THEN 'Low Value'

        ELSE 'Others'
    END AS customer_segment

FROM rfm_scores;
