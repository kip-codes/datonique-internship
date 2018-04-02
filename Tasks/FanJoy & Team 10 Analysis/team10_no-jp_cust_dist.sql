CREATE VIEW kevin_ip.dist_team10_nojake AS
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
           /(SELECT COUNT(distinct fod.customer_id) FROM kevin_ip.fod_team10_nojake fod) AS DECIMAL(5, 4))
        AS percent_total_customers,

      cast(cast(SUM(fod_data.total_spent) AS FLOAT)
           /(SELECT SUM(fod2.total_price_usd) FROM kevin_ip.fod_team10_nojake fod2
           ) AS DECIMAL(5, 4)) AS percent_total_spent,
-- --
      cast(cast(SUM(fod_data.total_orders) AS FLOAT)
           /(SELECT count(DISTINCT fod3.order_number) FROM kevin_ip.fod_team10_nojake fod3
          ) AS DECIMAL(5, 4)) AS percent_total_orders,
--
      cast(SUM(total_spent) / cast(SUM(total_orders) AS FLOAT) AS DECIMAL(5, 2)) AS avg_order_size
    FROM
      (
        SELECT
          customer_id,
          count(DISTINCT order_number) AS total_orders, -- all total orders
          sum(total_price_usd)         AS total_spent -- everything spent per customer
        FROM kevin_ip.fod_team10_nojake
        GROUP BY customer_id
        ORDER BY 3 DESC -- some orders have $0 spent
      ) AS fod_data
    GROUP BY 1
    ORDER BY 1
  );