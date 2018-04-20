
/*
  Based on Fanjoy Tour Updates data, get all orders placed before the marketing campaign and orders after.
 */

-- Get Orders subscribers placed BEFORE tour update timestamp
SELECT DISTINCT
  A.customer_id,
  COUNT(distinct A.order_number) as num_orders,
  sum(B.total_sales) as sales_JP_items,
  MAX(A.created_at) as latest_orderdate_beforesignup,
  C.date as signup_date
FROM
  (
    SELECT distinct
      customer_id,
      order_number,
      created_at,
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
  JOIN
  (
    SELECT DISTINCT
      lower(email) as email,
      date::date as date -- date a customer signs up
    FROM kevin_ip.jakepaul_tourupdates
  ) C
  ON A.customer_email = C.email
WHERE A.created_at < C.date
GROUP BY customer_id, date
ORDER BY customer_id
;


-- Get orders placed by subscribers AFTER tour update timestamp
SELECT DISTINCT
  A.customer_id,
  COUNT(DISTINCT A.order_number) as num_orders,
  SUM(B.total_sales) as sales_JP_items,
  MIN(A.created_at) as earliest_order_aftersignup,
  C.date as signup_date
FROM
  (
    SELECT distinct
      customer_id,
      order_number,
      created_at,
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
  JOIN
  (
    SELECT DISTINCT
      lower(email) as email,
      date::date as date -- date a customer signs up
    FROM kevin_ip.jakepaul_tourupdates
  ) C
  ON A.customer_email = C.email
WHERE A.created_at > C.date
GROUP BY customer_id, date
ORDER BY customer_id
;



-- Get Orders from OTHER CUSTOMERS after they signed up for tour updates, with NO ORDERS before subscribing to updates
-- Subset of Orders after Tour Update Timestamp
SELECT DISTINCT
  A.customer_id,
  COUNT(DISTINCT A.order_number) as num_orders,
  sum(B.total_sales) as sales_JP_items,
  MIN(A.created_at) as earliest_order_aftersignup,
  C.date as signup_date
FROM
  (
    SELECT distinct
      customer_id,
      order_number,
      created_at,
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
  JOIN
  (
    SELECT DISTINCT
      lower(email) as email,
      date::date as date -- date a customer signs up
    FROM kevin_ip.jakepaul_tourupdates
  ) C
  ON A.customer_email = C.email
WHERE A.created_at > C.date
AND A.customer_id NOT IN
    (
      SELECT DISTINCT
        A.customer_id
      FROM
        (
          SELECT distinct
            customer_id,
            order_number,
            created_at,
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
        JOIN
        (
          SELECT DISTINCT
            lower(email) as email,
            date::date as date -- date a customer signs up
          FROM kevin_ip.jakepaul_tourupdates
        ) C
        ON A.customer_email = C.email
        WHERE A.created_at < C.date
    )
GROUP BY customer_id, date
ORDER BY customer_id
;