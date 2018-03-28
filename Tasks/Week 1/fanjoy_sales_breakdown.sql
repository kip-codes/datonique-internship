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
CREATE VIEW kevin_ip.sales_breakdown_fanjoy AS
  (
    SELECT DISTINCT
      date_trunc('month',created_at) as date,
      SUM(
          CASE WHEN customer_orders_count = 1
            THEN 1
          ELSE 0 END
      )                                AS orders_new_customers,
      cast(SUM(
          CASE WHEN customer_orders_count = 1
            THEN 1
          ELSE 0 END
      )/(cast(count(*) as float)) as DECIMAL(5,4))  AS percent_orders_new_customers,
      SUM(
          CASE WHEN customer_orders_count > 1
            THEN 1
          ELSE 0 END
      )                                AS orders_existing_customers,
      cast(SUM(
          CASE WHEN customer_orders_count > 1
            THEN 1
          ELSE 0 END
      )/(cast(count(*) as float)) as DECIMAL(5,4))  AS percent_orders_existing_customers,
      count(*)                         AS total_orders,
      count(DISTINCT customer_id)      AS total_customers,
      cast(cast(count(*) as float)/count(DISTINCT customer_id) as DECIMAL(5,4)) AS avg_order_size,
      SUM(
          CASE WHEN customer_orders_count = 1
            THEN total_price_usd
          ELSE 0 END
      )                                AS new_customer_sales,
      SUM(
          CASE WHEN customer_orders_count = 1
            THEN total_price_usd
          ELSE 0 END
      )/SUM(total_price_usd)  AS percent_new_customer_sales,
      SUM(
          CASE WHEN customer_orders_count > 1
            THEN total_price_usd
          ELSE 0 END
      )                                AS existing_customer_sales,
      SUM(
          CASE WHEN customer_orders_count > 1
            THEN total_price_usd
          ELSE 0 END
      )/SUM(total_price_usd)        AS percent_existing_customer_sales,
      SUM(total_price_usd)             AS total_sales,
      sum(total_price_usd)/count(*)    AS avg_sales_per_order,
      sum(total_price_usd)/count(DISTINCT customer_id)    AS avg_sales_per_customer
    FROM fanjoy_orders_data
    GROUP BY date_trunc('month',created_at)
    ORDER BY date
  );


CREATE VIEW kevin_ip.sales_breakdown_team10 AS
  (
    SELECT DISTINCT
      date_trunc('month',created_at) as date,
      SUM(
          CASE WHEN customer_orders_count = 1
            THEN 1
          ELSE 0 END
      )                                AS orders_new_customers,
      cast(SUM(
          CASE WHEN customer_orders_count = 1
            THEN 1
          ELSE 0 END
      )/(cast(count(*) as float)) as DECIMAL(5,4))  AS percent_orders_new_customers,
      SUM(
          CASE WHEN customer_orders_count > 1
            THEN 1
          ELSE 0 END
      )                                AS orders_existing_customers,
      cast(SUM(
          CASE WHEN customer_orders_count > 1
            THEN 1
          ELSE 0 END
      )/(cast(count(*) as float)) as DECIMAL(5,4))  AS percent_orders_existing_customers,
      count(*)                         AS total_orders,
      count(DISTINCT customer_id)      AS total_customers,
      cast(cast(count(*) as float)/count(DISTINCT customer_id) as DECIMAL(5,4)) AS avg_order_size,
      SUM(
          CASE WHEN customer_orders_count = 1
            THEN total_price_usd
          ELSE 0 END
      )                                AS new_customer_sales,
      SUM(
          CASE WHEN customer_orders_count = 1
            THEN total_price_usd
          ELSE 0 END
      )/SUM(total_price_usd)  AS percent_new_customer_sales,
      SUM(
          CASE WHEN customer_orders_count > 1
            THEN total_price_usd
          ELSE 0 END
      )                                AS existing_customer_sales,
      SUM(
          CASE WHEN customer_orders_count > 1
            THEN total_price_usd
          ELSE 0 END
      )/SUM(total_price_usd)        AS percent_existing_customer_sales,
      SUM(total_price_usd)             AS total_sales,
      sum(total_price_usd)/count(*)    AS avg_sales_per_order,
      sum(total_price_usd)/count(DISTINCT customer_id)    AS avg_sales_per_customer
    FROM kevin_ip.fod_team10

    GROUP BY date_trunc('month',created_at)
    ORDER BY date
  );

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


