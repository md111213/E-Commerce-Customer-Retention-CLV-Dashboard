 -- Purchase frequency
 SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS purchase_frequency
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY purchase_frequency DESC;
 
 -- Average purchase value
 SELECT
    CustomerID,
    SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo) AS avg_purchase_value
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY avg_purchase_value DESC;

-- Customer value
SELECT
    CustomerID,
    SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo)
        AS avg_purchase_value,
    COUNT(DISTINCT InvoiceNo) AS purchase_frequency,

    (SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo))
        * COUNT(DISTINCT InvoiceNo) AS customer_value

FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY customer_value DESC;

 -- Customer lifetime estimate
 SELECT
    CustomerID,
    DATEDIFF(
        MAX(InvoiceDate),
        MIN(InvoiceDate)
    ) AS customer_lifetime_days
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY customer_lifetime_days DESC;

 -- CLV calculation
 WITH customer_metrics AS (
    SELECT
        CustomerID,
        SUM(Quantity * UnitPrice) AS total_revenue,
        COUNT(DISTINCT InvoiceNo) AS purchase_frequency,
        DATEDIFF(
            MAX(InvoiceDate),
            MIN(InvoiceDate)
        ) AS lifetime_days
    FROM orders
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT
    CustomerID,
    total_revenue,
    purchase_frequency,
    lifetime_days,

    total_revenue /
        NULLIF(purchase_frequency, 0) AS avg_purchase_value,

    CASE
        WHEN lifetime_days > 0
        THEN
            (total_revenue / lifetime_days) * 365
        ELSE total_revenue
    END AS estimated_annual_clv

FROM customer_metrics
ORDER BY estimated_annual_clv DESC;
 
-- High-value customers identify
WITH customer_metrics AS (
    SELECT
        CustomerID,
        SUM(Quantity * UnitPrice) AS total_revenue,
        COUNT(DISTINCT InvoiceNo) AS purchase_frequency,
        DATEDIFF(
            MAX(InvoiceDate),
            MIN(InvoiceDate)
        ) AS lifetime_days
    FROM orders
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT
    CustomerID,
    total_revenue,
    purchase_frequency,
    lifetime_days,

    CASE
        WHEN lifetime_days > 0
        THEN (total_revenue / lifetime_days) * 365
        ELSE total_revenue
    END AS estimated_annual_clv

FROM customer_metrics
ORDER BY estimated_annual_clv DESC
LIMIT 10;
