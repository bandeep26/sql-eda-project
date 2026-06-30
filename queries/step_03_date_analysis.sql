--===========================
-- EDA Step 3: Date Analysis
--===========================

-----------------------------------------
-- Task 6: Date Range and Coverage Check
-----------------------------------------

-- Q6.1: What are the earliest and latest order dates in the dataset?
SELECT
	MIN(order_date) as earliest_order,
	MAX(order_date) as latest_order
FROM orders;
-- Q6.2: How many total months does the order data span?
SELECT
	DATEDIFF(Month,MIN(order_date),MAX(order_date)) AS Month_span
FROM orders;
-- Q6.3: Pull the year and month separately from order_date without joining to date_dim — confirm it matches what date_dim says.
SELECT
	DATEPART(Month, order_date) AS order_month,
	DATEPART(Year, order_date) AS order_year
FROM orders;

---------------------------------------------------------------
-- Task 7: Task 7 — Monthly Seasonality and MoM Revenue Growth
---------------------------------------------------------------

-- Q7.1: What is total revenue per calendar month, joined against date_dim and ordered by month_num?
SELECT
	d.month_num,
	d.month_name,
	SUM(o.total_amount) AS monthly_revenue
FROM orders AS o
LEFT JOIN date_dim AS d
ON o.order_date = d.date_key
WHERE o.order_status = 'completed'
GROUP BY d.month_num, d.month_name
ORDER BY d.month_num;
-- Q7.2: What is the month-over-month revenue change in absolute INR terms?
WITH mom_revenue AS
(
SELECT
	d.month_num,
	d.month_name,
	SUM(o.total_amount) AS monthly_revenue
FROM orders AS o
LEFT JOIN date_dim AS d
ON o.order_date = d.date_key
WHERE o.order_status = 'completed'
GROUP BY d.month_num, d.month_name
)
SELECT 
	month_num, 
	month_name, 
	monthly_revenue,
    LAG(monthly_revenue, 1) OVER (ORDER BY month_num) AS previous_month_revenue,
    monthly_revenue - LAG(monthly_revenue, 1) OVER (ORDER BY month_num) AS mom_change
FROM mom_revenue;
-- Q7.3: What is the MoM revenue change as a percentage — and do January and May-June actually spike as expected?
WITH mom_revenue AS
(
SELECT
	d.month_num,
	d.month_name,
	SUM(o.total_amount) AS monthly_revenue
FROM orders AS o
LEFT JOIN date_dim AS d
ON o.order_date = d.date_key
WHERE o.order_status = 'completed'
GROUP BY d.month_num, d.month_name
)
SELECT 
	month_num,
	month_name,
	monthly_revenue,
    ROUND(
      (monthly_revenue - LAG(monthly_revenue,1) OVER (ORDER BY month_num)) * 100.0
	  / LAG(monthly_revenue,1) OVER (ORDER BY month_num)	 
     , 2) AS mom_pct_change
FROM mom_revenue;

