SELECT *
FROM fanjoy_lineitems_data fld
WHERE lower(name) LIKE '%nick%face%'
;

SELECT fod.*
FROM fanjoy_lineitems_data fld
  JOIN fanjoy_orders_data fod
    ON fld.order_number = fod.order_number
WHERE lower(name) LIKE '%nick%face%'
;

SELECT
  SUM(price)
FROM fld_jakepaul;


