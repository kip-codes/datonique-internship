/*
  Test subqueries on criteria for determining new customer.
 */

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

FROM
(
SELECT
date_trunc('month', fod.created_at) as month,
  COUNT(distinct fod.customer_id) AS total_customers,
  COUNT(distinct order_number) as total_orders,
  SUM(total_price_usd) as total_sales
FROM fanjoy_orders_data fod
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
GROUP BY 1
) as B
on A.month = B.month
;

/*
  All of Team 10
 */


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

FROM
(
SELECT
date_trunc('month', fod.created_at) as month,
  COUNT(distinct fod.customer_id) AS total_customers,
  COUNT(distinct order_number) as total_orders,
  SUM(total_price_usd) as total_sales
FROM fod_team10 fod
GROUP BY 1
) as A
JOIN
(
SELECT
  date_trunc('month', fod.created_at) as month,
  COUNT(distinct fod.customer_id) AS new_customers,
  COUNT(distinct order_number) as new_orders,
  SUM(total_price_usd) as new_sales
FROM fod_team10 fod
  JOIN kevin_ip.first_orders_team10
    ON fod.customer_id = first_orders_team10.customer_id
      AND date_trunc('month', fod.created_at) = first_orders_team10.first_order_month
GROUP BY 1
) as B
on A.month = B.month
;



/*
  Jake Paul only
 */

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

FROM
(
SELECT
date_trunc('month', fod.created_at) as month,
  COUNT(distinct fod.customer_id) AS total_customers,
  COUNT(distinct order_number) as total_orders,
  SUM(total_price_usd) as total_sales
FROM fod_jakepaul fod
GROUP BY 1
) as A
JOIN
(
SELECT
  date_trunc('month', fod.created_at) as month,
  COUNT(distinct fod.customer_id) AS new_customers,
  COUNT(distinct order_number) as new_orders,
  SUM(total_price_usd) as new_sales
FROM fod_jakepaul fod
  JOIN kevin_ip.first_orders_team10
    ON fod.customer_id = first_orders_team10.customer_id
      AND date_trunc('month', fod.created_at) = first_orders_team10.first_order_month
GROUP BY 1
) as B
on A.month = B.month
;



/*
  Team 10 excluding Jake Paul
 */


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

FROM
(
SELECT
date_trunc('month', fod.created_at) as month,
  COUNT(distinct fod.customer_id) AS total_customers,
  COUNT(distinct order_number) as total_orders,
  SUM(total_price_usd) as total_sales
FROM fod_team10_nojake fod
GROUP BY 1
) as A
JOIN
(
SELECT
  date_trunc('month', fod.created_at) as month,
  COUNT(distinct fod.customer_id) AS new_customers,
  COUNT(distinct order_number) as new_orders,
  SUM(total_price_usd) as new_sales
FROM fod_team10_nojake fod
  JOIN kevin_ip.first_orders_team10
    ON fod.customer_id = first_orders_team10.customer_id
      AND date_trunc('month', fod.created_at) = first_orders_team10.first_order_month
GROUP BY 1
) as B
on A.month = B.month
;