-- Total customers in FanJoy that have paid
SELECT COUNT(DISTINCT id)
FROM fanjoy_customers_data
WHERE total_spent > 0


-- Average order size per customer  = total spent for customer / num orders for customer
-- 1. Get total spent per customer
SELECT id, SUM(total_spent) as total_per_id
FROM fanjoy_customers_data
GROUP BY id

-- 2. Get number of orders for customer
SELECT DISTINCT(id), orders_count
FROM fanjoy_customers_data


-- 3. Get average order size per customer
SELECT TOP 10 DISTINCT(id) 
		,SUM(total_spent) as total_per_id
		,orders_count
		,(SUM(total_spent) / orders_count) as average_order_size
FROM fanjoy_customers_data
GROUP BY id, orders_count
HAVING SUM(total_spent) > 0;

-- 4. Overall average order size
SELECT (SUM(total_spent) / SUM(orders_count)) as average_order_size
FROM fanjoy_customers_data;



-- Overall average order size only for Jake
-- 1. Overall average order size 
SELECT (SUM(total_spent) / SUM(orders_count)) as average_order_size
FROM fanjoy_customers_data;

-- 2. Extract sample names
SELECT TOP 100 DISTINCT name
FROM fanjoy_lineitems_data
WHERE name LIKE '%Jake%';


-- Extract sample row from line items
SELECT TOP 2 *
FROM fanjoy_lineitems_data;


-- Link orders to customers
SELECT fj_c.id
	,	fj_o.total_price_usd AS order_total
	,	fj_c.total_spent as customer_total
	, count(fj_c.id)
FROM fanjoy_customers_data AS fj_c
	JOIN fanjoy_orders_data AS fj_o
		ON fj_c.id = fj_o.customer_id
GROUP BY fj_c.id, fj_o.total_price_usd, fj_c.total_spent



-- 3. Create a condition that extracts only Jake
-- name must contain '*jake*'
SELECT SUM(fj_li.pre_tax_price) AS total_sales
	,COUNT(fj_o.order_number) as total_orders
	,(SUM(fj_li.pre_tax_price) / COUNT(fj_o.order_number)) AS average_order_size
FROM fanjoy_customers_data AS fj_c
	JOIN fanjoy_orders_data AS fj_o
		ON fj_c.id = fj_o.customer_id  -- links customer id to the order placed
	JOIN fanjoy_lineitems_data AS fj_li
		ON fj_o.order_number = fj_li.order_number -- links order placed to the line item with details
WHERE lower(fj_li.name) LIKE '%jake%'
	AND fj_o.total_price_usd > 0



-- Get total of all orders containing Jake items (including non-Jake items in order)
SELECT fj_o.order_number
	, fj_o.id
	, SUM(fj_o.total_price_usd)
FROM fanjoy_orders_data AS fj_o
GROUP BY fj_o.order_number, fj_o.id
ORDER BY SUM(fj_o.total_price_usd) DESC;



-- Isolate Customers info w/ Line Items
SELECT SUM(fj_c.total_spent) AS total_spent
	,COUNT(fj_o.order_number) as total_orders
	,(SUM(fj_li.pre_tax_price) / COUNT(fj_o.order_number)) AS average_order_size
FROM fanjoy_customers_data AS fj_c
	JOIN fanjoy_orders_data AS fj_o
		ON fj_c.id = fj_o.customer_id  -- links customer id to the order placed
	JOIN fanjoy_lineitems_data AS fj_li
		ON fj_o.order_number = fj_li.order_number -- links order placed to the line item with details
WHERE lower(fj_li.name) LIKE '%jake%'
	AND fj_o.total_price_usd > 0

-----------------


-- Get all line items corresponding to Jake
-- Relevant information:
-- 1. Order number
-- 2. Price
-- Must be grouped by order number (for one order, may be multiple line items)
SELECT order_number
	, id
	, name
	, SUM(price)
FROM fanjoy_lineitems_data AS fj_li
WHERE LOWER(fj_li.name) LIKE '%jake%'
GROUP BY order_number, id, name
ORDER BY SUM(price) DESC;


-- Using this as a subquery, obtain orders which have these line items
SELECT fj_o.id
	, fj_o.order_number
	,	fj_o.total_price_usd
FROM fanjoy_orders_data AS fj_o
WHERE  fj_o.order_number IN (
	SELECT order_number
	FROM fanjoy_lineitems_data AS fj_li
	WHERE LOWER(fj_li.name) LIKE '%jake%'
	)
ORDER BY total_price_usd DESC;


SELECT SUM(fj_o.total_price_usd)
	,	COUNT(order_number)
	, (SUM(fj_o.total_price_usd) / COUNT(order_number)) AS average_order
FROM fanjoy_orders_data AS fj_o
WHERE fj_o.order_number IN (
	SELECT DISTINCT order_number
	FROM fanjoy_lineitems_data AS fj_li
	WHERE LOWER(fj_li.name) LIKE '%jake%'
	)
;