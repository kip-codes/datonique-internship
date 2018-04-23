
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



-- LIFETIME METRICS
(
select
/*date(timestamp) as "date",*/
"Total" as name,
count(distinct user_id) as users,
count(id) as transactions,
sum(case when status='success' then total else 0 end) as gross_sales,
sum(case when status='cancelled' then total else 0 end) as refunded_amount,
(sum(case when status='success' then total else 0 end)-sum(case when status='cancelled' then total else 0 end)) as net_sales,
sum(case when status='cancelled' then 1 else 0 end) as refunds,
sum(case when status='success' then 1 else 0 end) as active_users
FROM wordpress.wp_pmpro_membership_orders
/*##group by 1;*/
)
union
(
select
/*date(timestamp) as "date",*/
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
group by 1
)