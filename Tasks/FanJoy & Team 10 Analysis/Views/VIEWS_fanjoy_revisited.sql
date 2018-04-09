
--------------------------------------------------------------------
--------------------------------------------------------------------
/*

  CUSTOMER DISTRIBUTION BY ORDER COUNT
    total orders DONE
    customers count DONE
    total spent DONE
    total orders DONE
    % of total cust DONE
    % of total spent DONE
    % total orders DONE
    avg order size DONE
 */

-- FanJoy (all) Distribution
SELECT
  CASE
    WHEN cast(total_orders AS INT) = 1
      THEN '1'
    WHEN cast(total_orders AS INT) = 2
      THEN '2'
    WHEN cast(total_orders AS INT) = 3
      THEN '3'
    WHEN cast(total_orders AS INT) = 4
      THEN '4'
    ELSE '5+'
  END AS total_orders,
  count(customer_id) as customers,
  sum(total_sales) as sales,
  sum(total_orders) as orders,

  cast(cast(COUNT(DISTINCT data.customer_id) AS FLOAT)
       /(SELECT COUNT(distinct fod.customer_id) FROM fanjoy_orders_data fod) AS DECIMAL(5, 4))
    AS percent_total_customers,

  cast(cast(SUM(data.total_sales) AS FLOAT)
       /(SELECT SUM(fld.price) FROM fanjoy_lineitems_data fld) AS DECIMAL(5, 4))
    AS percent_total_spent,
  -- Note: Orders total does not equal the line items price total!

  cast(cast(SUM(data.total_orders) AS FLOAT)
       /(SELECT count(DISTINCT fod.order_number) FROM fanjoy_orders_data fod) AS DECIMAL(5, 4))
    AS percent_total_orders,

  cast(SUM(data.total_sales) / cast(SUM(data.total_orders) AS FLOAT) AS DECIMAL(5, 2))
    AS avg_order_size
FROM
(
  select
  A.customer_id,
  count(B.order_number) as total_orders,
  sum(B.total_sales) as total_sales
  from
    (
      select distinct
        customer_id,
        order_number
      from fanjoy_orders_data
    ) as A
  join
    (
      select
        order_number,
        sum(price) as total_sales
      from fanjoy_lineitems_data
    group by 1
    ) as B
  on A.order_number = B.order_number
  group by 1
) as data
group by 1
order by 1;




-- TEAM 10 DISTRIBUTION
SELECT
  CASE
    WHEN cast(total_orders AS INT) = 1
      THEN '1'
    WHEN cast(total_orders AS INT) = 2
      THEN '2'
    WHEN cast(total_orders AS INT) = 3
      THEN '3'
    WHEN cast(total_orders AS INT) = 4
      THEN '4'
    ELSE '5+'
  END AS total_orders,
  count(customer_id) as customers,
  sum(total_sales) as sales,
  sum(total_orders) as orders,

  cast(cast(COUNT(DISTINCT data.customer_id) AS FLOAT)
       /(SELECT COUNT(distinct fod.customer_id) FROM kevin_ip.fod_team10 fod) AS DECIMAL(5, 4))
    AS percent_total_customers,

  cast(cast(SUM(data.total_sales) AS FLOAT)
       /(SELECT SUM(fld.price) FROM fld_team10 fld) AS DECIMAL(5, 4))
    AS percent_total_spent,
  -- Note: Orders total does not equal the line items price total!

  cast(cast(SUM(data.total_orders) AS FLOAT)
       /(SELECT count(DISTINCT fod.order_number) FROM fod_team10 fod) AS DECIMAL(5, 4))
    AS percent_total_orders,

  cast(SUM(data.total_sales) / cast(SUM(data.total_orders) AS FLOAT) AS DECIMAL(5, 2))
    AS avg_order_size
FROM
(
  select
  A.customer_id,
  count(B.order_number) as total_orders,
  sum(B.total_sales) as total_sales
  from
    (
      select distinct
        customer_id,
        order_number
      from fod_team10
    ) as A
  join
    (
      select
        order_number,
        sum(price) as total_sales
      from fld_team10
    group by 1
    ) as B
  on A.order_number = B.order_number
  group by 1
) as data
group by 1
order by 1;




