--===============================
-- EDA Step 4: Measures and KPIs
--===============================

---------------------------------------
-- Task 8A: Headline KPIs in One Query
---------------------------------------
-- Q8A.1: What is total revenue across completed orders only?
SELECT
	SUM(total_amount) AS total_revenue
FROM orders
WHERE order_status = 'completed';
-- Q8A.2: What is the Average Order Value (AOV), rounded to 2 decimals?
SELECT
	ROUND(AVG(total_amount),2) AS AOV
FROM orders
WHERE order_status = 'completed';
-- Q8A.3: How many unique customers placed at least one completed order?
SELECT 
	COUNT(DISTINCT(customer_id)) AS unique_buyers
FROM orders
WHERE order_status = 'completed';


-------------------------------------------
-- Task 8B: HAVING: Identify Repeat Buyers
-------------------------------------------
-- Q8B.1  Which customers have placed more than 3 completed orders?
SELECT
	customer_id,
	COUNT(order_id) AS order_count
FROM orders
WHERE order_status = 'completed'
GROUP BY customer_id
HAVING COUNT(order_id) > 3;
-- Q8B.2: Of those repeat buyers, which ones also have lifetime spend above the High Value threshold from Task 5?
WITH repeat_buyers AS
(
SELECT
	customer_id,
	COUNT(order_id) AS order_count
FROM orders
WHERE order_status = 'completed'
GROUP BY customer_id
HAVING COUNT(order_id) > 3
),
customer_spend AS (
	SELECT
		customer_id,
		SUM(total_amount) AS lifetime_expenditure
	FROM orders
	WHERE order_status = 'completed'
	GROUP BY customer_id
)
SELECT 
	rb.customer_id, 
	rb.order_count, 
	cs.lifetime_expenditure
FROM repeat_buyers AS rb
JOIN customer_spend AS cs 
	ON rb.customer_id = cs.customer_id
WHERE cs.lifetime_expenditure > 10000;


