
/*

  ALL FANJOY

 */

-- By city
SELECT
  date_trunc('day', fod.created_at) as date,
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
  date_trunc('day', fod.created_at)
ORDER BY date
;


-- By country
SELECT
  date_trunc('day', fod.created_at) as date,
  fcd.country as country,
  SUM(fod.total_price_usd) as total_sales,
  COUNT(DISTINCT fod.customer_id) as total_customers,
  COUNT(DISTINCT fod.order_number) as total_orders
FROM fanjoy_orders_data fod
  JOIN fanjoy_customers_data fcd
    ON fod.customer_id = fcd.id
WHERE customer_id IS NOT NULL and customer_id > 0
GROUP BY
  fcd.country,
  date_trunc('day', fod.created_at)
ORDER BY date
;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-- TEAM 10
SELECT
  date_trunc('day', fod.created_at) as date,
  fcd.country as country,
  fcd.city as city,
  SUM(fod.total_price_usd) as total_sales,
  COUNT(DISTINCT fod.customer_id) as total_customers,
  COUNT(DISTINCT fod.order_number) as total_orders
FROM kevin_ip.fod_team10 fod
  JOIN fanjoy_customers_data fcd
    ON fod.customer_id = fcd.id
WHERE customer_id IS NOT NULL and customer_id > 0
GROUP BY
  fcd.country,
  fcd.city,
  date_trunc('day', fod.created_at)
;


-- Jake Paul
SELECT
  date_trunc('day', fod.created_at) as date,
  fcd.country as country,
  fcd.city as city,
  SUM(fod.total_price_usd) as total_sales,
  COUNT(DISTINCT fod.customer_id) as total_customers,
  COUNT(DISTINCT fod.order_number) as total_orders
FROM kevin_ip.fod_jakepaul fod
  JOIN fanjoy_customers_data fcd
    ON fod.customer_id = fcd.id
WHERE customer_id IS NOT NULL and customer_id > 0
GROUP BY
  fcd.country,
  fcd.city,
  date_trunc('day', fod.created_at)
;


-- Rest of Team 10
SELECT
  date_trunc('day', fod.created_at) as date,
  fcd.country as country,
  fcd.city as city,
  SUM(fod.total_price_usd) as total_sales,
  COUNT(DISTINCT fod.customer_id) as total_customers,
  COUNT(DISTINCT fod.order_number) as total_orders
FROM kevin_ip.fod_team10_nojake fod
  JOIN fanjoy_customers_data fcd
    ON fod.customer_id = fcd.id
WHERE customer_id IS NOT NULL and customer_id > 0
GROUP BY
  fcd.country,
  fcd.city,
  date_trunc('day', fod.created_at)
;


------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- FANJOY
select
  lower(fcd.city) as city,
  lower(fcd.country) as country,
  sum(total_price_usd) as sales,
  COUNT(DISTINCT fod.customer_id) as total_customers,
  COUNT(DISTINCT fod.order_number) as total_orders,
  sum(total_price_usd) / count(distinct fod.order_number) as avg_order_size
from fanjoy_orders_data fod
  join fanjoy_customers_data fcd
    on fod.customer_id=fcd.id
where
  city is not null
  and country is not null
group by 1,2
having sum(total_price_usd)>0
order by 3 desc;


-- TEAM 10
select
  lower(fcd.city) as city,
  lower(fcd.country) as country,
  sum(total_price_usd) as sales,
  COUNT(DISTINCT fod.customer_id) as total_customers,
  COUNT(DISTINCT fod.order_number) as total_orders,
  sum(total_price_usd) / count(distinct fod.order_number) as avg_order_size
from kevin_ip.fod_team10 fod
  join fanjoy_customers_data fcd
    on fod.customer_id=fcd.id
where
  city is not null
  and country is not null
group by 1,2
having sum(total_price_usd)>0
order by 3 desc;


-- JAKE PAUL
select
  lower(fcd.city) as city,
  lower(fcd.country) as country,
  sum(total_price_usd) as sales,
  COUNT(DISTINCT fod.customer_id) as total_customers,
  COUNT(DISTINCT fod.order_number) as total_orders,
  sum(total_price_usd) / count(distinct fod.order_number) as avg_order_size
from kevin_ip.fod_jakepaul fod
  join fanjoy_customers_data fcd
    on fod.customer_id=fcd.id
where
  city is not null
  and country is not null
group by 1,2
having sum(total_price_usd)>0
order by 3 desc;



-- TEAM 10, EXCL JAKE PAUL
select
  lower(fcd.city) as city,
  lower(fcd.country) as country,
  sum(total_price_usd) as sales,
  COUNT(DISTINCT fod.customer_id) as total_customers,
  COUNT(DISTINCT fod.order_number) as total_orders,
  sum(total_price_usd) / count(distinct fod.order_number) as avg_order_size
from kevin_ip.fod_team10_nojake fod
  join fanjoy_customers_data fcd
    on fod.customer_id=fcd.id
where
  city is not null
  and country is not null
group by 1,2
having sum(total_price_usd)>0
order by 3 desc;