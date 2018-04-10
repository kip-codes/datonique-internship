/*
1. Analysis of new merchandise that dropped within the specific month (i.e. out of the people who ordered the new merchandise, what % were 1st-time buyers, repeat customers etc.).
I can get you a list of all the specific merchandise that Jake launches on Fanjoy on a month-over-month basis if necessary to make this easier.
 */

-- Cannot use DISTINCT because each row in lineitems has specific order number

-- Get all line items for new merch, JAKE ONLY
SELECT *
FROM fanjoy_lineitems_data fld
WHERE
  lower(fld.title) like '%jake%paul%green%now%'
  or lower(fld.title) like '%jake%paul%radar%'
  or lower(fld.title) like '%jake%paul%mindset%'
  or lower(fld.title) like '%jake%paul%vlog%'
;

-- Get all line items for new merch, Team 10 only
SELECT *
FROM fanjoy_lineitems_data fld
WHERE
  lower(fld.title) like '%team%10%gaming%'
  or lower(fld.title) like '%chance%&%anthony%athena%'
  or lower(fld.title) like 'erika%let''s%party%'
  or lower(fld.title) like 'erika%fanny%' -- Fanny packs not included in GOAT or WILD
  or lower(fld.title) like 'erika%wild%phone%'
  or lower(fld.title) like 'erika%goat%phone%'
  or lower(fld.title) like 'erika%spring%break%'
  or lower(fld.title) like 'erika%bandana%'
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
    sub_A1.month,
    COUNT(distinct sub_A1.customer_id) AS total_customers,
    COUNT(distinct sub_A2.order_number) as total_orders,
    SUM(sub_A2.total_sales) as total_sales
  FROM
    (
      SELECT
        date_trunc('month', created_at) as month,
        customer_id,
        order_number
      FROM fod_team10
    ) as sub_A1
    JOIN
    (
      SELECT
        order_number,
        sum(price) as total_sales
      FROM fld_team10
      WHERE
        title ilike '%jake%paul%green%now%'
        or title ilike '%jake%paul%radar%'
        or title ilike '%jake%paul%mindset%'
        or title ilike '%jake%paul%vlog%'
      GROUP BY order_number
    ) as sub_A2
    ON sub_A1.order_number = sub_A2.order_number
  GROUP BY sub_A1.month
) as A
JOIN
(
  SELECT
    sub_B1.month,
    COUNT(distinct sub_B1.customer_id) AS new_customers,
    COUNT(distinct sub_B2.order_number) as new_orders,
    SUM(sub_B2.total_sales) as new_sales
  FROM
    (
      SELECT
        date_trunc('month', created_at) as month,
        customer_id,
        order_number
      FROM fod_team10
    ) as sub_B1
    JOIN
    (
      SELECT
        order_number,
        sum(price) as total_sales
      FROM fld_team10
      WHERE
        title ilike '%jake%paul%green%now%'
        or title ilike '%jake%paul%radar%'
        or title ilike '%jake%paul%mindset%'
        or title ilike '%jake%paul%vlog%'
      GROUP BY order_number
    ) as sub_B2
      ON sub_B1.order_number = sub_B2.order_number -- link b1 to b2
    JOIN kevin_ip.first_orders_fanjoy
      ON sub_B1.customer_id = first_orders_fanjoy.customer_id -- link b1 to first orders by ID
        AND sub_B1.month = first_orders_fanjoy.first_order_month -- link b1 to first orders by month
  GROUP BY sub_B1.month
) as B
on A.month = B.month
ORDER BY A.month
;


-- Remaining merch.
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
  TOTALS ARE DEFINED BY NEW MERCH SALES, Team 10 excl. Jake ONLY.
 */

FROM
(
  SELECT
    sub_A1.month,
    COUNT(distinct sub_A1.customer_id) AS total_customers,
    COUNT(distinct sub_A2.order_number) as total_orders,
    SUM(sub_A2.total_sales) as total_sales
  FROM
    (
      SELECT
        date_trunc('month', created_at) as month,
        customer_id,
        order_number
      FROM fod_team10
    ) as sub_A1
    JOIN
    (
      SELECT
        order_number,
        sum(price) as total_sales
      FROM fld_team10
      WHERE
        title ilike '%team%10%gaming%'
        or title ilike '%chance%&%anthony%athena%'
        or title ilike 'erika%let''s%party%'
        or title ilike 'erika%fanny%' -- Fanny packs not included in GOAT or WILD
        or title ilike 'erika%wild%phone%'
        or title ilike 'erika%goat%phone%'
        or title ilike 'erika%spring%break%'
        or title ilike 'erika%bandana%'
      GROUP BY order_number
    ) as sub_A2
    ON sub_A1.order_number = sub_A2.order_number
  GROUP BY sub_A1.month
) as A
JOIN
(
  SELECT
    sub_B1.month,
    COUNT(distinct sub_B1.customer_id) AS new_customers,
    COUNT(distinct sub_B2.order_number) as new_orders,
    SUM(sub_B2.total_sales) as new_sales
  FROM
    (
      SELECT
        date_trunc('month', created_at) as month,
        customer_id,
        order_number
      FROM fod_team10
    ) as sub_B1
    JOIN
    (
      SELECT
        order_number,
        sum(price) as total_sales
      FROM fld_team10
      WHERE
        title ilike '%team%10%gaming%'
        or title ilike '%chance%&%anthony%athena%'
        or title ilike 'erika%let''s%party%'
        or title ilike 'erika%fanny%' -- Fanny packs not included in GOAT or WILD
        or title ilike 'erika%wild%phone%'
        or title ilike 'erika%goat%phone%'
        or title ilike 'erika%spring%break%'
        or title ilike 'erika%bandana%'
      GROUP BY order_number
    ) as sub_B2
      ON sub_B1.order_number = sub_B2.order_number -- link b1 to b2
    JOIN kevin_ip.first_orders_fanjoy
      ON sub_B1.customer_id = first_orders_fanjoy.customer_id -- link b1 to first orders by ID
        AND sub_B1.month = first_orders_fanjoy.first_order_month -- link b1 to first orders by month
  GROUP BY sub_B1.month
) as B
on A.month = B.month
ORDER BY A.month
;