
/*
  Total Buyers -- Distinct CUSTID for that day
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
  A.num_success, -- transaction
  B.num_canceled, -- transaction
  A.total_buyers, -- customer
  B.total_refunds, -- customer
  A.num_success + B.num_canceled as total_transactions,
  -- TODO: running total of members (needs to account for refunds)
  A.`Inner Circle Success`,
  A.`Inner Circle Gross`,
  A.`Inner Circle JHA Success`,
  A.`Inner Circle JHA Gross`,
  A.`Roadmap Success`,
  A.`Roadmap Gross`,
  A.`Roadmap JHA Success`,
  A.`Roadmap JHA Gross`,
  B.`Inner Circle Refunded`,
  B.`Inner Circle Refund Amount`,
  B.`Inner Circle JHA Refunded`,
  B.`Inner Circle JHA Refund Amount`,
  B.`Roadmap Refunded`,
  B.`Roadmap Refund Amount`,
  B.`Roadmap JHA Refunded`,
  B.`Roadmap JHA Refund Amount`,
  A.total_gross_USD,
  B.total_refunds_USD,
  A.total_gross_USD - B.total_refunds_USD AS net_sales_USD
FROM
  (
    SELECT
      date(timestamp) as date,
      CASE
        WHEN membership_id = 1 THEN count(distinct user_id)
        else 0
      END AS "Inner Circle Success",
      CASE
        WHEN membership_id = 2 THEN count(distinct user_id)
        else 0
      END AS "Inner Circle JHA Success",
      CASE
        WHEN membership_id = 3 THEN count(distinct user_id)
        else 0
      END AS "Roadmap Success",
      CASE
        WHEN membership_id = 4 THEN count(distinct user_id)
        else 0
      END AS "Roadmap JHA Success",
      COUNT(distinct user_id) as total_buyers,
      COUNT(distinct id) as num_success,
      CASE
        WHEN membership_id = 1 THEN sum(total)
        else 0
      END AS "Inner Circle Gross",
      CASE
        WHEN membership_id = 2 THEN sum(total)
        else 0
      END AS "Inner Circle JHA Gross",
      CASE
        WHEN membership_id = 3 THEN sum(total)
        else 0
      END AS "Roadmap Gross",
      CASE
        WHEN membership_id = 4 THEN sum(total)
        else 0
      END AS "Roadmap JHA Gross",
      SUM(total) as total_gross_USD
    FROM wp_pmpro_membership_orders
    WHERE status like 'success'
    group by date(timestamp), membership_id
  ) as A
  JOIN
  (
    SELECT
      date(timestamp) as date,
      CASE
        WHEN membership_id = 1 THEN count(distinct user_id)
        else 0
      END AS "Inner Circle Refunded",
      CASE
        WHEN membership_id = 2 THEN count(distinct user_id)
        else 0
      END AS "Inner Circle JHA Refunded",
      CASE
        WHEN membership_id = 3 THEN count(distinct user_id)
        else 0
      END AS "Roadmap Refunded",
      CASE
        WHEN membership_id = 4 THEN count(distinct user_id)
        else 0
      END AS "Roadmap JHA Refunded",
      COUNT(DISTINCT user_id) AS total_refunds,
      COUNT(distinct id) as num_canceled,
      CASE
        WHEN membership_id = 1 THEN sum(total)
        else 0
      END AS "Inner Circle Refund Amount",
      CASE
        WHEN membership_id = 2 THEN sum(total)
        else 0
      END AS "Inner Circle JHA Refund Amount",
      CASE
        WHEN membership_id = 3 THEN sum(total)
        else 0
      END AS "Roadmap Refund Amount",
      CASE
        WHEN membership_id = 4 THEN sum(total)
        else 0
      END AS "Roadmap JHA Refund Amount",
      SUM(total) as total_refunds_USD
    FROM wp_pmpro_membership_orders
    WHERE status like 'cancelled'
    group by date(timestamp), membership_id
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