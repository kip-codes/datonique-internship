
-- Get Fanjoy and Tour Overlap
-- Get Fanjoy customers that have placed orders
SELECT DISTINCT
  B.id as cid,
  lower(email) as email,
  MIN(date_trunc('day', A.created_at)) as orderdate
FROM
  (
    SELECT DISTINCT
      customer_id,
      customer_email as email,
      created_at
    FROM fanjoy_orders_data
    WHERE
      customer_email not ilike '%fanjoy.co%'
      AND customer_email IS NOT NULL
      AND total_price > 0
    ORDER BY created_at
  ) as A
  JOIN
  (
    SELECT DISTINCT
      id,
      phone
    FROM fanjoy_customers_data
  ) AS B
  on a.customer_id = B.id
WHERE lower(email) IN
      (
        SELECT DISTINCT lower(t.email)
        FROM kevin_ip.jakepaul_tourupdates t
      )
GROUP BY 1,2
;




-- Get Fanjoy and Tour overlap based on customer data
SELECT DISTINCT (lower(email)), updated_at as lastupdated
FROM fanjoy_customers_data
where total_spent > 0 and email not ilike '%fanjoy.co%'
  and lower(email) in (
      SELECT DISTINCT lower(t.email)
      FROM kevin_ip.jakepaul_tourupdates t
)
;