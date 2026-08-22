-- Total customers
 SELECT
    COUNT(DISTINCT CustomerID) AS total_customers
FROM orders
WHERE CustomerID IS NOT NULL;

 -- Orders per customer
 SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_orders DESC;

 -- Revenue per customer
 SELECT
    CustomerID,
    SUM(Quantity * UnitPrice) AS total_revenue
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_revenue DESC;

 -- Average order value/customer
 SELECT
    CustomerID,
    SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo) AS avg_order_value
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY avg_order_value DESC;

 -- Top customers
 SELECT
    CustomerID,
    SUM(Quantity * UnitPrice) AS total_revenue
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_revenue DESC
LIMIT 10;

 -- Customer purchase frequency   
 SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS purchase_frequency
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY purchase_frequency DESC;
