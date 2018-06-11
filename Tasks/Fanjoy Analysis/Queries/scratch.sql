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




SELECT
  title,
  country,
  count(DISTINCT C.id) as num_cust,
  count(A.order_number) as num_orders,
  sum(quantity) as item_qty,
  sum(sales) as total_sales
FROM
  (
    SELECT
      order_number,
      customer_id
    FROM fod_jakepaul
--     WHERE extract(year from created_at) = 2018
  ) A
  JOIN
  (
    SELECT
      order_number,
      title,
      quantity,
      sum(price) as sales
    FROM fld_jakepaul
    group by 1,2,3
  ) B
  ON a.order_number = b.order_number
  JOIN
  (
    SELECT
      id,
      country
    FROM fanjoy_customers_data
  ) C
  on a.customer_id = C.id
WHERE lower(trim(C.country)) in (
  'algeria',
  'bahrain',
  'egypt',
  'iran',
  'iraq',
  'israel',
  'jordan',
  'kuwait',
  'lebanon',
  'libya',
  'morocco',
  'occupied palestinian territories',
  'oman',
  'qatar',
  'saudi arabia',
  'syria',
  'tunisia',
  'turkey',
  'united arab emirates',
  'yemen'
)
GROUP BY 1,2
ORDER BY total_sales DESC;



SELECT
  C.country,
  sum(sales) as total_sales
FROM
  (
    SELECT
      order_number,
      customer_id
    FROM fanjoy_orders_data
--     WHERE extract(year from created_at) = 2018
  ) A
  JOIN
  (
    SELECT
      order_number,
      title,
      quantity,
      sum(price) as sales
    FROM fanjoy_lineitems_data
    group by 1,2,3
  ) B
  ON a.order_number = b.order_number
  JOIN
  (
    SELECT
      id,
      country
    FROM fanjoy_customers_data
  ) C
  on a.customer_id = C.id
WHERE lower(trim(C.country)) in (
  'algeria',
  'bahrain',
  'egypt',
  'iran',
  'iraq',
  'israel',
  'jordan',
  'kuwait',
  'lebanon',
  'libya',
  'morocco',
  'occupied palestinian territories',
  'oman',
  'qatar',
  'saudi arabia',
  'syria',
  'tunisia',
  'turkey',
  'united arab emirates',
  'yemen'
)
group by 1
order by 2 desc
;
