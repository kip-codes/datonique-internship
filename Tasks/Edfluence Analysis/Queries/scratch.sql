SELECT *
FROM wordpress.wp_pmpro_membership_orders;


SELECT *
FROM wordpress.wp_pmpro_membership_levels;


SELECT
  DISTINCT STATUS,
  COUNT(*)
FROM wp_pmpro_memberships_users
group by status
;


SELECT
  status,
  COUNT(*) as count
FROM wp_pmpro_memberships_users
GROUP BY status
;

SELECT *
FROM wp_pmpro_memberships_users
;

select *
from wp_users
;

SELECT *
FROM wp_pmpro_membership_orders
WHERE
  user_id = 6826
  or user_id = 6843
  or user_id = 6851
  or user_id = 6852
ORDER BY user_id
;


SELECT *
FROM wp_pmpro_membership_orders
WHERE date(timestamp) = '2018-02-04'
;

SELECT * FROM wp_pmpro_membership_orders;


/*
  Total Buyers
 */
SELECT
  COUNT(distinct user_id)
FROM wp_pmpro_membership_orders
WHERE status not like '%refunded%' -- refunded is a test entry
;


/*
  Total Transactions
 */
SELECT
  COUNT(*)
FROM wp_pmpro_membership_orders
WHERE status not like '%refunded%'  -- refunded is a test entry
;


/*
  Total Gross Sales – daily and cumulative
 */

-- Group by date
SELECT
  date(timestamp) as date,
  SUM(total) as gross_sales_USD
FROM wp_pmpro_membership_orders
GROUP BY date(timestamp)
ORDER BY date(timestamp)
;



/*
  Total Refunds – daily and cumulative
 */
SELECT
  date(timestamp) as date,
  COUNT(*) as count
FROM wp_pmpro_membership_orders
WHERE status like 'cancelled'
GROUP BY date(timestamp)
ORDER BY date(timestamp)
;

/*
  Total Refunds Amount
 */

SELECT
  date(timestamp) as date,
  SUM(total) as total_refunds_USD
FROM wp_pmpro_membership_orders
WHERE status like 'cancelled'
GROUP by date(timestamp)
ORDER BY date(timestamp)
;


/*
  Net Active – assuming LTD
 */


-- only has new data
SELECT
  date(timestamp) as date,
  COUNT(DISTINCT user_id) AS active_members
FROM wp_pmpro_membership_orders
WHERE status like 'SUCCESS'
GROUP BY date(timestamp)
ORDER BY date(timestamp)
;


SELECT
  status,
  COUNT(*) as count
FROM wp_pmpro_memberships_users
GROUP BY status
;

-- includes historical data
SELECT
  COUNT(DISTINCT user_id)
FROM wp_pmpro_memberships_users
WHERE status like 'active'
;


-- Get last success timestamp for all members from new membership orders data
SELECT
  user_id,
  status,
  max(timestamp) as last_success
FROM wp_pmpro_membership_orders
WHERE status like 'success'
GROUP BY user_id, status
;


-- Get last refund timestamp for all members from new membership order data
SELECT
  user_id,
  status,
  max(timestamp) as last_refund
FROM wp_pmpro_membership_orders
WHERE status like 'cancelled'
GROUP BY user_id, status
;

-- Compare last success to last refund
-- Missing IDs from cancelled set imply link to historical data
SELECT
#   COUNT(DISTINCT A.user_id) AS num_active
  CASE
    WHEN user_id_cancelled IS NULL
      THEN user_id_success
    ELSE  -- user_id_cancelled exists
      CASE
        WHEN last_success > last_refund
          then user_id_success
      END
  END as user_id
FROM
  (
    SELECT
      user_id AS user_id_success,
      status,
      max(timestamp) as last_success
    FROM wp_pmpro_membership_orders
    WHERE status like 'success'
    GROUP BY user_id, status
  ) AS A
  LEFT JOIN
  (
    SELECT
      user_id as user_id_cancelled,
      status,
      max(timestamp) as last_refund
    FROM wp_pmpro_membership_orders
    WHERE status like 'cancelled'
    GROUP BY user_id, status
  ) AS B
  on A.user_id_success = B.user_id_cancelled
;


-- NO REFUNDS with new data
SELECT *
FROM
  (
    SELECT
      user_id AS user_id_success,
      status,
      max(timestamp) as last_success
    FROM wp_pmpro_membership_orders
    WHERE status like 'success'
    GROUP BY user_id, status
  ) AS A
  JOIN
  (
    SELECT
      user_id as user_id_cancelled,
      status,
      max(timestamp) as last_refund
    FROM wp_pmpro_membership_orders
    WHERE status like 'cancelled'
    GROUP BY user_id, status
  ) AS B
  on A.user_id_success = B.user_id_cancelled
  where last_refund > last_success
;



/*
  Monthly Breakdown by User Type

  User Types:

  1. Inner Circle (id 1)
  2. Inner Circle JHA (id 2)
  3. Road Map (id 3)
  4. Roadmap JHA (id 4)
 */

SELECT
  date(timestamp) as date,
  CASE
    WHEN membership_id = 1 THEN count(distinct user_id)
    else 0
  END AS "Inner Circle",
  CASE
    WHEN membership_id = 2 THEN count(distinct user_id)
    else 0
  END AS "Inner Circle JHA",
  CASE
    WHEN membership_id = 3 THEN count(distinct user_id)
    else 0
  END AS "Roadmap",
  CASE
    WHEN membership_id = 4 THEN count(distinct user_id)
    else 0
  END AS "Roadmap JHA",
  count(distinct user_id) as total_success,
  sum(total) as gross_sales_USD
FROM wp_pmpro_membership_orders
WHERE status like 'success'
GROUP BY date(timestamp), membership_id
ORDER BY date
;


SELECT *
FROM wp_pmpro_memberships_users
;

SELECT *
FROM wp_pmpro_membership_orders
WHERE user_id = 17;

select user_id, status, total
FROM wp_pmpro_membership_orders
WHERE user_id = 6408
;


