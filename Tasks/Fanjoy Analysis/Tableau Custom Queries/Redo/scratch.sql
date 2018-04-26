SELECT
  customer_id,
  A.order_number,
  title,
  sales
FROM
  (
    SELECT
      customer_id,
      order_number
    FROM fod_team10
    where customer_id = 5894964680
  ) AS A
  JOIN
  (
    SELECT
      order_number,
      title,
      SUM(price) as sales
    FROM fld_team10
    WHERE title not ilike '%jake%' and title not ilike '%erika%'
    GROUP BY order_number, title
  ) AS B
  ON A.order_number = B.order_number
;


select *
from fanjoy_lineitems_data
LIMIT 1;



SELECT
  sum(sales) as total_sales
FROM
(
  SELECT
    order_number,
    created_at
  FROM fanjoy_orders_data
  WHERE DATE_TRUNC('day', created_at) = '2018-04-11'
) as a
join
  (
    SELECT
      order_number,
      sum(price) as sales
    FROM fanjoy_lineitems_data
    WHERE title ILIKE '%erika%' OR name ILIKE '%erika%'
    GROUP BY order_number
    ) as b
on a.order_number = b.order_number
;

select * from fanjoy_orders_data
limit 1;


