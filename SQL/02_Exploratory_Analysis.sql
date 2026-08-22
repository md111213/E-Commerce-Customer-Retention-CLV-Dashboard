-- First 10 rows
SELECT *
FROM orders
LIMIT 10;

-- Unique customers
SELECT COUNT(DISTINCT CustomerID) AS total_customers
FROM orders;

-- Unique invoices/orders
SELECT COUNT(DISTINCT InvoiceNo) AS total_orders
FROM orders;

-- Country
SELECT COUNT(DISTINCT Country) AS total_countries
FROM orders;

-- Data Range
SELECT
    MIN(InvoiceDate) AS first_date,
    MAX(InvoiceDate) AS last_date
FROM orders;

-- Missing CustomerID
SELECT
    COUNT(*) AS total_rows,
    SUM(
        CASE
            WHEN CustomerID IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_customer_id
FROM orders;
