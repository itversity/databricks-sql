
# Step 1 

pip3 install databricks-cli

databricks -v
databricks configure -h

# step 2 
databricks configure --token

e.g. 
https://adb-*****************.azuredatabricks.net

# token id
********************0510d3-3


# step 3 - connectivity checks 
databricks fs ls 

# step 4 - create a directory in databricks
databricks fs mkdirs dbfs:/public

# step 5 - copy the data from local system to databricks using CLI

databricks fs cp /Users/data/Documents/DATABRICKS/ITVERSITY/databricks-sql-main/data/cards  dbfs:/public/cards --recursive
databricks fs cp /Users/data/Documents/DATABRICKS/ITVERSITY/databricks-sql-main/data/course_catalog  dbfs:/public/course_catalog --recursive
databricks fs cp /Users/data/Documents/DATABRICKS/ITVERSITY/databricks-sql-main/data/electionresults  dbfs:/public/electionresults --recursive
databricks fs cp /Users/data/Documents/DATABRICKS/ITVERSITY/databricks-sql-main/data/hr  dbfs:/public/hr --recursive
databricks fs cp /Users/data/Documents/DATABRICKS/ITVERSITY/databricks-sql-main/data/hr_db  dbfs:/public/hr_db --recursive
databricks fs cp /Users/data/Documents/DATABRICKS/ITVERSITY/databricks-sql-main/data/lca  dbfs:/public/lca --recursive
databricks fs cp /Users/data/Documents/DATABRICKS/ITVERSITY/databricks-sql-main/data/nyse  dbfs:/public/nyse --recursive
databricks fs cp /Users/data/Documents/DATABRICKS/ITVERSITY/databricks-sql-main/data/nyse_all  dbfs:/public/nyse_all --recursive
databricks fs cp /Users/data/Documents/DATABRICKS/ITVERSITY/databricks-sql-main/data/retail_db  dbfs:/public/retail_db --recursive
databricks fs cp /Users/data/Documents/DATABRICKS/ITVERSITY/databricks-sql-main/data/sales  dbfs:/public/sales --recursive

# step 6 - validate the data from CLI
databricks fs ls dbfs:/public

cards
course_catalog
electionresults
hr
hr_db
lca
nyse
nyse_all
retail_db
retail_db_json
sales

# cards
databricks fs ls dbfs:/public/cards

# course_catalog
databricks fs ls dbfs:/public/course_catalog

# electionresults
databricks fs ls dbfs:/public/electionresults

# hr
databricks fs ls dbfs:/public/hr

# hr_db

databricks fs ls dbfs:/public/hr_db

countries
departments
emp_details_view
employees
job_history
jobs
locations
regions

databricks fs ls dbfs:/public/hr_db/countries
databricks fs ls dbfs:/public/hr_db/departments
databricks fs ls dbfs:/public/hr_db/emp_details_view
databricks fs ls dbfs:/public/hr_db/employees
databricks fs ls dbfs:/public/hr_db/job_history
databricks fs ls dbfs:/public/hr_db/jobs
databricks fs ls dbfs:/public/hr_db/locations
databricks fs ls dbfs:/public/hr_db/regions

# lca
databricks fs ls dbfs:/public/lca

# nyse
databricks fs ls dbfs:/public/nyse

# nyse_all
databricks fs ls dbfs:/public/nyse_all

nyse_data 
nyse_stocks

# nyse_data
databricks fs ls dbfs:/public/nyse_all/nyse_data

# nyse_stocks
databricks fs ls dbfs:/public/nyse_all/nyse_stocks

# retail_db
databricks fs ls dbfs:/public/retail_db

categories
customers
departments
order_items
orders
products

# categories
databricks fs ls dbfs:/public/retail_db/categories

# customers
databricks fs ls dbfs:/public/retail_db/customers

# departments
databricks fs ls dbfs:/public/retail_db/departments

# order_items
databricks fs ls dbfs:/public/retail_db/order_items

# orders
databricks fs ls dbfs:/public/retail_db/orders

# products
databricks fs ls dbfs:/public/retail_db/products

# retail_db_json
databricks fs ls dbfs:/public/retail_db_json 

categories
customers
departments
order_items
orders
products

# categories
databricks fs ls dbfs:/public/retail_db_json/categories

# customers
databricks fs ls dbfs:/public/retail_db_json/customers

# departments
databricks fs ls dbfs:/public/retail_db_json/departments

# order_items
databricks fs ls dbfs:/public/retail_db_json/order_items

# orders
databricks fs ls dbfs:/public/retail_db_json/orders

# products
databricks fs ls dbfs:/public/retail_db_json/products

# sales
databricks fs ls dbfs:/public/sales
