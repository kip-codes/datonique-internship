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
      WHERE extract(month from created_at) = 4 AND extract(year from created_at) = 2018
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



-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


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



-----------------------------------------------------------------------------
-----------------------------------------------------------------------------



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
  -- This is because of overlap between line item subsets. One order can contain line items from other subsets.

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
order by 1
;