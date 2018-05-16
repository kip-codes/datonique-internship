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
;


----------------------------------------------------------------
/*
  Get count of active Edfluence subscribers
 */
----------------------------------------------------------------


-- GO TO EDFLUENCE DATABASE


---------------------------------------------------------------
-- Get Fanjoy and Edfluence Overlap
-- Get Fanjoy customers that have placed orders
---------------------------------------------------------------
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
  A.total_price_fromorders
FROM
  (
    SELECT DISTINCT
      customer_id,
      count(distinct id) as num_orders,
      sum(total_price) as total_price_fromorders
    FROM fanjoy_orders_data
    WHERE
      customer_email not ilike '%fanjoy.co%'
      AND customer_email is not NULL
      AND total_price > 0
    group by 1
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
  ) AS C
  on a.customer_id = c.id
WHERE trim(lower(C.email)) IN (
  SELECT trim(lower(email))
  FROM kevin_ip.edfluence_active
)
;


--------------------------------------------------------------------------------
/*
  Distribution of Order Count in overlap with Edfluence
 */
--------------------------------------------------------------------------------

-- FanJoy - Edfluence Overlap Distribution
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
  C.country,
  C.city,
  count(B.order_number) as total_orders,
  sum(B.total_sales) as total_sales
  from
    (
      select distinct
        customer_id,
        order_number,
        customer_email
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
  WHERE trim(lower(A.customer_email)) IN (
    select email
    from kevin_ip.edfluence_active
  )
  group by 1,2,3
) as data
group by 1
order by 1;





--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


SELECT COUNT(DISTINCT trim(lower(email)))
FROM fanjoy_orders_data
WHERE
  total_price > 0
;


SELECT count(DISTINCT customer_id)
FROM fanjoy_orders_data
WHERE total_price > 0 AND email is not null
;

select COUNT(DISTINCT phone)
FROM fanjoy_customers_data
WHERE total_spent > 0
;