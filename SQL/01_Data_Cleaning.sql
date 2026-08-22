-- missing values
SELECT
    COUNT(*) AS total_rows,
    SUM(InvoiceNo IS NULL) AS null_invoice,
    SUM(StockCode IS NULL) AS null_stockcode,
    SUM(Description IS NULL) AS null_description,
    SUM(Quantity IS NULL) AS null_quantity,
    SUM(InvoiceDate IS NULL) AS null_invoice_date,
    SUM(UnitPrice IS NULL) AS null_unit_price,
    SUM(CustomerID IS NULL) AS null_customer_id,
    SUM(Country IS NULL) AS null_country
FROM orders;

-- Duplicate check

SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country
HAVING COUNT(*) > 1
LIMIT 20;

-- Invalid data

SELECT
    InvoiceNo,
    StockCode,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY InvoiceNo, StockCode
HAVING COUNT(*) > 1;
