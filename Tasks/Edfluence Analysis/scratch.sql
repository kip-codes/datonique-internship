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


-- Get first success timestamp for all members from new membership orders data
SELECT
  user_id,
  status,
  min(timestamp) as first_success
FROM wp_pmpro_membership_orders
WHERE status like 'success'
GROUP BY user_id, status
;
