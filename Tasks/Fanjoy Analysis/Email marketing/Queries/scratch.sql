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