select count(distinct(order_number))
from fanjoy_lineitems_data
WHERE price > 0
;


-- Get Fanjoy and messageyes Overlap
-- Get Fanjoy customers that have placed orders
SELECT DISTINCT
  regexp_replace(phone, '[^0-9]+', '') as phone
FROM
  -- Paying customers
  (
    SELECT DISTINCT
      customer_id,
      customer_email as email,
      order_number
    FROM fanjoy_orders_data
    WHERE
      customer_email not ilike '%fanjoy.co%'
      AND phone is not NULL
  ) as A
  JOIN
  (
    SELECT
      order_number,
      sum(price) as sales
    FROM fanjoy_lineitems_data
    GROUP BY order_number
    HAVING sum(price) > 0
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
WHERE regexp_replace(phone, '[^0-9]+', '') IN (
  SELECT DISTINCT phone_number
  FROM kevin_ip.jakepaul_optin
  WHERE opted_in = 1
)
;


SELECT DISTINCT regexp_replace(phone, '[^0-9]+', '') as phone
FROM fanjoy_customers_data
WHERE total_spent > 0
 and regexp_replace(phone, '[^0-9]+', '') in (
   SELECT DISTINCT phone_number
    FROM kevin_ip.jakepaul_optin
    WHERE opted_in = 1
)
;
