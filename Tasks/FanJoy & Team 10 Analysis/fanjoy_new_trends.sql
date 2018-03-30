/*
1. Analysis of new merchandise that dropped within the specific month (i.e. out of the people who ordered the new merchandise, what % were 1st-time buyers, repeat customers etc.).
I can get you a list of all the specific merchandise that Jake launches on Fanjoy on a month-over-month basis if necessary to make this easier.
 */

-- Cannot use DISTINCT because each row in lineitems has specific order number

-- Get all line items for new merch, JAKE ONLY
SELECT *
FROM fanjoy_lineitems_data fld
WHERE
  lower(fld.name) like '%jake%paul%green%now%'
  or lower(fld.name) like '%jake%paul%radar%'
  or lower(fld.name) like '%jake%paul%mindset%'
  or lower(fld.name) like '%jake%paul%vlog%'
;

-- Get all line items for new merch, Team 10 only
SELECT *
FROM fanjoy_lineitems_data fld
WHERE
  lower(fld.name) like '%team%10%gaming%'
  or lower(fld.name) like '%chance%&%anthony%athena%'
  or lower(fld.name) like 'erika%let''s%party%'
  or lower(fld.name) like 'erika%fanny%' -- Fanny packs not included in GOAT or WILD
  or lower(fld.name) like 'erika%wild%phone%'
  or lower(fld.name) like 'erika%goat%phone%'
  or lower(fld.name) like 'erika%spring%break%'
  or lower(fld.name) like 'erika%bandana%'
  or lower(fld.vendor) like '%jake%paul%'
  or lower(fld.vendor) like '%team%10%'
;

-- In case all new merch isn't encapsulated by fod_team10, match against all of FanJoy.
SELECT
A.month,
A.total_customers,
A.total_orders,
A.total_sales,
B.new_customers,
B.new_orders,
B.new_sales,
(A.total_customers-B.new_customers) as existing_customers,
(A.total_orders-B.new_orders) as existing_orders,
(A.total_sales-B.new_sales) as existing_sales,
cast(B.new_customers as float)/A.total_customers as percent_new_customers,
cast(B.new_orders as float)/A.total_orders as percent_new_orders,
cast(B.new_sales as float)/A.total_sales as percent_new_sales

/*
  TOTALS ARE DEFINED BY NEW MERCH SALES, Jake Paul ONLY.
 */
FROM
  (
    SELECT
    date_trunc('month', fod.created_at) as month,
      COUNT(distinct fod.customer_id) AS total_customers,
      COUNT(distinct order_number) as total_orders,
      SUM(total_price_usd) as total_sales
    FROM fanjoy_orders_data fod
    WHERE fod.order_number IN (
      SELECT DISTINCT fld.order_number
      FROM fanjoy_lineitems_data fld
      WHERE
        lower(fld.name) like '%jake%paul%green%now%'
        or lower(fld.name) like '%jake%paul%radar%'
        or lower(fld.name) like '%jake%paul%mindset%'
        or lower(fld.name) like '%jake%paul%vlog%'
        or lower(fld.vendor) like '%jake%paul%'
    )
    GROUP BY 1
  ) as A
  JOIN
  (
    SELECT
      date_trunc('month', fod.created_at) as month,
      COUNT(distinct fod.customer_id) AS new_customers,
      COUNT(distinct order_number) as new_orders,
      SUM(total_price_usd) as new_sales
    FROM fanjoy_orders_data fod
      JOIN kevin_ip.first_orders_fanjoy
        ON fod.customer_id = first_orders_fanjoy.customer_id
          AND date_trunc('month', fod.created_at) = first_orders_fanjoy.first_order_month
    WHERE fod.order_number IN (
      SELECT DISTINCT fld.order_number
      FROM fanjoy_lineitems_data fld
      WHERE
        lower(fld.name) like '%jake%paul%green%now%'
        or lower(fld.name) like '%jake%paul%radar%'
        or lower(fld.name) like '%jake%paul%mindset%'
        or lower(fld.name) like '%jake%paul%vlog%'
        or lower(fld.vendor) like '%jake%paul%'
    )
    GROUP BY 1
  ) as B
  on A.month = B.month
ORDER BY month ASC
;


