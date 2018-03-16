-- Obtain the distribution of customers for FanJoy
-- Columns:
-- 1. Order count
-- 2. Number of customers
-- 3. Sales per bucket

SELECT top 10 *
FROM fld_team10

-- FanJoy
SELECT orders_count
  , COUNT(DISTINCT id) AS num_customers
  , SUM(count(DISTINCT ID)) OVER (ORDER BY orders_count ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_cust
  , SUM(total_spent) AS total_sales
  , SUM(SUM(total_spent)) OVER (ORDER BY orders_count ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_sales
FROM fanjoy_customers_data
GROUP BY orders_count
  HAVING orders_count > 1
ORDER BY orders_count;


-- Team 10 customers
SELECT orders_count
  , COUNT(id) AS num_customers
  , SUM(count(ID)) OVER (ORDER BY orders_count ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_cust
  , SUM(total_spent) AS total_sales
  , SUM(SUM(total_spent)) OVER (ORDER BY orders_count ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_sales
FROM fcd_team10
GROUP BY orders_count
HAVING orders_count > 0
ORDER BY orders_count;


SELECT SUM(fod_team10.total_price_usd) as "Total price"
  , SUM(fod_team10.total_discounts) as "total discounts"
  , SUM(fod_team10.total_price_usd) - SUM(fod_team10.total_discounts) as "total billed"
FROM fod_team10;
-- 23M total sales


SELECT SUM(total_price_usd)
FROM fanjoy_orders_data;
-- 37.6M total sales
