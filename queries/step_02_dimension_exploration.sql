--===================================
-- EDA Step 2: Dimension Exploration
--===================================


----------------------------------------------------------
-- Task 4: Categories, Channels, and Segment Distribution
----------------------------------------------------------

-- Q4.1: How many customers fall into each segment (Athlete / Casual / Beginner)?
SELECT
	segment,
	COUNT(segment) AS customer_count
FROM customers
GROUP BY segment;
-- Q4.2: How many orders were placed through each channel, joined to get readable channel names instead of IDs?
SELECT
	c.channel_name,
	COUNT(o.order_id) AS orders_count
FROM orders AS o
LEFT JOIN channels AS c
	ON o.channel_id = c.channel_id
GROUP BY c.channel_name;

-----------------------------------------------
-- Task 5: Classify Customers Into Spend Tiers
-----------------------------------------------

-- Q5.1: What is each customer's total lifetime spend on completed orders?
SELECT
    customer_id,
	SUM(total_amount) AS lifetime_expenditure
FROM orders
WHERE order_status = 'completed'
GROUP BY customer_id;
-- Q5.2: Using that spend figure, label each customer as High Value (>10,000), Mid Value (5,000–10,000), or Low Value (<5,000).
WITH customer_spend AS (
	SELECT
		customer_id,
		SUM(total_amount) AS lifetime_expenditure
	FROM orders
	WHERE order_status = 'completed'
	GROUP BY customer_id
)
SELECT
	customer_id,
	lifetime_expenditure,
	CASE 
		WHEN lifetime_expenditure > 10000 THEN 'High Value'
		WHEN lifetime_expenditure BETWEEN 50000 AND 10000 THEN 'Mid Value'
		ELSE 'Low Value'
	END AS spend_tier
FROM customer_spend;
-- Q5.3: How many customers fall into each spend tier — does High Value skew toward the Athlete segment?
WITH customer_spend AS(
	SELECT
		customer_id,
		SUM(total_amount) AS lifetime_expenditure
	FROM orders
	WHERE order_status = 'completed'
	GROUP BY customer_id
),
tiered As (
	SELECT 
		cs.customer_id, 
		cs.lifetime_expenditure, 
		c.segment,
		CASE 
			WHEN cs.lifetime_expenditure > 10000 THEN 'High Value'
			WHEN cs.lifetime_expenditure BETWEEN 5000 AND 10000 THEN 'Mid Value'
			ELSE 'Low Value'
		END AS spend_tier
	FROM customer_spend AS cs
	JOIN customers AS c
	ON cs.customer_id = c.customer_id
)
SELECT
	spend_tier,
	segment,
	COUNT(*) as customer_count
FROM tiered
GROUP BY spend_tier, segment
ORDER BY spend_tier, segment;