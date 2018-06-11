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
      WHERE date_trunc('day', created_at) >= '2018-05-01' and date_trunc('day', created_at) <= '2018-05-29'
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



SELECT
  sum(sales)
FROM
  (
    SELECT
      order_number,
      created_at
    FROM fod_team10
    WHERE date_trunc('day', created_at) >= '2018-05-01' and date_trunc('day', created_at) <= '2018-05-29'
  ) a
  JOIN
  (
    SELECT
      order_number,
      sum(price) as sales
    from fld_team10
    group by 1
  ) b
  on a.order_number = b.order_number
;

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
      WHERE date_trunc('day', created_at) >= '2018-05-01' and date_trunc('day', created_at) <= '2018-05-29'
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





SELECT
  sum(total_sales)
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
      WHERE date_trunc('day', created_at) >= '2017-05-01' and date_trunc('day', created_at) <= '2017-05-29'
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
  ) data
;


SELECT DISTINCT
  date_trunc('day', created_at),
  sum(total_price_usd)
from fod_team10
  WHERE date_trunc('day', created_at) >= '2018-05-01' and date_trunc('day', created_at) <= '2018-05-29'
group by 1
order by 1
;