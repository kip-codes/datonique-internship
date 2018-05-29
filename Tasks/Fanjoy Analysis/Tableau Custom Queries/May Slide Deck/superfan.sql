
/*
  Get distribution of all Team 10 customers with 5+ orders
 */
select
  total_orders,
  count(customer_id) as num_cust,
  sum(total_sales) as sales
from
(
  select
  A.customer_id,
  count (B.order_number) as total_orders,
  sum(B.total_sales) as total_sales
  FROM
  (SELECT customer_id, order_number
    FROM fod_jakepaul
  ) A
  JOIN
  (SELECT
    order_number,
    sum(price) as total_sales
    FROM fld_jakepaul
    GROUP BY order_number
  ) B
  on A.order_number = B.order_number
  WHERE customer_id IS NOT NULL and customer_id != 0
  group by 1
) data
where total_orders >= 5
group by 1
order by total_orders
;


/*
  Median time between sales for 5+ orders
 */

-- Jake Paul, only

SELECT
--   newest_purch.customer_id,
--   newest_purch.orders_count,
--   newest_purch_date as newest,
--   prev_purch_date as previous,
  newest_purch.orders_count,
  COUNT(DISTINCT newest_purch.customer_id) as num_cust, -- Sample size for average
  AVG(EXTRACT(DAY FROM newest_purch_date-prev_purch_date)) as avg_diff_days
FROM (
  SELECT *
  FROM (
    SELECT
      A.customer_id,
      B.num_orders as orders_count,
      A.order_number,
      A.created_at newest_purch_date,
      rank() over (PARTITION BY A.customer_id ORDER BY A.created_at DESC) as rank
    FROM fod_jakepaul A
    JOIN (
        SELECT DISTINCT
          f2.customer_id,
          count(distinct f2.order_number) as num_orders
        FROM fod_jakepaul f2
        GROUP BY f2.customer_id
        ) AS B
      ON A.customer_id = B.customer_id
    WHERE A.customer_id > 0 AND A.customer_id IS NOT NULL
  ) t
  WHERE rank = 1 and orders_count > 1
  ORDER BY customer_id
) newest_purch
JOIN (
  SELECT *
  FROM (
    SELECT
      A.customer_id,
      B.num_orders as orders_count,
      A.order_number,
      A.created_at prev_purch_date,
      rank() over (PARTITION BY A.customer_id ORDER BY A.created_at DESC) as rank
    FROM fod_jakepaul A
    JOIN (
        SELECT DISTINCT
          f2.customer_id,
          count(distinct f2.order_number) as num_orders
        FROM fod_jakepaul f2
        GROUP BY f2.customer_id
        ) AS B
      ON A.customer_id = B.customer_id
    WHERE A.customer_id > 0 AND A.customer_id IS NOT NULL
  ) t
  WHERE rank = 2 and orders_count > 1
  ORDER BY customer_id
) prev_purch
  ON newest_purch.customer_id = prev_purch.customer_id
GROUP BY newest_purch.orders_count
ORDER BY orders_count