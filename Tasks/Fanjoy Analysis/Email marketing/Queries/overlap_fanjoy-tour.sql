----------------------------------------------------------------
/*
  Get count of paying Fanjoy customers that have valid emails
 */
----------------------------------------------------------------

SELECT count(distinct customer_id)
from fanjoy_orders_data
where
  total_price > 0
  and email is not NULL
  and date_trunc('day', created_at) < '2018-06-05'
;

----------------------------------------------------------------------
/*
  Get count of tour update subscribers
 */
----------------------------------------------------------------------
select COUNT(*)
from kevin_ip.jakepaul_tourupdates;

SELECT count(*)
FROM kevin_ip.jakepaul_tourupdates
WHERE date_trunc('day', date::date) < '2018-07-10';





-- Get Fanjoy and Tour Overlap
-- Get Fanjoy customers that have placed orders
SELECT DISTINCT
  id,
  initcap(C.first_name) as first_name,
  initcap(C.last_name) as last_name,
  trim(lower(C.email)) as email,
  C.phone,
  trim(initcap(C.country)) as country,
  trim(initcap(C.province)) as province,
  trim(initcap(C.city)) as city,
  initcap(C.address1) as address1,
  initcap(C.address2) as address2,
--   C.orders_count,
  A.num_orders,
--   C.total_spent,
  A.total_sales_fromorders
FROM
  (
    SELECT DISTINCT
      customer_id,
      count(distinct id) as num_orders,
      sum(total_price) as total_sales_fromorders
    FROM fanjoy_orders_data
    WHERE
      total_price > 0
      and date_trunc('day', created_at) < '2018-07-10'
--       and customer_email not ilike '%fanjoy.co%'
--       AND customer_email IS NOT NULL
    GROUP BY 1
  ) as A
  JOIN
  (
    SELECT DISTINCT
      id,
      first_name,
      last_name,
      email,
      phone,
      country,
      province,
      city,
      address1,
      address2
    FROM fanjoy_customers_data
    WHERE
      email not ilike '%fanjoy.co%'
      AND email IS NOT NULL
  ) AS C
  on a.customer_id = c.id
WHERE trim(lower(email)) IN
      (
        SELECT trim(lower(email))
        FROM kevin_ip.jakepaul_tourupdates
        WHERE date_trunc('day', date::date) < '2018-07-10'
      )
;


-- Get Fanjoy and Tour overlap based on customer data
SELECT DISTINCT (lower(email)), updated_at as lastupdated
FROM fanjoy_customers_data
where total_spent > 0 and email not ilike '%fanjoy.co%'
  and lower(email) in (
      SELECT DISTINCT lower(t.email)
      FROM kevin_ip.jakepaul_tourupdates t
)
;


----------------------------------------------------------------------
/*
  Get ALL Fanjoy customers in Tour Venue cities.
 */
----------------------------------------------------------------------
SELECT
  name,
  email,
  phone,
  country,
  city,
  num_orders,
  total_price_fromorders
FROM
(
  SELECT DISTINCT
    customer_id,
    count(distinct id) as num_orders,
    sum(total_price) as total_price_fromorders
  FROM fanjoy_orders_data
  WHERE total_price > 0
  group by customer_id
) A
JOIN (
  select DISTINCT
    initcap(first_name) + ' ' + initcap(last_name) as name,
    id,
    trim(lower(email)) as email,
    phone,
    initcap(country) as country,
    initcap(city) as city
  FROM fanjoy_customers_data
  where
    name IS NOT NULL
    and country ILIKE '%united%states%'
    AND lower(city) IN (
      SELECT lower(city2)
      FROM jakepaul_tourvenues
    )
) B
ON A.customer_id = B.id
;


--------------------------------------------------------------------------------
/*
  Distribution of Order Count in overlap with Tour venues
 */
--------------------------------------------------------------------------------

-- FanJoy - Tour Venue Overlap Distribution
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
  sum(total_orders) as orders
FROM
(
  select
  A.customer_id,
  initcap(C.country) as country,
  initcap(C.city) as city,
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
    join
    (
      SELECT
        id,
        initcap(country) as country,
        initcap(city) as city
      FROM fanjoy_customers_data
      ) as C
    ON A.customer_id = C.id
  WHERE
    C.country ilike '%united%states%'
    AND C.city IN (
      SELECT city2
      FROM kevin_ip.jakepaul_tourvenues
    )
  group by 1,2,3
) as data
group by 1
order by 1;
