SELECT * FROM retail.sales;

SELECT `Sale Date`, `Course`,
    sum(`Sale Amount`) AS `Sale Amount`,
    count(*) AS `Sale Count`
FROM retail.sales
GROUP BY 1, 2 WITH ROLLUP;

WITH sales_rollup AS (
    SELECT `Sale Date`, `Course`,
        sum(`Sale Amount`) AS `Sale Amount`,
        count(*) AS `Sale Count`
    FROM retail.sales
    GROUP BY 1, 2 WITH ROLLUP
) SELECT * FROM sales_rollup WHERE `Sale Date` IS NULL;

SELECT `Sale Date`,
    sum(`Sale Amount`) AS `Sale Amount`,
    count(*) AS `Sale Count`
FROM retail.sales
GROUP BY 1 WITH ROLLUP
ORDER BY 1;

SELECT `Sale Date`,
    sum(`Sale Amount`) AS `Sale Amount`,
    count(*) AS `Sale Count`
FROM retail.sales
GROUP BY 1 WITH CUBE
ORDER BY 1;

SELECT `Sale Date`, `Course`,
    sum(`Sale Amount`) AS `Sale Amount`,
    count(*) AS `Sale Count`
FROM retail.sales
GROUP BY 1, 2 WITH CUBE;

WITH sales_cube AS (
    SELECT `Sale Date`, `Course`,
        sum(`Sale Amount`) AS `Sale Amount`,
        count(*) AS `Sale Count`
    FROM retail.sales
    GROUP BY 1, 2 WITH CUBE
) SELECT * FROM sales_cube WHERE `Sale Date` IS NULL AND `Course` IS NOT NULL
ORDER BY 1, 2;

SELECT * FROM retail.online_retail_v;

-- yyyy-MM, yyyy-MM-dd, Count
-- InvoiceMonth, InvoiceDate, InvoiceCount

-- M/d/yy H:mm -> yyyy-MM-dd
SELECT DISTINCT date_format(to_date(InvoiceDate, 'M/d/yy H:mm'), 'yyyy-MM') AS InvoiceMonth, 
    to_date(InvoiceDate, 'M/d/yy H:mm') AS InvoiceDate 
FROM retail.online_retail_v;

SELECT date_format(to_date(InvoiceDate, 'M/d/yy H:mm'), 'yyyy-MM') AS InvoiceMonth, 
    to_date(InvoiceDate, 'M/d/yy H:mm') AS InvoiceDate,
    count(distinct InvoiceNo) AS InvoiceCount
FROM retail.online_retail_v
GROUP BY 1, 2 WITH ROLLUP
ORDER BY 1, 2;
