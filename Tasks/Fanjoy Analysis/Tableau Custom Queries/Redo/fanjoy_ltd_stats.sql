
--------------------------------------------------------------------
--------------------------------------------------------------------
/*

  LIFETIME TO DATE STATS

 */


-- LTD Fanjoy, all
SELECT
  count(DISTINCT customer_id) as total_customers,
  count(DISTINCT order_number) as total_orders,
  (
    SELECT sum(price)
    from fanjoy_lineitems_data
  ) as total_sales,
  (SELECT sum(price) FROM fanjoy_lineitems_data) / count(distinct order_number) as avg_order_size
FROM fanjoy_orders_data
;


-- LTD Team 10
SELECT
  count(DISTINCT customer_id) as total_customers,
  count(DISTINCT order_number) as total_orders,
  (
    SELECT sum(price)
    from fld_team10
  ) as total_sales,
  (SELECT sum(price) FROM fld_team10) / count(distinct order_number) as avg_order_size
FROM fod_team10
;


-- LTD Jake Paul only
SELECT
  count(DISTINCT customer_id) as total_customers,
  count(DISTINCT order_number) as total_orders,
  (
    SELECT sum(price)
    from fld_jakepaul
  ) as total_sales,
  (SELECT sum(price) FROM fld_jakepaul) / count(distinct order_number) as avg_order_size
FROM fod_jakepaul
WHERE created_at <= current_date - interval '4 month'
;

-- LTD Team 10, excl. Jake
SELECT
  count(DISTINCT customer_id) as total_customers,
  count(DISTINCT order_number) as total_orders,
  (
    SELECT sum(price)
    from fld_team10_nojake
  ) as total_sales,
  (SELECT sum(price) FROM fld_team10_nojake) / count(distinct order_number) as avg_order_size
FROM fod_team10_nojake
;
