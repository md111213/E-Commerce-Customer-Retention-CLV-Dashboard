--  Repeat customers
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) >= 2
ORDER BY total_orders DESC;

 -- One-time customers
 SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) = 1;

-- Repeat purchase rate
 WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS total_orders
    FROM orders
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT
    COUNT(CASE WHEN total_orders >= 2 THEN 1 END) AS repeat_customers,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(CASE WHEN total_orders >= 2 THEN 1 END) * 100.0
        / COUNT(*),
        2
    ) AS repeat_purchase_rate
FROM customer_orders;

-- Customer retention rate
 WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS total_orders
    FROM orders
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT
    ROUND(
        COUNT(CASE WHEN total_orders >= 2 THEN 1 END) * 100.0
        / COUNT(*),
        2
    ) AS customer_retention_rate
FROM customer_orders;

-- Customer repeat behavior
 SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    CASE
        WHEN COUNT(DISTINCT InvoiceNo) = 1
            THEN 'One-Time Customer'
        WHEN COUNT(DISTINCT InvoiceNo) BETWEEN 2 AND 4
            THEN 'Repeat Customer'
        WHEN COUNT(DISTINCT InvoiceNo) >= 5
            THEN 'Frequent Customer'
    END AS customer_behavior
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_orders DESC;

