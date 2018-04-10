
/*
  Total Buyers
  Total Transactions
  Total Gross Sales - cumulative
  Total Refunds - cumulative
  Total Refund Amount - cumulative
  Net Sales – daily and cumulative
  Net Active

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