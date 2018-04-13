
CREATE VIEW kevin_ip.ltd_jakepaul AS (
  SELECT
    count(DISTINCT customer_id) as total_customers,
    count(*) as total_orders,
    sum(total_price_usd) as total_sales,
    sum(total_price_usd) / count(*) as avg_order_size
  FROM fod_jakepaul
)
;