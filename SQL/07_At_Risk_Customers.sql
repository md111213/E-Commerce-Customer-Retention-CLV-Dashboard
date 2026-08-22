-- Last purchase date
SELECT
    CustomerID,
    MAX(InvoiceDate) AS last_purchase_date
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY last_purchase_date;

 -- Days since last purchase
 SELECT
    CustomerID,
    MAX(InvoiceDate) AS last_purchase_date,
    DATEDIFF(
        (SELECT MAX(InvoiceDate) FROM orders),
        MAX(InvoiceDate)
    ) AS days_since_last_purchase
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY days_since_last_purchase DESC;
 
 -- Purchase frequency
 SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS purchase_frequency
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY purchase_frequency DESC;
 
-- Customer value
SELECT
    CustomerID,
    SUM(Quantity * UnitPrice) AS customer_value
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY customer_value DESC;

 -- At-risk customer identification
 SELECT
    CustomerID,
    MAX(InvoiceDate) AS last_purchase_date,
    DATEDIFF(
        (SELECT MAX(InvoiceDate) FROM orders),
        MAX(InvoiceDate)
    ) AS days_since_last_purchase,
    COUNT(DISTINCT InvoiceNo) AS purchase_frequency,
    SUM(Quantity * UnitPrice) AS customer_value
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
HAVING days_since_last_purchase >= 60
ORDER BY days_since_last_purchase DESC;
 
 -- High-value at-risk customers
 SELECT
    CustomerID,
    MAX(InvoiceDate) AS last_purchase_date,

    DATEDIFF(
        (SELECT MAX(InvoiceDate) FROM orders),
        MAX(InvoiceDate)
    ) AS days_since_last_purchase,

    COUNT(DISTINCT InvoiceNo) AS purchase_frequency,

    SUM(Quantity * UnitPrice) AS customer_value

FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID

HAVING
    days_since_last_purchase >= 60
    AND customer_value >= 1000

ORDER BY customer_value DESC;

SELECT *
FROM orders;

SELECT DATABASE();
SHOW DATABASES;
 

