
-- Get Fanjoy and Tour Overlap
-- Get Fanjoy customers that have placed orders
SELECT DISTINCT
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
      AND customer_email IS NOT NULL
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
WHERE lower(email) IN
      (
        SELECT DISTINCT lower(t.email)
        FROM kevin_ip.jakepaul_tourupdates t
      )
;


SELECT DISTINCT (lower(email))
FROM fanjoy_customers_data
where total_spent > 0
  and lower(email) in (
      SELECT DISTINCT lower(t.email)
      FROM kevin_ip.jakepaul_tourupdates t
)
