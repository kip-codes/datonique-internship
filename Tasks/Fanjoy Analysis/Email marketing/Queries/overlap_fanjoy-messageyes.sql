----------------------------------------------------------------------
/*
  Get paying Fanjoy customers with valid phone numbers
 */
----------------------------------------------------------------------
SELECT count(distinct B.phone)
FROM (
    (
      SELECT
        order_number,
        customer_id
      FROM fanjoy_orders_data
      WHERE total_price > 0
    ) A
    JOIN
    (
      SELECT
        id,
        phone
      FROM fanjoy_customers_data
    ) B
      ON A.customer_id = B.id
)
;


----------------------------------------------------------------------
/*
  Get count of tour update subscribers
 */
----------------------------------------------------------------------
select COUNT(distinct phone_number)
from kevin_ip.jakepaul_optin
where opted_in = 1
;




----------------------------------------------------------------------

-- Get Fanjoy and messageyes Overlap
-- Get Fanjoy customers that have placed orders
SELECT DISTINCT
  id,
  initcap(C.first_name) as first_name,
  initcap(C.last_name) as last_name,
  trim(lower(C.email)) as email,
  regexp_replace(C.phone, '[^0-9]+', '') as phone,
  trim(initcap(C.country)) as country,
  trim(initcap(C.province)) as province,
  trim(initcap(C.city)) as city,
  initcap(C.address1) as address1,
  initcap(C.address2) as address2,
  A.num_orders,
  A.total_sales_fromorders
FROM
  -- Paying customers
  (
    SELECT DISTINCT
      customer_id,
      count(distinct id) as num_orders,
      sum(total_price) as total_sales_fromorders
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
  on A.customer_id = C.id
WHERE regexp_replace(C.phone, '[^0-9]+', '') IN (
  SELECT DISTINCT phone_number
  FROM kevin_ip.jakepaul_optin
  WHERE opted_in = 1
)
;


SELECT DISTINCT
  id,
  regexp_replace(phone, '[^0-9]+', '') as phone,
  date_trunc('day', updated_at) as lastupdated
FROM fanjoy_customers_data
WHERE total_spent > 0 and email not ilike '%fanjoy.co%'
 and regexp_replace(phone, '[^0-9]+', '') in (
   SELECT DISTINCT phone_number
    FROM kevin_ip.jakepaul_optin
    WHERE opted_in = 1
)
ORDER BY lastupdated DESC
;
