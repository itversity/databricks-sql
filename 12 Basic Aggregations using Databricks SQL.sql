SHOW DATABASES;

CREATE DATABASE IF NOT EXISTS retail;

CREATE TABLE IF NOT EXISTS retail.online_retail (
    value STRING
) STORED AS TEXTFILE
LOCATION 'dbfs:/databricks-datasets/online_retail/data-001';

CREATE OR REPLACE VIEW retail.online_retail_v
AS
SELECT DISTINCT * FROM retail.online_retail;

SELECT * FROM retail.online_retail_v;

SELECT * 
FROM retail.online_retail_v
WHERE InvoiceNo = '540646';

SELECT orv.InvoiceNo, orv.Quantity, orv.UnitPrice, orv.CustomerId,
    orv.Quantity * orv.UnitPrice AS InvoiceItemAmount
FROM retail.online_retail_v AS orv
WHERE InvoiceNo = '540646';

-- Query to get invoice amoiunt for InvoiceNo 540646
SELECT sum(orv.Quantity * orv.UnitPrice) AS InvoiceAmount
FROM retail.online_retail_v AS orv
WHERE InvoiceNo = '540646';

SELECT orv.InvoiceNo, orv.InvoiceDate, orv.CustomerID,
    sum(orv.Quantity * orv.UnitPrice) AS InvoiceAmount
FROM retail.online_retail_v AS orv
WHERE InvoiceNo = '540646'
GROUP BY orv.InvoiceNo, orv.InvoiceDate, orv.CustomerID;

SELECT DISTINCT InvoiceNo
FROM retail.online_retail_v
ORDER BY 1
LIMIT 10;

SELECT orv.InvoiceNo, orv.InvoiceDate, orv.CustomerID,
    sum(orv.Quantity * orv.UnitPrice) AS InvoiceAmount
FROM retail.online_retail_v AS orv
WHERE InvoiceNo IN ('540646', '536365', '536370', '536374')
GROUP BY orv.InvoiceNo, orv.InvoiceDate, orv.CustomerID;

-- Query Syntax
/*
SELECT
FROM
WHERE
GROUP BY
    HAVING
ORDER BY
*/

-- Get revenue for each customer where data is sorted in descending order by the customer revenue
SELECT CustomerID,
    sum(Quantity * UnitPrice) AS CustomerInvoiceAmount
FROM retail.online_retail_v
GROUP BY CustomerID
ORDER BY 2 DESC;

SELECT CustomerID,
    sum(Quantity * UnitPrice) AS CustomerInvoiceAmount,
    count(distinct InvoiceNo) AS DistinctInvoiceCount
FROM retail.online_retail_v
GROUP BY CustomerID
ORDER BY 2 DESC;

-- Order of Query Execution
/*
FROM - 1
WHERE - 2
GROUP BY  - 3a
    HAVING
SELECT  - 3b
ORDER BY - 4
*/

SELECT * FROM (
    SELECT CustomerID,
        sum(Quantity * UnitPrice) AS CustomerInvoiceAmount,
        count(distinct InvoiceNo) AS DistinctInvoiceCount
    FROM retail.online_retail_v
    GROUP BY CustomerID
) WHERE DistinctInvoiceCount >= 10
ORDER BY 2 DESC;

SELECT CustomerID,
    sum(Quantity * UnitPrice) AS CustomerInvoiceAmount,
    count(distinct InvoiceNo) AS DistinctInvoiceCount
FROM retail.online_retail_v
GROUP BY CustomerID
    HAVING DistinctInvoiceCount >= 10 AND CustomerInvoiceAmount >= 20000
ORDER BY 2 DESC;

-- Daily Revenue
SELECT * FROM retail.online_retail_v LIMIT 10; -- M/d/yy H:mm -> yyyy-MM-dd

SELECT to_date(InvoiceDate, 'M/d/yy H:mm') 
FROM retail.online_retail_v 
LIMIT 10;

SELECT to_date(InvoiceDate, 'M/d/yy H:mm') AS InvoiceDate,
    sum(Quantity * UnitPrice) AS DailyInvoiceAmount
FROM retail.online_retail_v
GROUP BY 1
ORDER BY 1;

-- Get Daily Revenue and Distinct Invoice Count for each day where customer id is null
SELECT to_date(InvoiceDate, 'M/d/yy H:mm') AS InvoiceDate,
    sum(Quantity * UnitPrice) AS DailyInvoiceAmount,
    count(distinct InvoiceNo) AS DailyInvoiceCount
FROM retail.online_retail_v
WHERE CustomerID IS NULL
GROUP BY 1
ORDER BY 1;

SELECT to_date(InvoiceDate, 'M/d/yy H:mm') AS InvoiceDate,
    sum(Quantity * UnitPrice) AS DailyInvoiceAmount,
    count(distinct InvoiceNo) AS DailyInvoiceCount
FROM retail.online_retail_v
WHERE CustomerID IS NULL
GROUP BY 1
    HAVING DailyInvoiceAmount >= 10000
ORDER BY 1;
