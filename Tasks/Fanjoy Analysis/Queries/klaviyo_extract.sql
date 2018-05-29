
SELECT * from public.klaviyo_orders_data ORDER BY order_datetime DESC LIMIT 200;
SELECT * FROM public.klaviyo_profiles_data LIMIT 100;

SELECT *
FROM public.klaviyo_orders_data
where gateway IS NULL;

/*
  Get time of first order for all customers
  "Purchased for the first time in the last 90 days"
 */
select distinct email
FROM(
  SELECT
    trim(lower(email)) as email,
    min(order_datetime) as min_date
  from public.klaviyo_orders_data
  group by 1
) data
WHERE
  min_date >= CURRENT_DATE - INTERVAL '90 DAY'
  AND trim(lower(email)) IN (
    select distinct trim(lower(email))
    from kevin_ip.fod_jakepaul
  )
;



/*
  Get total spent per customer (email)
 */
select
  trim(lower(email)) as email,
  sum(value)
FROM public.klaviyo_orders_data
GROUP BY 1
;


/*
  Low LTV: $100
 */
SELECT distinct email
FROM (
  SELECT
    trim(lower(email)) AS email,
    sum(value) v
  FROM public.klaviyo_orders_data
  GROUP BY 1
) data
WHERE
  v >= 100 and v < 250
  AND trim(lower(email)) IN (
    select distinct trim(lower(email))
    from kevin_ip.fod_jakepaul
  )
;


/*
  Medium LTV: $250
 */
SELECT distinct email
FROM (
  SELECT
    trim(lower(email)) AS email,
    sum(value) v
  FROM public.klaviyo_orders_data
  GROUP BY 1
) data
WHERE
  v >= 250 and v < 500
  AND trim(lower(email)) IN (
    select distinct trim(lower(email))
    from kevin_ip.fod_jakepaul
  )
;


/*
  High LTV: $500
 */
SELECT distinct email
FROM (
  SELECT
    trim(lower(email)) AS email,
    sum(value) v
  FROM public.klaviyo_orders_data
  GROUP BY 1
) data
WHERE
  v >= 500
  AND trim(lower(email)) IN (
    select distinct trim(lower(email))
    from kevin_ip.fod_jakepaul
  )
;


/*
  All time purchasers, no purchase last 90 days
 */
SELECT DISTINCT TRIM(LOWER(email))
FROM public.klaviyo_orders_data
WHERE trim(lower(email)) IN (
    select distinct trim(lower(email))
    from kevin_ip.fod_jakepaul
  )
GROUP BY 1
HAVING max(order_datetime) < current_date - INTERVAL '90 days'
;


/*
  1+ Orders in US
 */
SELECT DISTINCT
  email
FROM klaviyo_orders_data
WHERE trim(lower(email)) IN (
    select distinct trim(lower(email))
    from kevin_ip.fod_jakepaul
  )
GROUP BY 1
HAVING count(order_datetime) >= 1
