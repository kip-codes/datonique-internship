/*
View of all customer's first order timestamps
 */

CREATE VIEW kevin_ip.first_orders_fanjoy AS (
  SELECT DISTINCT
    customer_id,
    MIN(date_trunc('month', created_at)) AS first_order_month
  FROM fanjoy_orders_data
  WHERE customer_id > 0 and customer_id IS NOT NULL
  GROUP BY customer_id
  ORDER BY customer_id
);


CREATE VIEW kevin_ip.first_orders_team10 AS (
  SELECT DISTINCT
    customer_id,
    MIN(date_trunc('month', created_at)) AS first_order_month
  FROM fod_team10
  WHERE customer_id > 0 and customer_id IS NOT NULL
  GROUP BY customer_id
  ORDER BY customer_id
);



SELECT count(distinct customer_id)
FROM fanjoy_orders_data;