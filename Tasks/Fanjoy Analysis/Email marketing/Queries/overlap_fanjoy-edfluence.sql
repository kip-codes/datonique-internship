
-- Get Fanjoy and Edfluence Overlap
-- Get Fanjoy customers that have placed orders
SELECT DISTINCT
  A.customer_id as cid,
  lower(email) as email,
  orderdate
FROM
  (
    SELECT DISTINCT
      customer_id,
      customer_email as email,
      min(created_at) as orderdate
    FROM fanjoy_orders_data
    WHERE
      customer_email not ilike '%fanjoy.co%'
      AND customer_email is not NULL
      AND total_price > 0
    group by 1,2
  ) as A
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
SELECT COUNT(DISTINCT lower(email))
FROM fanjoy_orders_data
WHERE
  total_price > 0
;


select COUNT(DISTINCT phone)
FROM fanjoy_customers_data
WHERE total_spent > 0
;