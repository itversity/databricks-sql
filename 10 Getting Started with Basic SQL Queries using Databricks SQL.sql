SHOW DATABASES;

CREATE DATABASE IF NOT EXISTS retail;

CREATE TABLE IF NOT EXISTS retail.online_retail (
    value STRING
) STORED AS TEXTFILE
LOCATION 'dbfs:/databricks-datasets/online_retail/data-001';

DESCRIBE retail.online_retail;

SELECT * FROM retail.online_retail LIMIT 10;

DROP TABLE IF EXISTS retail.online_retail;

CREATE TABLE IF NOT EXISTS retail.online_retail
USING CSV
OPTIONS (
    path='dbfs:/databricks-datasets/online_retail/data-001',
    sep=',',
    header=True,
    inferSchema=True
);

DESCRIBE FORMATTED retail.online_retail;

SELECT * FROM retail.online_retail LIMIT 10;

DESCRIBE retail.online_retail;

SELECT count_if(InvoiceNo IS NOT NULL) AS InvoiceNoCount,
    count_if(StockCode IS NOT NULL) AS StockCodeCount,
    count_if(Description IS NOT NULL) AS DescriptionCount,
    count_if(Quantity IS NOT NULL) AS QuantityCount,
    count_if(InvoiceDate IS NOT NULL) AS InvoiceDateCount,
    count_if(UnitPrice IS NOT NULL) AS UnitPriceCount,
    count_if(CustomerID IS NOT NULL) AS CustomerIDCount,
    count_if(Country IS NOT NULL) AS CountryCount
FROM retail.online_retail;

WITH cte AS (
    SELECT 515 AS MaleCount, 480 AS FemaleCount, 5 AS TransgenderCount
) SELECT 
    stack(
            3,
            'Male', MaleCount,
            'Female', FemaleCount,
            'Transgender', TransgenderCount
        ) AS (Gender, GenderCount)
    FROM cte;
    

SELECT count_if(InvoiceNo IS NOT NULL) AS InvoiceNoCount,
    count_if(StockCode IS NOT NULL) AS StockCodeCount,
    count_if(Description IS NOT NULL) AS DescriptionCount,
    count_if(Quantity IS NOT NULL) AS QuantityCount,
    count_if(InvoiceDate IS NOT NULL) AS InvoiceDateCount,
    count_if(UnitPrice IS NOT NULL) AS UnitPriceCount,
    count_if(CustomerID IS NOT NULL) AS CustomerIDCount,
    count_if(Country IS NOT NULL) AS CountryCount
FROM retail.online_retail;

SELECT stack(
    8, 
    'InvoiceNo', count_if(InvoiceNo IS NOT NULL),
    'StockCode', count_if(StockCode IS NOT NULL),
    'Description', count_if(Description IS NOT NULL),
    'Quantity', count_if(Quantity IS NOT NULL),
    'InvoiceDate', count_if(InvoiceDate IS NOT NULL),
    'UnitPrice', count_if(UnitPrice IS NOT NULL),
    'CustomerID', count_if(CustomerID IS NOT NULL),
    'Country', count_if(Country IS NOT NULL)
) AS (Column, NotNullCount)
FROM retail.online_retail;

SELECT count(DISTINCT InvoiceNo, StockCode, CustomerID) AS DistinctCount, 
    count(*) AS TotalCount
FROM retail.online_retail LIMIT 10;

-- Create View with distinct records of retail.online_retail
CREATE OR REPLACE VIEW retail.online_retail_v
AS
SELECT DISTINCT * FROM retail.online_retail;

SELECT count(*) FROM retail.online_retail_v;
SELECT count(*) FROM retail.online_retail;

SELECT * FROM retail.online_retail_v LIMIT 10;

-- Structure of Basic SQL
/* SELECT
FROM
    JOIN
WHERE
GROUP BY
    HAVING
ORDER BY */ 
SELECT * -- Replace * with specific columns
FROM retail.online_retail_v; -- Running query against view with unique records

SELECT * /* Replace * with specific columns */ FROM retail.online_retail_v LIMIT 10;

DESCRIBE retail.online_retail_v;

SELECT *
FROM retail.online_retail_v
WHERE InvoiceNo = 536365;
