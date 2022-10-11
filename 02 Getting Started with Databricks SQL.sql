-- Setup Retail Database

CREATE DATABASE IF NOT EXISTS retail_db;

CREATE TABLE IF NOT EXISTS retail_db.orders (
    order_id INT,
    order_date STRING,
    order_customer_id INT,
    order_status STRING
);

CREATE TABLE IF NOT EXISTS retail_db.order_items (
    order_item_id INT,
    order_item_order_id INT,
    order_item_product_id INT,
    order_item_quantity INT,
    order_item_subtotal FLOAT,
    order_item_product_price FLOAT
);

-- review retail database

DESCRIBE FORMATTED retail_db.orders;

DESCRIBE FORMATTED retail_db.order_items;

-- Step 1: Configure Databricks CLI
-- Step 2: Use Databricks CLI to push data to Databricks Platform
-- Step 3: Use Databricks Platform to load data into retail_db tables
-- Step 4: Review the data using SQL Editor of Databricks SQL Platform

-- validate retail database tables.

SELECT count(*) FROM retail_db.orders;

SELECT count(*) FROM retail_db.order_items;

SELECT * FROM retail_db.orders LIMIT 10;

SELECT * FROM retail_db.order_items LIMIT 10;

SELECT count(distinct(order_id)) FROM retail_db.orders;

SELECT count(distinct(order_item_id)) FROM retail_db.order_items;

-- Overview of external tables

CREATE EXTERNAL TABLE IF NOT EXISTS retail_db.orders_external (
    order_id INT,
    order_date STRING,
    order_customer_id INT,
    order_status STRING
) USING CSV
LOCATION 'dbfs:/public/retail_db/orders';

DESCRIBE FORMATTED retail_db.orders_external;

SELECT * FROM retail_db.orders_external LIMIT 10;

SELECT count(*) FROM retail_db.orders_external;
