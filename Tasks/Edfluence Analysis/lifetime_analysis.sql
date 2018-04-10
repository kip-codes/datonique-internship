
/*
  Total Buyers
  Total Transactions
  Total Gross Sales - cumulative
  Total Refunds - cumulative
  Total Refund Amount - cumulative
  Net Sales – daily and cumulative

  -- TODO: Net Active Users

  DOES NOT INCLUDE HISTORICAL DATA
 */

SELECT
  A.date,
  A.total_buyers,
  -- TODO: Breakdown by Membership Type
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
  END as user_id,
  last_success
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
ORDER BY last_success
;