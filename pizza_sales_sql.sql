# Pizza Sales

DROP DATABASE IF EXISTS pizza_db;

CREATE DATABASE pizza_db;

USE pizza_db;

# We will import the data from the pizza_sales.csv file into a single table

SELECT * FROM pizza_sales;

# We need to change some datatypes

ALTER TABLE pizza_sales
MODIFY COLUMN pizza_id 			INT,
MODIFY COLUMN order_id 			INT,
MODIFY COLUMN pizza_name_id 	VARCHAR(50),
MODIFY COLUMN quantity 			TINYINT,
#MODIFY COLUMN order_date 		DATE,
MODIFY COLUMN order_time 		TIME,
MODIFY COLUMN unit_price 		FLOAT,
MODIFY COLUMN total_price 		FLOAT,
MODIFY COLUMN pizza_size 		VARCHAR(50),
MODIFY COLUMN pizza_category 	VARCHAR(50),
MODIFY COLUMN pizza_ingredients VARCHAR(200),
MODIFY COLUMN pizza_name 		VARCHAR(50);

# To get the DATE data type from text of the order_date column

ALTER TABLE pizza_sales
CHANGE COLUMN order_date order_date_txt TEXT,
ADD COLUMN order_date DATE AFTER quantity;

UPDATE pizza_sales SET order_date = STR_TO_DATE(order_date_txt, '%d-%m-%Y');

ALTER TABLE pizza_sales DROP COLUMN order_date_txt;

SELECT * FROM pizza_sales;

################################################################
# KPI's Queries

# 1. Total Revenue

SELECT ROUND(SUM(total_price), 2) AS total_revenue FROM pizza_sales;

# 2. Average Order Value

SELECT ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) AS avg_order_value FROM pizza_sales;

# 3. Total Pizzas Sold

SELECT SUM(quantity) AS total_pizzas_sold FROM pizza_sales;

# 4. Total Orders

SELECT COUNT(DISTINCT order_id) AS total_orders FROM pizza_sales;

# 5. Average Pizzas per Order

SELECT ROUND(SUM(quantity) / COUNT(DISTINCT order_id), 2) AS avg_pizzas_per_order FROM pizza_sales;

################################################################
# Charts Queries

# 1. Hourly Trend for Total Pizzas Sold

SELECT
	HOUR(order_time) AS order_hours,
	SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY order_hours
ORDER BY order_hours;

# 2. Weekly Trend for Total Orders

SELECT
	YEAR(order_date) AS year,
    WEEKOFYEAR(order_date) AS week_num,
	COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY year, week_num
ORDER BY year, week_num;

# 3. Percentage of Sales by Pizza Category

SELECT
	pizza_category,
    ROUND(SUM(total_price), 2) AS total_revenue,
	ROUND(SUM(total_price) * 100 
		/ (SELECT SUM(total_price) FROM pizza_sales), 2) AS pct_total_revenue
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_revenue DESC;

# 4. Percentage of Sales by Pizza Size

SELECT
	pizza_size,
    ROUND(SUM(total_price), 2) AS total_revenue,
	ROUND(SUM(total_price) * 100 
		/ (SELECT SUM(total_price) FROM pizza_sales), 2) AS pct_total_revenue
FROM pizza_sales
GROUP BY pizza_size
ORDER BY total_revenue DESC;

# 5. Total Pizzas Sold by Pizza Category

SELECT
	pizza_category,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_pizzas_sold DESC;

# 6a. Top 5 Best Sellers by Revenue

SELECT
	pizza_name,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue DESC
LIMIT 5;

# 6b. Top 5 Best Sellers by Total Quantity

SELECT
	pizza_name,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_pizzas_sold DESC
LIMIT 5;

# 6c. Top 5 Best Sellers by Total Orders

SELECT
	pizza_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders DESC
LIMIT 5;

# 7a. Bottom 5 Best Sellers by Revenue, Total Quantity and Total Orders

SELECT
	pizza_name,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue
LIMIT 5;

# 7b. Bottom 5 Best Sellers by Total Quantity

SELECT
	pizza_name,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_pizzas_sold
LIMIT 5;

# 7c. Bottom 5 Best Sellers by Total Orders

SELECT
	pizza_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders
LIMIT 5;

# Applying filters with a WHERE clause

SELECT
	pizza_name,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
WHERE
	MONTH(order_date) IN (4, 5)
    AND pizza_category = 'Chicken'
GROUP BY pizza_name
ORDER BY total_pizzas_sold DESC
LIMIT 5;

# Done