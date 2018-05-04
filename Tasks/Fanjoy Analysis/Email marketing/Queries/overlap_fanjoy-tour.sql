
-- Get Fanjoy and Tour Overlap
-- Get Fanjoy customers that have placed orders
SELECT DISTINCT
  A.customer_id as cid,
  lower(email) as email,
  MIN(date_trunc('day', A.created_at)) as orderdate
FROM
  (
    SELECT DISTINCT
      customer_id,
      customer_email as email,
      created_at
    FROM fanjoy_orders_data
    WHERE
      customer_email not ilike '%fanjoy.co%'
      AND customer_email IS NOT NULL
      AND total_price > 0
    ORDER BY created_at
  ) as A
WHERE lower(email) IN
      (
        select distinct LOWER(email)
        FROM kevin_ip.jakepaul_tourupdates
      )
GROUP BY 1,2
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
