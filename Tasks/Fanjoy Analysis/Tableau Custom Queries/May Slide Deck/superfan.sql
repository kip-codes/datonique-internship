
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
  Verify median data
 */
-- For each order count, get the median sales (per customer)
SELECT
  total_orders,
  count(customer_id) as num_cust,
  sum(sales_per_cust) as total_sales,
  MEDIAN(sales_per_cust) as median_order_size
FROM
  (
    -- For each customer, get total orders and total sales placed
    SELECT
      A.customer_id,
      count(B.order_number) AS total_orders,
      sum(B.total_sales)    AS sales_per_cust
    FROM
      (SELECT
         customer_id,
         order_number
       FROM fod_jakepaul
      ) A
      JOIN
      (SELECT
         order_number,
         sum(price) AS total_sales
       FROM fld_jakepaul
       GROUP BY order_number
      ) B
        ON A.order_number = B.order_number
    WHERE customer_id IS NOT NULL AND customer_id != 0
    GROUP BY 1
  ) data
WHERE total_orders >= 5
group by 1
ORDER BY 1
;




/*
  Median time between sales for customers with EXACTLY 5 orders
 */

-- Get customers with exactly 5 orders
SELECT
  cid,
  count(orderdate) as num_orders
FROM
(
  select
    A.customer_id cid,
    A.created_at orderdate
  FROM
    (SELECT customer_id, order_number, created_at
      FROM kevin_ip.fod_jakepaul
    ) A
    JOIN
    (SELECT
      order_number,
      sum(price) as total_sales
      FROM kevin_ip.fld_jakepaul
      GROUP BY order_number
    ) B
    on A.order_number = B.order_number
  WHERE customer_id IS NOT NULL and customer_id != 0
) data
GROUP BY 1
HAVING count(orderdate) = 5
order by 1
;


-- For those customers, rank each order and get the previous order date
SELECT
  customer_id cid,
  created_at,
  total_sales,
  lag(created_at) over (PARTITION BY customer_id ORDER BY created_at) as prev_date,
  lag(total_sales) over (PARTITION BY customer_id ORDER BY created_at) as prev_sales,
  RANK() OVER (PARTITION BY customer_id ORDER BY created_at) AS order_rank
FROM
  (
    SELECT
      customer_id,
      created_at,
      order_number
    FROM kevin_ip.fod_jakepaul
  ) fod
  JOIN
  (
    SELECT
      order_number,
      sum(price) as total_sales
    FROM kevin_ip.fld_jakepaul
    GROUP BY order_number
  ) fld
  on fod.order_number = fld.order_number
WHERE customer_id IN (
  SELECT
    cid
  FROM
  (
    select
      A.customer_id cid,
      A.created_at orderdate
    FROM
      (SELECT customer_id, order_number, created_at
        FROM kevin_ip.fod_jakepaul
      ) A
      JOIN
      (SELECT
        order_number,
        sum(price) as total_sales
        FROM kevin_ip.fld_jakepaul
        GROUP BY order_number
      ) B
      on A.order_number = B.order_number
    WHERE customer_id IS NOT NULL and customer_id != 0
  ) data
  GROUP BY 1
  HAVING count(orderdate) = 5
)
ORDER BY 1
;



/*
  Median time between all orders, for all order counts
 */
  SELECT
    customer_id                cid,
    created_at,
    total_sales,
    lag(created_at)
    OVER (
      PARTITION BY customer_id
      ORDER BY created_at ) AS prev_date,
    lag(total_sales)
    OVER (
      PARTITION BY customer_id
      ORDER BY created_at ) AS prev_sales,
    RANK()
    OVER (
      PARTITION BY customer_id
      ORDER BY created_at ) AS order_rank
  FROM
    (
      SELECT
        customer_id,
        created_at,
        order_number
      FROM kevin_ip.fod_jakepaul
    ) fod
    JOIN
    (
      SELECT
        order_number,
        sum(price) AS total_sales
      FROM kevin_ip.fld_jakepaul
      GROUP BY order_number
    ) fld
      ON fod.order_number = fld.order_number
  WHERE customer_id IN (
    SELECT cid
    FROM
      (
        SELECT
          A.customer_id cid,
          A.created_at  orderdate
        FROM
          (SELECT
             customer_id,
             order_number,
             created_at
           FROM kevin_ip.fod_jakepaul
          ) A
          JOIN
          (SELECT
             order_number,
             sum(price) AS total_sales
           FROM kevin_ip.fld_jakepaul
           GROUP BY order_number
          ) B
            ON A.order_number = B.order_number
        WHERE customer_id IS NOT NULL AND customer_id != 0
      ) data
    GROUP BY 1
    HAVING count(orderdate) >= 5
  )
  ORDER BY 1
;