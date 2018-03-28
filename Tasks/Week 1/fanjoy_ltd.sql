-- Prompt: Group Fanjoy customers by month, and categorize by new/existing membership.
-- Compare sales from new customers that month and sales from existing customers.

-- Columns
-- 1. Month = orders | processed_at
-- 2. New customers = orders | customer_orders_count
-- 3. Existing customers = (else)
-- 4. Total customers = {2} + {3}
-- 5. Sales from New Customers = orders | total_price_usd WHERE ... = new
-- 6. Sales from Existing Customers = orders | total_price_usd WHERE ... = existing
-- 7. Total Sales = {5} + {6}


-- WRITTEN IN POSTGRESQL


-- extract months
SELECT DISTINCT EXTRACT(YEAR from processed_at) AS year
  , EXTRACT(MONTH from processed_at) AS month
FROM fanjoy_orders_data
ORDER BY year;


SHOW SEARCH_PATH ;

-- extract new customers
-- parameters: orders | customer_orders_count
-- New --> customer_orders_count == 1
-- Existing --> customer_orders_count > 1

SELECT id, order_number, customer_email as email, customer_orders_count as order_count
  , CASE
      WHEN customer_orders_count = 1 THEN 'New' ELSE 'Existing'
    END AS Classification
FROM fanjoy_orders_data
limit 15;

SELECT SUM(
      CASE
        WHEN customer_orders_count = 1 THEN 1 ELSE 0
      END
    ) AS new_customers -- FIXME subquery
  , SUM(
      CASE
        WHEN customer_orders_count > 1 THEN 1 ELSE 0
      END
    ) AS existing_customers -- FIXME subquery
  , SUM(
      CASE
        WHEN customer_orders_count = 1 THEN 1 ELSE 0
      END
    ) + (SUM(
      CASE
        WHEN customer_orders_count > 1 THEN 1 ELSE 0
      END
    )) AS total_customers -- FIXME subquery
FROM fanjoy_orders_data
group by EXTRACT(YEAR from processed_at)
limit 15;



-- Compute sales from new and existing customers

SELECT SUM(
    CASE WHEN customer_orders_count = 1 THEN
      total_price_usd ELSE 0 END
    ) AS new_sales
  , SUM(
    CASE WHEN customer_orders_count > 1 THEN
      total_price_usd ELSE 0 END
    ) AS existing_sales
FROM fanjoy_orders_data
limit 15;


------------------------------------------------------------------

SELECT distinct date_trunc('day',processed_at), processed_at
FROM fanjoy_orders_data
limit 15;


CREATE VIEW kevin_ip.ltd_fanjoy AS (
  SELECT count(DISTINCT customer_id) as total_customers,
    count(*) as total_orders,
    sum(total_price_usd) as total_sales,
    sum(total_price_usd) / count(*) as avg_order_size
  FROM fanjoy_orders_data
);

CREATE VIEW kevin_ip.ltd_team10 AS (
  SELECT count(DISTINCT customer_id) as total_customers,
    count(*) as total_orders,
    sum(total_price_usd) as total_sales,
    sum(total_price_usd) / count(*) as avg_order_size
  FROM fod_team10
);


