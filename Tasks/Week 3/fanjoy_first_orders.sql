/*
View of all customer's first order timestamps
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


CREATE VIEW kevin_ip.first_orders_team10 AS (
  SELECT DISTINCT
    customer_id,
    MIN(date_trunc('month', created_at)) AS first_order_month
  FROM fod_team10
  WHERE customer_id > 0 and customer_id IS NOT NULL
  GROUP BY customer_id
  ORDER BY customer_id
);

CREATE VIEW kevin_ip.TEST_first_orders_team10 AS (
  SELECT DISTINCT
    customer_id,
    MIN(date_trunc('month', created_at)) AS first_order_month
  FROM fanjoy_orders_data fod
  WHERE fod.order_number IN
          (
            SELECT DISTINCT fld.order_number
            FROM fanjoy_lineitems_data fld
            WHERE (lower(fld.name) like '%erika%'
              or lower(fld.name) like '%team%10%'
              or lower(fld.name) like '%jake%paul%'
              or lower(fld.name) like '%ben%hampton%'
              or lower(fld.vendor) like '%jake%paul%'
              or lower(fld.vendor) like '%team%10%')
          )
    AND customer_id > 0 and customer_id IS NOT NULL
  GROUP BY customer_id
  ORDER BY customer_id
);
-- 328368

select count(*)
from kevin_ip.first_orders_team10;
-- 328368

SELECT count(distinct customer_id)
FROM fanjoy_orders_data;