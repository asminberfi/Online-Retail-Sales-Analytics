--Total sales and profit by region, category, sub-category
SELECT
    region,
    category,
    sub_category,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
FROM orders
GROUP BY region, category, sub_category
ORDER BY total_profit DESC;

--Monthly sales trends
SELECT
    DATE_TRUNC('month', order_date) AS month,
    ROUND(SUM(sales)::numeric, 2) AS monthly_sales,
    ROUND(SUM(profit)::numeric, 2) AS monthly_profit
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

--Consistently unprofitable sub-categories
SELECT
    sub_category,
	ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM orders
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

--Discount vs profit margin correlation
SELECT
    CORR(discount, profit_margin) AS discount_profit_correlation
FROM orders;

-- High-sales but negative-profit orders
SELECT
    order_id,
    product_name,
    sales,
    discount,
    profit
FROM orders
WHERE sales > 0 AND profit < 0
ORDER BY sales DESC

--Repeat vs one-time buyers
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM orders
    GROUP BY customer_id
)
SELECT
    CASE WHEN order_count = 1 THEN 'One-time buyer' ELSE 'Repeat buyer' END AS customer_type,
    COUNT(*) AS num_customers
FROM customer_orders
GROUP BY customer_type;

