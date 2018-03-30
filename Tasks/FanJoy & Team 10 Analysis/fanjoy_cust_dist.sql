-- Create a distribution of FanJoy and Team10, which groups by order count and describes:
-- 1. Customers
-- 2. Total Spent
-- 3. Total Orders
-- 4. % of total customers = {1} / sum{1}
-- 5. % of total spent = {2} / sum{2}
-- 6. % of total orders = {3} / sum{3}
-- 7. Average order size = {2} / {3}



-- First, pull all the individual data necessary before filtering.
SELECT
  customer_id,
  count(distinct order_number) as total_orders,
  sum(total_price_usd) as total_spent
FROM fanjoy_orders_data
GROUP BY customer_id
ORDER BY 3 DESC -- some orders have $0 spent
limit 15;


-- FanJoy Distribution, fixed
CREATE VIEW kevin_ip.dist_fanjoy AS
  (
    SELECT
      CASE
        WHEN cast(total_orders AS INT) = 1
          THEN '1'
        WHEN cast(total_orders AS INT) = 2
          THEN '2'
        WHEN cast(total_orders AS INT) = 3
          THEN '3'
        WHEN cast(total_orders AS INT) = 4
          THEN '4'
        ELSE '5+'
      END AS orders_count,
      COUNT(DISTINCT customer_id) AS customers,
      SUM(total_spent) AS total_spent,

      SUM(total_orders) AS total_orders,

      cast(cast(COUNT(DISTINCT fod_data.customer_id) AS FLOAT)
           /(SELECT COUNT(distinct fod.customer_id) FROM fanjoy_orders_data fod) AS DECIMAL(5, 4))
        AS percent_total_customers,

      cast(cast(SUM(total_spent) AS FLOAT)
           /(SELECT SUM(total_price_usd) FROM fanjoy_orders_data
           ) AS DECIMAL(5, 4)) AS percent_total_spent,
-- --
      cast(cast(SUM(total_orders) AS FLOAT)
           /(SELECT count(DISTINCT fod2.order_number) FROM fanjoy_orders_data fod2
          ) AS DECIMAL(5, 4)) AS percent_total_orders,
--
      cast(SUM(total_spent) / cast(SUM(total_orders) AS FLOAT) AS DECIMAL(5, 2)) AS avg_order_size
    FROM
      (
        SELECT
          customer_id,
          count(DISTINCT order_number) AS total_orders, -- all total orders
          sum(total_price_usd)         AS total_spent -- everything spent per customer
        FROM fanjoy_orders_data
        GROUP BY customer_id
        ORDER BY 3 DESC -- some orders have $0 spent
      ) AS fod_data
    GROUP BY 1
    ORDER BY 1
  );



-- Team 10 Distribution, fixed
CREATE VIEW kevin_ip.dist_team10 AS
  (
    SELECT
      CASE
        WHEN cast(total_orders AS INT) = 1
          THEN '1'
        WHEN cast(total_orders AS INT) = 2
          THEN '2'
        WHEN cast(total_orders AS INT) = 3
          THEN '3'
        WHEN cast(total_orders AS INT) = 4
          THEN '4'
        ELSE '5+'
      END AS orders_count,
      COUNT(DISTINCT customer_id) AS customers,
      SUM(total_spent) AS total_spent,

      SUM(total_orders) AS total_orders,

      cast(cast(COUNT(DISTINCT fod_data.customer_id) AS FLOAT)
           /(SELECT COUNT(distinct fod.customer_id) FROM kevin_ip.fod_team10 fod) AS DECIMAL(5, 4))
        AS percent_total_customers,

      cast(cast(SUM(total_spent) AS FLOAT)
           /(SELECT SUM(total_price_usd) FROM kevin_ip.fod_team10
           ) AS DECIMAL(5, 4)) AS percent_total_spent,
-- --
      cast(cast(SUM(total_orders) AS FLOAT)
           /(SELECT count(DISTINCT fod2.order_number) FROM kevin_ip.fod_team10 fod2
          ) AS DECIMAL(5, 4)) AS percent_total_orders,
--
      cast(SUM(total_spent) / cast(SUM(total_orders) AS FLOAT) AS DECIMAL(5, 2)) AS avg_order_size
    FROM
      (
        SELECT
          customer_id,
          count(DISTINCT order_number) AS total_orders, -- all total orders
          sum(total_price_usd)         AS total_spent -- everything spent per customer
        FROM kevin_ip.fod_team10
        GROUP BY customer_id
        ORDER BY 3 DESC -- some orders have $0 spent
      ) AS fod_data
    GROUP BY 1
    ORDER BY 1
  );


SELECT *
FROM kevin_ip.fod_team10
LIMIT 10;