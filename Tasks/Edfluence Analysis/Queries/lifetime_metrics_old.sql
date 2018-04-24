
SELECT * FROM wordpress.plans_old;

SELECT * from wordpress.transactions_old;

SELECT * FROM wordpress.subscriptions_old;

SELECT * FROM wordpress.users_old;


/*
  Get Total Users that aren't test entries
 */

SELECT count(distinct user_id)
FROM wordpress.subscriptions_old
WHERE lower(stripe_plan) not like '%test%'
;



/*
  Get Active Users, defined by:

  deleted_at not null
  is_refunded false
 */

SELECT count(distinct user_id)
FROM wordpress.subscriptions_old
WHERE
  lower(stripe_plan) not like '%test%'
  and (deleted_at = 0 OR deleted_at IS NULL)
  and is_refunded = 0
;


/*
  Get Total Transactions, defined by:

  distinct subscription ids
 */


SELECT count(distinct id)
FROM wordpress.subscriptions_old
WHERE
  LOWER(stripe_plan) NOT LIKE '%test%'
;


/*
  Get Transactions for refunds, defined by:

  is_refunded 1
 */

SELECT count(distinct id)
FROM wordpress.subscriptions_old
WHERE
  lower(stripe_plan) NOT LIKE '%test%'
  AND is_refunded = 1
;


/*
  Get Gross Sales, calculated by:

  SUM of subscription plans for lines not refunded
 */

SELECT sum(p.amount)
FROM wordpress.subscriptions_old s
  JOIN wordpress.plans_old p
    ON s.plan_id = p.id
WHERE
  LOWER(stripe_plan) NOT LIKE '%test%'
  AND is_refunded = 0
;


/*
  Get Refunded Amount, calculated by:

  SUM of subscription plans for lines is_refunded = 1
 */

SELECT sum(p.amount)
FROM wordpress.subscriptions_old s
  JOIN wordpress.plans_old p
    ON s.plan_id = p.id
WHERE
  LOWER(stripe_plan) NOT LIKE '%test%'
  AND is_refunded = 1
;


/*
  Get Net Sales, calculated by:

  Net = Gross - Refunds

  -- Done as Customer SQL Query in Tableau
 */



###########################################################################
###########################################################################


CREATE VIEW wordpress.subscription_data_old AS
  (
      SELECT s.*, p.name subscription_name, p.amount, p.recurring, p.interv, p.interval_count
      FROM wordpress.subscriptions_old s
        JOIN wordpress.plans_old p
          ON s.plan_id = p.id
  );


SELECT *
FROM subscription_data_old;

/*
    LIFETIME METRICS
 */

  ## OLD DATA, STATIC
(
SELECT
/*date(timestamp) as "date",*/
'Total OLD' as name,
count(DISTINCT user_id) as total_users,
COUNT(DISTINCT case when lower(stripe_plan) not like '%test%'
  and (deleted_at = 0 OR deleted_at IS NULL)
  and is_refunded = 0 then user_id else 0 end) as active_users,
COUNT(DISTINCT case when LOWER(stripe_plan) NOT LIKE '%test%' AND is_refunded = 1 then user_id else 0 end) as refunds,
count(DISTINCT id) as transactions,
sum(case when LOWER(stripe_plan) NOT LIKE '%test%' AND is_refunded = 0 then amount else 0 end) as gross_sales,
sum(case when LOWER(stripe_plan) NOT LIKE '%test%' AND is_refunded = 1 then amount else 0 end) as refunded_amount
# (sum(case when status='success' then total else 0 end)-sum(case when status='cancelled' then total else 0 end)) as net_sales,

FROM wordpress.subscription_data_old
/*##group by 1;*/
)

UNION

