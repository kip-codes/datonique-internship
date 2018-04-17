select count(distinct(order_number))
from fanjoy_lineitems_data
WHERE price > 0
;


-- Get Fanjoy and Edfluence Overlap
-- Get Fanjoy customers that have placed orders
SELECT DISTINCT
--   customer_id,
--   phone,
--   lower(email) as email,
--   sum(sales) as total_spent
--   COUNT(distinct lower(email))
  lower(email) as email
FROM
  (
    SELECT DISTINCT
      customer_id,
      customer_email as email,
      order_number
    FROM fanjoy_orders_data
    WHERE
      customer_email not ilike '%fanjoy.co%'
      AND customer_email is not NULL
  ) as A
  JOIN
  (
    SELECT
      order_number,
      sum(price) as sales
    FROM fanjoy_lineitems_data
    WHERE sum(price) > 0
    GROUP BY order_number
  ) as B
  ON a.order_number = b.order_number
  JOIN
  (
    SELECT DISTINCT
      id,
      phone
    FROM fanjoy_customers_data
  ) AS C
  on a.customer_id = c.id
WHERE lower(email) IN (
  0
)
;


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
SELECT DISTINCT lower(email)
FROM fanjoy_customers_data
WHERE
  total_spent > 0
  and lower(email) in (
    0
  )
;

SELECT COUNT(distinct email) FROM fanjoy_customers_data
where total_spent > 0;