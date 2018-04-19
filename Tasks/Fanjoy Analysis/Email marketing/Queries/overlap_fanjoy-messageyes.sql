

-- Get Fanjoy and messageyes Overlap
-- Get Fanjoy customers that have placed orders
SELECT DISTINCT
  A.customer_id as cid,
  regexp_replace(phone, '[^0-9]+', '') as phone,
  MIN(date_trunc('day', A.created_at)) as orderdate
FROM
  -- Paying customers
  (
    SELECT DISTINCT
      customer_id,
      created_at
    FROM fanjoy_orders_data
    WHERE
      customer_email not ilike '%fanjoy.co%'
      AND phone is not NULL
      AND total_price > 0
    ORDER BY created_at
  ) as A
  JOIN
  (
    SELECT DISTINCT
      id,
      phone,
      created_at
    FROM fanjoy_customers_data
  ) AS B
  on A.customer_id = B.id
WHERE regexp_replace(phone, '[^0-9]+', '') IN (
  SELECT DISTINCT phone_number
  FROM kevin_ip.jakepaul_optin
  WHERE opted_in = 1
)
GROUP BY 1,2
ORDER BY orderdate ASC
;


SELECT DISTINCT
  id,
  regexp_replace(phone, '[^0-9]+', '') as phone,
  date_trunc('day', updated_at) as lastupdated
FROM fanjoy_customers_data
WHERE total_spent > 0 and email not ilike '%fanjoy.co%'
 and regexp_replace(phone, '[^0-9]+', '') in (
   SELECT DISTINCT phone_number
    FROM kevin_ip.jakepaul_optin
    WHERE opted_in = 1
)
ORDER BY lastupdated DESC
;
