
/*
  For customers that placed more than 1 order, take the average per bucket

  Average time until the next order

  Group by buckets for Order Count > 2 --> all
 */


SELECT *
FROM (
  SELECT
    A.customer_id,
    B.num_orders as orders_count,
    A.order_number,
    A.created_at,
    rank() over (PARTITION BY A.customer_id ORDER BY A.created_at DESC) as rank
  FROM fanjoy_orders_data A
  JOIN (
      SELECT DISTINCT
        f2.customer_id,
        count(distinct f2.order_number) as num_orders
      FROM fanjoy_orders_data f2
      GROUP BY f2.customer_id
      ) AS B
    ON A.customer_id = B.customer_id
  WHERE A.customer_id > 0 AND A.customer_id IS NOT NULL
) t
WHERE rank = 1 and orders_count > 1
ORDER BY customer_id
;



-- Previous purch dates
SELECT *
FROM (
  SELECT
    A.customer_id,
    B.num_orders as orders_count,
    A.order_number,
    A.created_at,
    rank() over (PARTITION BY A.customer_id ORDER BY A.created_at DESC) as rank
  FROM fanjoy_orders_data A
  JOIN (
      SELECT DISTINCT
        f2.customer_id,
        count(distinct f2.order_number) as num_orders
      FROM fanjoy_orders_data f2
      GROUP BY f2.customer_id
      ) AS B
    ON A.customer_id = B.customer_id
  WHERE A.customer_id > 0 AND A.customer_id IS NOT NULL
) t
WHERE rank = 2 and orders_count > 1
ORDER BY customer_id
;



------------------------------------------------------------
------------------------------------------------------------

-- All of Fanjoy

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
    FROM fanjoy_orders_data A
    JOIN (
        SELECT DISTINCT
          f2.customer_id,
          count(distinct f2.order_number) as num_orders
        FROM fanjoy_orders_data f2
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
    FROM fanjoy_orders_data A
    JOIN (
        SELECT DISTINCT
          f2.customer_id,
          count(distinct f2.order_number) as num_orders
        FROM fanjoy_orders_data f2
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
;




-- Team 10

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
    FROM fod_team10 A
    JOIN (
        SELECT DISTINCT
          f2.customer_id,
          count(distinct f2.order_number) as num_orders
        FROM fod_team10 f2
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
    FROM fod_team10 A
    JOIN (
        SELECT DISTINCT
          f2.customer_id,
          count(distinct f2.order_number) as num_orders
        FROM fod_team10 f2
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
;




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
;
