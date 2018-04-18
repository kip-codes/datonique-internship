

-- Get Fanjoy and messageyes Overlap
-- Get Fanjoy customers that have placed orders
SELECT DISTINCT
  regexp_replace(phone, '[^0-9]+', '') as phone
FROM
  -- Paying customers
  (
    SELECT DISTINCT
      customer_id
    FROM fanjoy_orders_data
    WHERE
      customer_email not ilike '%fanjoy.co%'
      AND phone is not NULL
      AND total_price > 0
  ) as A
  JOIN
  (
    SELECT DISTINCT
      id,
      phone
    FROM fanjoy_customers_data
  ) AS B
  on A.customer_id = B.id
WHERE regexp_replace(phone, '[^0-9]+', '') IN (
  SELECT DISTINCT phone_number
  FROM kevin_ip.jakepaul_optin
  WHERE opted_in = 1
)
;


SELECT DISTINCT regexp_replace(phone, '[^0-9]+', '') as phone
FROM fanjoy_customers_data
WHERE total_spent > 0 and email not ilike '%fanjoy.co%'
 and regexp_replace(phone, '[^0-9]+', '') in (
   SELECT DISTINCT phone_number
    FROM kevin_ip.jakepaul_optin
    WHERE opted_in = 1
)
;
