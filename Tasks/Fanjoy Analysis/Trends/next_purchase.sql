
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



----------------------------------------------------------------
/*
  Jake Paul, only
 */
----------------------------------------------------------------

SELECT
--   newest_purch.customer_id,
--   newest_purch.orders_count,
--   newest_purch_date as newest,
--   prev_purch_date as previous,
  newest_purch.orders_count,
  COUNT(DISTINCT newest_purch.customer_id) as num_cust, -- Sample size for average
  avg(EXTRACT(DAY FROM newest_purch_date-prev_purch_date)) as avg_diff_days
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


SELECT
  CASE
    when orders_count = 1 then '1'
    when orders_count = 2 then '2'
    when orders_count = 3 then '3'
    when orders_count = 4 then '4'
    else '5+'
  END AS orders_count,
  avg_diff_days,
  count(distinct customer_id) as num_cust
FROM (
  SELECT
    newest_purch.orders_count                             AS orders_count,
    newest_purch.customer_id,
    EXTRACT(DAY FROM newest_purch_date - prev_purch_date) AS avg_diff_days
  FROM (
         SELECT *
         FROM (
                SELECT
                  A.customer_id,
                  B.num_orders                   AS orders_count,
                  A.order_number,
                  A.created_at                      newest_purch_date,
                  rank()
                  OVER (
                    PARTITION BY A.customer_id
                    ORDER BY A.created_at DESC ) AS rank
                FROM fod_jakepaul A
                  JOIN (
                         SELECT DISTINCT
                           f2.customer_id,
                           count(DISTINCT f2.order_number) AS num_orders
                         FROM fod_jakepaul f2
                         GROUP BY f2.customer_id
                       ) AS B
                    ON A.customer_id = B.customer_id
                WHERE A.customer_id > 0 AND A.customer_id IS NOT NULL
              ) t
         WHERE rank = 1 AND orders_count > 1
         ORDER BY customer_id
       ) newest_purch
    JOIN (
           SELECT *
           FROM (
                  SELECT
                    A.customer_id,
                    B.num_orders                   AS orders_count,
                    A.order_number,
                    A.created_at                      prev_purch_date,
                    rank()
                    OVER (
                      PARTITION BY A.customer_id
                      ORDER BY A.created_at DESC ) AS rank
                  FROM fod_jakepaul A
                    JOIN (
                           SELECT DISTINCT
                             f2.customer_id,
                             count(DISTINCT f2.order_number) AS num_orders
                           FROM fod_jakepaul f2
                           GROUP BY f2.customer_id
                         ) AS B
                      ON A.customer_id = B.customer_id
                  WHERE A.customer_id > 0 AND A.customer_id IS NOT NULL
                ) t
           WHERE rank = 2 AND orders_count > 1
           ORDER BY customer_id
         ) prev_purch
      ON newest_purch.customer_id = prev_purch.customer_id
  ORDER BY orders_count
) t2
GROUP BY 1,2
order by 1 asc, 3 desc
;
