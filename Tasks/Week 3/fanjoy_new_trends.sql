/*
1. Analysis of new merchandise that dropped within the specific month (i.e. out of the people who ordered the new merchandise, what % were 1st-time buyers, repeat customers etc.).
I can get you a list of all the specific merchandise that Jake launches on Fanjoy on a month-over-month basis if necessary to make this easier.
 */



/*
2. Identify Jake/Team 10's biggest buyer(s) -- maybe we should do this on a quarterly basis.
Would be good to see who the biggest purchasers are (maybe we split this into a geo infographic)
 */

-- FanJoy top 100 customers, lifetime
SELECT DISTINCT
  customer_id,
  country,
  zip,
  city,
  count(DISTINCT order_number) AS num_orders,
  sum(total_price_usd) AS total_sales
FROM fanjoy_orders_data fod
  JOIN fanjoy_customers_data fcd
    ON fod.customer_id = fcd.id
WHERE customer_id IS NOT NULL and customer_id > 0
GROUP BY customer_id, country, zip, city
ORDER BY total_sales DESC
LIMIT 100
;


-- Team 10 top 100 customers, lifetime
SELECT DISTINCT
  customer_id,
  country,
  zip,
  city,
  count(DISTINCT order_number) AS num_orders,
  sum(total_price_usd) AS total_sales
FROM fod_team10
  JOIN fanjoy_customers_data fcd
    ON fod_team10.customer_id = fcd.id
WHERE customer_id IS NOT NULL and customer_id > 0
GROUP BY customer_id, country, zip, city
ORDER BY total_sales DESC
LIMIT 100
;


/*
3. Three key outstanding trends that we should be paying attention to (e.g. Did we see any out-of-the-ordinary demand from Singapore in a given month etc.)
 */