SELECT
A.month,
A.total_customers,
A.total_orders,
A.total_sales,
B.new_customers,
B.new_orders,
B.new_sales,
(A.total_customers-B.new_customers) as existing_customers,
(A.total_orders-B.new_orders) as existing_orders,
(A.total_sales-B.new_sales) as existing_sales,
cast(B.new_customers as float)/A.total_customers as percent_new_customers,
cast(B.new_orders as float)/A.total_orders as percent_new_orders,
cast(B.new_sales as float)/A.total_sales as percent_new_sales

/*
  TOTALS ARE DEFINED BY NEW MERCH SALES, Team 10 ONLY.
 */
FROM
  (
    SELECT
    date_trunc('month', fod.created_at) as month,
      COUNT(distinct fod.customer_id) AS total_customers,
      COUNT(distinct order_number) as total_orders,
      SUM(total_price_usd) as total_sales
    FROM fanjoy_orders_data fod
    WHERE fod.order_number IN (
      SELECT DISTINCT fld.order_number
      FROM fanjoy_lineitems_data fld
      WHERE
        lower(fld.name) like '%team%10%gaming%'
        or lower(fld.name) like '%chance%&%anthony%athena%'
        or lower(fld.name) like 'erika%let''s%party%'
        or lower(fld.name) like 'erika%fanny%' -- Fanny packs not included in GOAT or WILD
        or lower(fld.name) like 'erika%wild%phone%'
        or lower(fld.name) like 'erika%goat%phone%'
        or lower(fld.name) like 'erika%spring%break%'
        or lower(fld.name) like 'erika%bandana%'
        or lower(fld.vendor) like '%team%10%'
    )
    GROUP BY 1
  ) as A
  JOIN
  (
    SELECT
      date_trunc('month', fod.created_at) as month,
      COUNT(distinct fod.customer_id) AS new_customers,
      COUNT(distinct order_number) as new_orders,
      SUM(total_price_usd) as new_sales
    FROM fanjoy_orders_data fod
      JOIN kevin_ip.first_orders_fanjoy
        ON fod.customer_id = first_orders_fanjoy.customer_id
          AND date_trunc('month', fod.created_at) = first_orders_fanjoy.first_order_month
    WHERE fod.order_number IN (
      SELECT DISTINCT fld.order_number
      FROM fanjoy_lineitems_data fld
      WHERE
        lower(fld.name) like '%team%10%gaming%'
        or lower(fld.name) like '%chance%&%anthony%athena%'
        or lower(fld.name) like 'erika%let''s%party%'
        or lower(fld.name) like 'erika%fanny%' -- Fanny packs not included in GOAT or WILD
        or lower(fld.name) like 'erika%wild%phone%'
        or lower(fld.name) like 'erika%goat%phone%'
        or lower(fld.name) like 'erika%spring%break%'
        or lower(fld.name) like 'erika%bandana%'
        or lower(fld.vendor) like '%team%10%'
    )
    GROUP BY 1
  ) as B
  on A.month = B.month
ORDER BY month ASC
;


/*
  Obtain geographical information from customers.
 */

-- Jake Paul items for new customers ONLY
SELECT DISTINCT
  date_trunc('month', fod.created_at) as date,
  fod.customer_id,
  fod.customer_first_name + ' ' + fod.customer_last_name as name,
  fod.customer_email as email,
  fcd.country,
  fcd.zip,
  fcd.city,
  fod.total_price_usd as total_sales
FROM fanjoy_orders_data fod
  JOIN kevin_ip.first_orders_fanjoy
    ON fod.customer_id = first_orders_fanjoy.customer_id
      AND date_trunc('month', fod.created_at) = first_orders_fanjoy.first_order_month
  JOIN fanjoy_customers_data fcd
    ON fod.customer_id = fcd.id
WHERE fod.order_number IN (
  SELECT DISTINCT fld.order_number
  FROM fanjoy_lineitems_data fld
  WHERE
    lower(fld.name) LIKE '%jake%paul%green%now%'
    OR lower(fld.name) LIKE '%jake%paul%radar%'
    OR lower(fld.name) LIKE '%jake%paul%mindset%'
    OR lower(fld.name) LIKE '%jake%paul%vlog%'
    OR lower(fld.vendor) LIKE '%jake%paul%'
  )
ORDER BY date_trunc('month', fod.created_at), total_sales DESC
;


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