DROP DATABASE retail_db CASCADE;

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

SELECT count(*) FROM retail_db.orders;
COPY INTO retail_db.orders
FROM (
    SELECT order_id::int order_id, order_date::string order_date, 
        order_customer_id::int order_customer_id, order_status::string order_status
    FROM 'dbfs:/public/retail_db/orders'
)
FILEFORMAT = JSON;

SELECT count(*) FROM retail_db.orders;
SELECT * FROM retail_db.orders LIMIT 10;

COPY INTO retail_db.order_items
FROM (
    SELECT order_item_id::int order_item_id, order_item_order_id::int order_item_order_id, 
        order_item_product_id::int order_item_product_id, order_item_quantity::int order_item_quantity,
        order_item_subtotal::float order_item_subtotal, order_item_product_price::float order_item_product_price
    FROM 'dbfs:/public/retail_db/order_items'
)
FILEFORMAT = JSON;