-- JAKE PAUL DISTRIBUTION
SELECT
  CASE
    WHEN cast(total_orders AS INT) = 1
      THEN '1'
    WHEN cast(total_orders AS INT) = 2
      THEN '2'
    WHEN cast(total_orders AS INT) = 3
      THEN '3'
    WHEN cast(total_orders AS INT) = 4
      THEN '4'
    ELSE '5+'
  END AS total_orders,
  count(customer_id) as customers,
  sum(total_sales) as sales,
  sum(total_orders) as orders,

  cast(cast(COUNT(DISTINCT data.customer_id) AS FLOAT)
       /(SELECT COUNT(distinct fod.customer_id) FROM fod_jakepaul fod) AS DECIMAL(5, 4))
    AS percent_total_customers,

  cast(cast(SUM(data.total_sales) AS FLOAT)
       /(SELECT SUM(fld.price) FROM fld_jakepaul fld) AS DECIMAL(5, 4))
    AS percent_total_spent,
  -- Note: Orders total does not equal the line items price total!

  cast(cast(SUM(data.total_orders) AS FLOAT)
       /(SELECT count(DISTINCT fod.order_number) FROM fod_jakepaul fod) AS DECIMAL(5, 4))
    AS percent_total_orders,

  cast(SUM(data.total_sales) / cast(SUM(data.total_orders) AS FLOAT) AS DECIMAL(5, 2))
    AS avg_order_size
FROM
(
  select
  A.customer_id,
  count(B.order_number) as total_orders,
  sum(B.total_sales) as total_sales
  from
    (
      select distinct
        customer_id,
        order_number
      from fod_jakepaul
    ) as A
  join
    (
      select
        order_number,
        sum(price) as total_sales
      from fld_jakepaul
    group by 1
    ) as B
  on A.order_number = B.order_number
  group by 1
) as data
group by 1
order by 1;




-- TEAM 10, NO JAKE PAUL DISTRIBUTION
SELECT
  CASE
    WHEN cast(total_orders AS INT) = 1
      THEN '1'
    WHEN cast(total_orders AS INT) = 2
      THEN '2'
    WHEN cast(total_orders AS INT) = 3
      THEN '3'
    WHEN cast(total_orders AS INT) = 4
      THEN '4'
    ELSE '5+'
  END AS total_orders,
  count(customer_id) as customers,
  sum(total_sales) as sales,
  sum(total_orders) as orders,

  cast(cast(COUNT(DISTINCT data.customer_id) AS FLOAT)
       /(SELECT COUNT(distinct fod.customer_id) FROM fod_team10_nojake fod) AS DECIMAL(5, 4))
    AS percent_total_customers,

  cast(cast(SUM(data.total_sales) AS FLOAT)
       /(SELECT SUM(fld.price) FROM fld_team10_nojake fld) AS DECIMAL(5, 4))
    AS percent_total_spent,
  -- Note: Orders total does not equal the line items price total!

  cast(cast(SUM(data.total_orders) AS FLOAT)
       /(SELECT count(DISTINCT fod.order_number) FROM fod_team10_nojake fod) AS DECIMAL(5, 4))
    AS percent_total_orders,

  cast(SUM(data.total_sales) / cast(SUM(data.total_orders) AS FLOAT) AS DECIMAL(5, 2))
    AS avg_order_size
FROM
(
  select
  A.customer_id,
  count(B.order_number) as total_orders,
  sum(B.total_sales) as total_sales
  from
    (
      select distinct
        customer_id,
        order_number
      from fod_team10_nojake
    ) as A
  join
    (
      select
        order_number,
        sum(price) as total_sales
      from fld_team10_nojake
    group by 1
    ) as B
  on A.order_number = B.order_number
  group by 1
) as data
group by 1
order by 1;



--------------------------------------------------------------------
--------------------------------------------------------------------
/*

  LIFETIME TO DATE STATS

 */


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


CREATE VIEW kevin_ip.ltd_jakepaul AS (
  SELECT
    count(DISTINCT customer_id) as total_customers,
    count(*) as total_orders,
    sum(total_price_usd) as total_sales,
    sum(total_price_usd) / count(*) as avg_order_size
  FROM fod_jakepaul
)
;


CREATE VIEW kevin_ip.ltd_team10_nojake AS (
  SELECT count(DISTINCT customer_id) as total_customers,
    count(*) as total_orders,
    sum(total_price_usd) as total_sales,
    sum(total_price_usd) / count(*) as avg_order_size
  FROM fod_team10_nojake
)
;



----------------------------------------------------------------
----------------------------------------------------------------
/*

  FIRST ORDERS FOR ALL OF FANJOY
  No need for seperate views for subset, use entire Fanjoy set

 */

CREATE VIEW kevin_ip.first_orders_fanjoy AS (
  SELECT DISTINCT
    customer_id,
    MIN(date_trunc('month', created_at)) AS first_order_month
  FROM fanjoy_orders_data
  WHERE customer_id > 0 and customer_id IS NOT NULL
  GROUP BY customer_id
  ORDER BY customer_id
);
