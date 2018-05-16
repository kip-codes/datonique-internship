SELECT COUNT(distinct customer_email)
FROM fanjoy_orders_data
WHERE total_price > 0;


SELECT count(distinct email)
from fanjoy_customers_data
where total_spent > 0;


SELECT count(distinct phone)
FROM (
  (
    SELECT order_number, customer_id
    FROM fanjoy_orders_data
    WHERE total_price > 0
  ) A
  JOIN
    (
      SELECT id, phone
      FROM fanjoy_customers_data
    ) B
    ON A.customer_id = B.id
--   JOIN
--     (
--       SELECT order_number
--       from fanjoy_lineitems_data
--       where price > 0
--     ) C
--     ON A.order_number = C.order_number
)
;


SELECT count(distinct phone)
FROM fanjoy_customers_data
WHERE total_spent > 0
;


SELECT count(distinct email)
from kevin_ip.jakepaul_tourupdates
;


SELECT count(distinct phone_number)
FROM kevin_ip.jakepaul_optin
WHERE opted_in = 1
;


SELECT DISTINCT date_trunc('day', date::date)
FROM kevin_ip.jakepaul_tourupdates
ORDER BY date DESC;


SELECT
  COUNT(distinct customer_id)
FROM
  (
    SELECT distinct
      customer_id,
      order_number,
      lower(customer_email) as customer_email
    FROM fanjoy_orders_data
    WHERE
      customer_email NOT ILIKE '%fanjoy.co%'
  ) A
  JOIN
  (
    SELECT distinct
      order_number,
      sum(price) as total_sales
    FROM kevin_ip.fld_jakepaul
    GROUP BY order_number
  ) B
  ON A.order_number = B.order_number
WHERE B.total_sales > 0
;

SELECT * from jakepaul_optin where opted_in = 1;


SELECT count(distinct customer_id)
from fanjoy_orders_data
where
  total_price > 0
  and email is not NULL
;