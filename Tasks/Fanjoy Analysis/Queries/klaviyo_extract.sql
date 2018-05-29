
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
WHERE min_date >= CURRENT_DATE - INTERVAL '90 DAY'
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
WHERE v > 100 and v < 250
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
WHERE v > 250 and v < 500
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
WHERE v > 500
;


/*
  Abandoned Cart last 90 days
 */
