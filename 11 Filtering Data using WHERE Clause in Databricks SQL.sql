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

SELECT current_date; -- yyyy-MM-dd

SELECT current_timestamp; -- yyyy-MM-dd HH:mm:ss.SSS

SELECT DISTINCT SPLIT(InvoiceDate, ' ')[0] AS InvoiceDate -- M/d/yy H:mm
FROM retail.online_retail_v 
ORDER BY 1
LIMIT 100;

-- year, month, date_format

SELECT year('2011-01-10');

SELECT to_date('12/1/10 11:45', 'M/d/yy H:mm');
SELECT to_timestamp('12/31/10 11:45', 'M/d/yy H:mm');


SELECT DISTINCT to_date(InvoiceDate, 'M/d/yy H:mm') AS InvoiceDate,
    to_timestamp(InvoiceDate, 'M/d/yy H:mm') AS InvoiceTime
FROM retail.online_retail_v;

-- Get number of invoices placed on 2011 January 10th
SELECT COUNT(DISTINCT InvoiceNo)
FROM retail.online_retail_v
WHERE InvoiceDate LIKE '1/10/11%';

SELECT COUNT(DISTINCT InvoiceNo)
FROM retail.online_retail_v
WHERE SPLIT(InvoiceDate, ' ')[0] = '1/10/11';

SELECT COUNT(DISTINCT InvoiceNo)
FROM retail.online_retail_v
WHERE to_date(InvoiceDate, 'M/d/yy H:mm') = '2011-01-10';

SELECT * FROM retail.online_retail_v LIMIT 10;

-- OR, AND
SELECT *
FROM retail.online_retail_v
WHERE to_date(InvoiceDate, 'M/d/yy H:mm') = '2011-01-10' 
    AND CustomerID = 16303;
    
SELECT *
FROM retail.online_retail_v
WHERE to_date(InvoiceDate, 'M/d/yy H:mm') = '2011-01-10' 
    OR CustomerID = 16303;
    
-- Get number of invoices placed between 2011 January 10th and 2011 January 15th
SELECT COUNT(DISTINCT InvoiceNo)
FROM retail.online_retail_v
WHERE SPLIT(InvoiceDate, ' ')[0] >= '1/10/11'
    AND SPLIT(InvoiceDate, ' ')[0] <= '1/15/11';
    
SELECT COUNT(DISTINCT InvoiceNo)
FROM retail.online_retail_v
WHERE to_date(InvoiceDate, 'M/d/yy H:mm') >= '2011-01-10'
    AND to_date(InvoiceDate, 'M/d/yy H:mm') <= '2011-01-15';
    
SELECT COUNT(DISTINCT InvoiceNo)
FROM retail.online_retail_v
WHERE SPLIT(InvoiceDate, ' ')[0] >= '1/5/11'
    AND SPLIT(InvoiceDate, ' ')[0] <= '1/15/11';
    
SELECT COUNT(DISTINCT InvoiceNo)
FROM retail.online_retail_v
WHERE to_date(InvoiceDate, 'M/d/yy H:mm') >= '2011-01-05'
    AND to_date(InvoiceDate, 'M/d/yy H:mm') <= '2011-01-15';
    
-- Using BETWEEN Operator
SELECT COUNT(DISTINCT InvoiceNo)
FROM retail.online_retail_v
WHERE to_date(InvoiceDate, 'M/d/yy H:mm') >= '2011-01-05'
    AND to_date(InvoiceDate, 'M/d/yy H:mm') <= '2011-01-15';
    
SELECT COUNT(DISTINCT InvoiceNo)
FROM retail.online_retail_v
WHERE to_date(InvoiceDate, 'M/d/yy H:mm') BETWEEN '2011-01-05' AND '2011-01-15';

-- Get mix, max and distinct count with respect to quantity
SELECT min(Quantity) AS MinQuantity,
    max(Quantity) AS MaxQuantity,
    count(distinct Quantity) AS QuantityDistinctCount
FROM retail.online_retail_v LIMIT 10;

SELECT count(*)
FROM retail.online_retail_v
WHERE Quantity BETWEEN 10 AND 30;

SELECT count(*)
FROM retail.online_retail_v
WHERE Quantity >= 10 
    AND Quantity <= 30;
    
-- Dealing with Nulls
SELECT 'foo' = 'foo';

SELECT 'foo' IS NOT NULL;

SELECT NULL IS NOT NULL;

SELECT * FROM retail.online_retail_v LIMIT 10;

-- Get count of invoice items where invoice number is null
SELECT count(*)
FROM retail.online_retail_v
WHERE InvoiceNo IS NULL;

-- Get number of invoices where customer id is null
SELECT count(distinct InvoiceNo)
FROM retail.online_retail_v
WHERE CustomerID IS NULL;

-- Get number of invoices where customer id is not null
SELECT count(distinct InvoiceNo)
FROM retail.online_retail_v
WHERE CustomerID IS NOT NULL;

SELECT DISTINCT InvoiceNo
FROM retail.online_retail_v
ORDER BY 1
LIMIT 10;

-- 536365, 536370, 536374
SELECT *
FROM retail.online_retail_v
WHERE InvoiceNo = '536365'
    OR InvoiceNo = '536370'
    OR InvoiceNo = '536374'
ORDER BY 1;

SELECT *
FROM retail.online_retail_v
WHERE InvoiceNo IN ('536365', '536370', '536374')
ORDER BY 1;

-- Get number of invoices which are not related to weekend days
SELECT date_format(current_date, 'EEEE');

SELECT DISTINCT InvoiceNo, 
    InvoiceDate, 
    date_format(to_date(InvoiceDate, 'M/d/yy H:mm'), 'EEEE') AS InvoiceDayName
FROM retail.online_retail_v
ORDER BY 1
LIMIT 10;

SELECT count(distinct InvoiceNo)
FROM retail.online_retail_v
WHERE date_format(to_date(InvoiceDate, 'M/d/yy H:mm'), 'EEEE') NOT IN ('Saturday', 'Sunday');

SELECT count(distinct InvoiceNo)
FROM retail.online_retail_v;
