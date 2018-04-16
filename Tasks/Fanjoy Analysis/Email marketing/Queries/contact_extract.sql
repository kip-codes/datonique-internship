

-- Get Fanjoy and Edfluence Overlap
-- Get Fanjoy customers that have placed orders
SELECT DISTINCT
--   customer_id,
  regexp_replace(phone, '[^0-9]+', '') AS phone
--   lower(email) as email,
--   sum(sales) as total_spent
--   COUNT(distinct lower(email))
--   lower(email) as email
FROM
  (
    SELECT DISTINCT
      customer_id,
      customer_email as email,
      order_number
    FROM fanjoy_orders_data
    WHERE
      customer_email not ilike '%fanjoy.co%'
      AND phone IS NOT NULL
  ) as A
  JOIN
  (
    SELECT
      order_number,
      sum(price) as sales
    FROM fanjoy_lineitems_data
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
;



