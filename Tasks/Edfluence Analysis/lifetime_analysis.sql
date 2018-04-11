
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
  SUM(A.num_success), -- transaction
  SUM(B.num_canceled), -- transaction
  SUM(A.total_buyers), -- customer
  SUM(B.total_refunds), -- customer
  SUM(A.num_success + B.num_canceled) as total_transactions,
  -- TODO: running total of members (needs to account for refunds)
  SUM(A.`Inner Circle Success`),
  SUM(A.`Inner Circle Gross`),
  SUM(A.`Inner Circle JHA Success`),
  SUM(A.`Inner Circle JHA Gross`),
  SUM(A.`Roadmap Success`),
  SUM(A.`Roadmap Gross`),
  SUM(A.`Roadmap JHA Success`),
  SUM(A.`Roadmap JHA Gross`),
  SUM(B.`Inner Circle Refunded`),
  SUM(B.`Inner Circle Refund Amount`),
  SUM(B.`Inner Circle JHA Refunded`),
  SUM(B.`Inner Circle JHA Refund Amount`),
  SUM(B.`Roadmap Refunded`),
  SUM(B.`Roadmap Refund Amount`),
  SUM(B.`Roadmap JHA Refunded`),
  SUM(B.`Roadmap JHA Refund Amount`),
  SUM(A.total_gross_USD),
  SUM(B.total_refunds_USD),
  SUM(A.total_gross_USD - B.total_refunds_USD) AS net_sales_USD
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
GROUP BY date
;




/*
----------------------------------------------------------------
----------------------------------------------------------------
*/

(
select
date(timestamp) as "date",
"Total" as name,
count(distinct user_id) as users,
count(id) as transactions,
sum(case when status='success' then total else 0 end) as gross_sales,
sum(case when status='cancelled' then total else 0 end) as refunded_amount,
(sum(case when status='success' then total else 0 end)-sum(case when status='cancelled' then total else 0 end)) as net_sales,
sum(case when status='cancelled' then 1 else 0 end) as refunds,
sum(case when status='success' then 1 else 0 end) as active_users
FROM wordpress.wp_pmpro_membership_orders
group by 1,2
)
union
(
select
date(timestamp) as "date",
l.name,
count(distinct user_id) as users,
count(o.id) as transactions,
sum(case when status='success' then total else 0 end) as gross_sales,
sum(case when status='cancelled' then total else 0 end) as refunded_amount,
(sum(case when status='success' then total else 0 end)-sum(case when status='cancelled' then total else 0 end)) as net_sales,
sum(case when status='cancelled' then 1 else 0 end) as refunds,
sum(case when status='success' then 1 else 0 end) as active_users
FROM wordpress.wp_pmpro_membership_orders o
join wordpress.wp_pmpro_membership_levels l
on o.membership_id = l.id
group by 1,2
)
;


SELECT
  COUNT(DISTINCT user_id) as users
FROM wp_pmpro_membership_orders
;

-- Last day of activity
SELECT DISTINCT
  user_id,
  status,
  MAX(timestamp) as last_activity
FROM wp_pmpro_membership_orders
GROUP BY user_id, status
;


-- Extract active users
SELECT
  date(last_activity),
  COUNT(user_id) as active_users
FROM (
  SELECT DISTINCT
  user_id,
  status,
  MAX(timestamp) as last_activity
FROM wp_pmpro_membership_orders
GROUP BY user_id, status
) as A
WHERE status like 'success'
GROUP BY date(last_activity)
;