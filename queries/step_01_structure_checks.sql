--==============================
-- EDA STEP 1: Structure Checks
--==============================


-----------------------------------
-- Task 1: How big is our dataset?
-----------------------------------

-- Q1.1: How many rows exist in each of the 5 tables?
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM channels;
SELECT COUNT(*) FROM date_dim;
-- Q1.2: How many orders fall under each order_status value?
SELECT 
	order_status,
	COUNT(order_status) AS status_count 
FROM orders
GROUP BY order_status;

-------------------------------------------
-- Task 2: NULL Detection and Data Quality
-------------------------------------------

-- Q2.1: How many orders are missing a delivery_date, and does that count match the number of pending + cancelled orders?
SELECT 
	COUNT(*) AS total_orders,
	COUNT(delivery_date) AS orders_with_delivery,
	COUNT(*) - COUNT(delivery_date) AS missing_delivery_count
FROM orders;
SELECT
	order_status,
	COUNT(*) AS cnt
FROM orders
WHERE delivery_date IS NULL
GROUP BY order_status;
-- Q2.2: Rewrite the delivery_date column so missing values display as 'Not Delivered' instead of NULL, for a clean operations report.
SELECT
	ISNULL(CONVERT(VARCHAR(20),delivery_date),'Not Delivered') AS delivery_status
FROM orders;
-- Q2.3: If a customer's region were ever missing, what query would return city as a fallback value instead of NULL?
SELECT
	customer_id,
	COALESCE(region, city) AS region_fallback
FROM customers;

----------------------------------------------------
-- Task 3: String Cleaning and Dimension Validation
----------------------------------------------------

-- Q3.1: Check if your category column has inconsistent casing and stray whitespace from manual data entry.
SELECT DISTINCT category from products;
SELECT DISTINCT
	TRIM(UPPER(category)) AS cleaned_category
FROM products;
-- Q3.2: Which city values have an unexpected character length, suggesting a trailing space or typo?
SELECT DISTINCT city,
       LEN(city) AS raw_length,
       LEN(TRIM(city)) AS trimmed_length
FROM customers
WHERE LEN(city) != LEN(TRIM(city));
-- Q3.3: Build a single readable label per customer combining full_name, city, and segment into one column for a sales contact sheet.
SELECT
	CONCAT_WS('-', full_name, city, segment) AS contact_label
FROM customers;