(
SELECT
/*date(timestamp) as "date",*/
subscription_name AS name,
COUNT(DISTINCT user_id) AS total_users,
COUNT(DISTINCT CASE WHEN lower(stripe_plan) not like '%test%'
  and (deleted_at = 0 OR deleted_at IS NULL)
  and is_refunded = 0 THEN user_id ELSE 0 END ) AS active_users,
COUNT(DISTINCT CASE WHEN LOWER(stripe_plan) NOT LIKE '%test%' AND is_refunded = 1 THEN user_id ELSE 0 END ) AS refunds,
COUNT(DISTINCT id) AS transactions,
sum( CASE WHEN LOWER(stripe_plan) NOT LIKE '%test%' AND is_refunded = 0 THEN amount ELSE 0 END ) AS gross_sales,
sum( CASE WHEN LOWER(stripe_plan) NOT LIKE '%test%' AND is_refunded = 1 THEN amount ELSE 0 END ) AS refunded_amount
# (sum(case when status='success' then total else 0 end)-sum(case when status='cancelled' then total else 0 end)) as net_sales,

FROM wordpress.subscription_data_old
GROUP BY 1
)
#
# UNION
#
#     ## NEW DATA
# (
# select
# /*date(timestamp) as "date",*/
# 'Total NEW' as name,
# count(distinct user_id) as users,
# count(distinct case when status='success' then user_id else 0 end) as active_users,
# count(distinct case when status='cancelled' then user_id else 0 end) as refunds,
# count(distinct id) as transactions,
# sum(case when status='success' then total else 0 end) as gross_sales,
# sum(case when status='cancelled' then total else 0 end) as refunded_amount
# # (sum(case when status='success' then total else 0 end)-sum(case when status='cancelled' then total else 0 end)) as net_sales,
#
# FROM wordpress.wp_pmpro_membership_orders
# /*##group by 1;*/
# )
# union
# (
# select
# /*date(timestamp) as "date",*/
# l.name,
# count(distinct user_id) as users,
# count(distinct case when status='success' then user_id else 0 end) as active_users,
# count(distinct case when status='cancelled' then user_id else 0 end) as refunds,
# count(distinct o.id) as transactions,
# sum(case when status='success' then total else 0 end) as gross_sales,
# sum(case when status='cancelled' then total else 0 end) as refunded_amount
# # (sum(case when status='success' then total else 0 end)-sum(case when status='cancelled' then total else 0 end)) as net_sales,
#
# FROM wordpress.wp_pmpro_membership_orders o
# join wordpress.wp_pmpro_membership_levels l
# on o.membership_id = l.id
# group by 1
# );
#





###########################################################################################
###########################################################################################

/*
  Columns needed:

  transaction date
  customer id
  order id
  transaction amount (incoming)
  refund amount (returns)
  active / halted subscription
  membership level

 */

CREATE VIEW wordpress.subscription_data_merged AS
  (
    SELECT *
    FROM
      (
        (
          SELECT
            date(created_at) AS date,
            CASE
            WHEN subscription_name = 'Roadmap'
              THEN 'Road Map'
            ELSE subscription_name
            END              AS subscription_name,
            id               AS order_id,
            user_id          AS user_id,
            amount           AS total,
            CASE
            WHEN lower(stripe_plan) NOT LIKE '%test%' AND (deleted_at = 0 OR deleted_at IS NULL) AND is_refunded = 0
              THEN 'success'
            ELSE 'cancelled'
            END              AS status
          FROM subscription_data_old
        )
        UNION
        (
          SELECT
            DATE(o.timestamp) AS date,
            l.name            AS subscription_name,
            o.id              AS order_id,
            o.user_id         AS user_id,
            o.total           AS total,
            o.status          AS status
          FROM wp_pmpro_membership_orders o
            JOIN wp_pmpro_membership_levels l
              ON o.membership_id = l.id
        )
      ) data
  )
;


SELECT sum(total)
FROM subscription_data_merged;



###################################################################################################
###################################################################################################


(
select
  /*date(timestamp) as "date",*/
  'Total' as name,
  count(distinct user_id) as users,
  count(distinct case when status='success' then user_id else 0 end) as active_users,
  count(distinct case when status='cancelled' then user_id else 0 end) as refunds,
  count(distinct order_id) as transactions,
  sum(case when status='success' then total else 0 end) as gross_sales,
  sum(case when status='cancelled' then total else 0 end) as refunded_amount
FROM wordpress.subscription_data_merged
group by 1
)
union
(
select
  /*date(timestamp) as "date",*/
  subscription_name,
  count(distinct user_id) as users,
  count(distinct case when status='success' then user_id else 0 end) as active_users,
  count(distinct case when status='cancelled' then user_id else 0 end) as refunds,
  count(distinct order_id) as transactions,
  sum(case when status='success' then total else 0 end) as gross_sales,
  sum(case when status='cancelled' then total else 0 end) as refunded_amount
FROM wordpress.subscription_data_merged
group by 1
);