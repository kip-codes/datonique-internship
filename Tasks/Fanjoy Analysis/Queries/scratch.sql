SELECT count(*)
FROM messages_users;


SELECT MAX(created_at)
FROM kevin_ip.fod_team10;


SELECT MAX(created_at)
FROM fanjoy_orders_data;


SELECT
  total_orders,
  count(distinct customer_id),
  SUM(total_sales)
FROM (
  SELECT
    A.customer_id,
    count(B.order_number) AS total_orders,
    sum(B.total_sales)    AS total_sales
  FROM
    (
      SELECT DISTINCT
        customer_id,
        order_number
      FROM kevin_ip.fod_jakepaul
    ) AS A
    JOIN
    (
      SELECT
        order_number,
        sum(price) AS total_sales
      FROM kevin_ip.fld_jakepaul
      GROUP BY 1
    ) AS B
      ON A.order_number = B.order_number
  GROUP BY 1
--   HAVING count(B.order_number) = 1543
) d
WHERE total_orders >= 5
group BY 1
;

select *
FROM fanjoy_customers_data
WHERE id = 1543;

SELECT *
from fanjoy_orders_data
order by created_at DESC
limit 30
;