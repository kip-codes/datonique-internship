
SELECT
  fod.created_at,
  fcd.country as country,
  fcd.city as city,
  SUM(fod.total_price_usd) as total_sales,
  COUNT(DISTINCT fod.customer_id) as total_customers,
  COUNT(DISTINCT fod.order_number) as total_orders
FROM fanjoy_orders_data fod
  JOIN fanjoy_customers_data fcd
    ON fod.customer_id = fcd.id
WHERE customer_id IS NOT NULL and customer_id > 0
GROUP BY
  fcd.country,
  fcd.city,
  fod.created_at
;

