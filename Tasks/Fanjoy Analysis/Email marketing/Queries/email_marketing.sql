-- FanJoy (all) Distribution
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
  END AS total_orders,
  count(customer_id) as customers,
  sum(total_sales) as sales,
  sum(total_orders) as orders
FROM
(
  select
  A.customer_id,
  count(B.order_number) as total_orders,
  sum(B.total_sales) as total_sales
  from
    (
      select distinct
        customer_id,
        order_number
      from fanjoy_orders_data
    ) as A
  join
    (
      select
        order_number,
        sum(price) as total_sales
      from fanjoy_lineitems_data
    group by 1
    ) as B
  on A.order_number = B.order_number
  group by 1
) as data
group by 1
order by 1;


select
  A.name,
  A.email,
  count(A.order_number) as orders_count,
  sum(B.total_sales) as total_sales
from
  (
    select distinct
      initcap(customer_first_name + ' ' + customer_last_name) as name,
      customer_email as email,
      order_number
    from fanjoy_orders_data
  ) as A
  join
  (
    select
      order_number,
      sum(price) as total_sales
    from fanjoy_lineitems_data
  group by 1
  ) as B
    on A.order_number = B.order_number
WHERE
  email IS NOT NULL
  AND email not ilike '%fanjoy.co%'
  and name IS NOT NULL
group by 1,2
HAVING
  count(A.order_number) = 4
ORDER BY total_sales desc
LIMIT 1000
;