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

/*
  Net Sales – daily and cumulative

  DOES NOT INCLUDE HISTORICAL DATA
 */

-- success minus refunds

SELECT
  A.date,
  A.total_buyers,
  A.num_success,
  A.total_gross_USD,
  B.num_canceled,
  A.num_success + B.num_canceled as total_transactions,
  B.total_refunds_USD,
  A.total_gross_USD - B.total_refunds_USD AS net_sales_USD
FROM
  (
    SELECT
      date(timestamp) as date,
      COUNT(distinct user_id) as total_buyers,
      COUNT(*) as num_success,
      SUM(total) as total_gross_USD
    FROM wp_pmpro_membership_orders
    WHERE status like 'success'
    group by date(timestamp)
  ) as A
  JOIN
  (
    SELECT
      date(timestamp) as date,
      COUNT(*) as num_canceled,
      SUM(total) as total_refunds_USD
    FROM wp_pmpro_membership_orders
    WHERE status like 'cancelled'
    group by date(timestamp)
  ) as B
  ON A.date = B.date
;