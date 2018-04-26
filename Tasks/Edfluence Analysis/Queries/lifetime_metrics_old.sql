
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
    SELECT
      s.id,
      s.user_id,
      s.plan_id,
      s.course_id,
      s.name,
      s.stripe_id,
      s.stripe_plan,
      s.quantity,
      s.trial_ends_at,
      s.ends_at,
      s.created_at,
      s.updated_at,
      s.deleted_at,
      s.is_refunded,
      p.name            subscription_name,
      p.amount,
      lower(u.email) AS email
    FROM wordpress.subscriptions_old s
      LEFT JOIN wordpress.plans_old p
        ON s.plan_id = p.id
      LEFT JOIN wordpress.users_old u
        ON s.user_id = u.id
  );


select COUNT(*)
FROM payments_stripe_v2
where status = 'refunded'
;


SELECT *
FROM subscription_data_merged
where email IN (
  SELECT DISTINCT customer_email
  FROM payments_stripe_v2
);

select
  email,
  amount,
  count(email)
FROM subscription_data_old
GROUP BY email, amount
;

SELECT distinct
  customer_email,
  amount,
  status
FROM payments_stripe_v2
WHERE status = 'refunded'
;



#################################################################################
#################################################################################

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
;

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
            date(s.created_at) AS date,
            CASE
            WHEN s.subscription_name = 'Roadmap'
              THEN 'Road Map'
            ELSE s.subscription_name
            END              AS subscription_name,
            s.id               AS order_id,
            s.user_id          AS user_id,
            s.email            AS email,
            s.amount           AS total,
            CASE
            WHEN lower(s.stripe_plan) NOT LIKE '%test%' AND (s.deleted_at = 0 OR s.deleted_at IS NULL) AND s.is_refunded = 0
              THEN 'success'
            ELSE 'cancelled'
            END              AS status
          FROM subscription_data_old s
        )
        UNION
        (
          SELECT
            DATE(o.timestamp) AS date,
            l.name            AS subscription_name,
            o.id              AS order_id,
            o.user_id         AS user_id,
            u.user_email      AS email,
            o.total           AS total,
            o.status          AS status
          FROM wp_pmpro_membership_orders o
            JOIN wp_pmpro_membership_levels l
              ON o.membership_id = l.id
            JOIN wp_users u
              ON o.user_id = u.id
        )
      ) data
  )
;

commit;

SELECT email
FROM subscription_data_merged;


SELECT *
FROM wordpress.wp_pmpro_memberships_users;

SELECT count(payment_transaction_id)
FROM wp_pmpro_membership_orders;

SELECT *
FROM subscription_data_old_v2;

##################################################################################################
##################################################################################################


/*
  Compare merged data with stripe payments csv on stripe_id
 */





###################################################################################################
###################################################################################################


(
select
  /*date(timestamp) as "date",*/
  'Total' as name,
  count(distinct user_id) as users,
  count(distinct case when status='success' then user_id else 0 end) as active_users,
  count(distinct case when status='cancelled' then user_id else 0 end) as refunds,
  sum(case when status='success' then 1 else 0 end) as transactions,
  sum(case when status='success' then total else 0 end) as gross_sales,
  sum(case when status='cancelled' then total else 0 end) as refunded_amount
FROM wordpress.subscription_data_merged_v2
WHERE subscription_name is not null
# group by 1
)
union
(
select
  /*date(timestamp) as "date",*/
  subscription_name,
  count(distinct user_id) as users,
  count(distinct case when status='success' then user_id else 0 end) as active_users,
  count(distinct case when status='cancelled' then user_id else 0 end) as refunds,
  sum(case when status='success' then 1 else 0 end) as transactions,
  sum(case when status='success' then total else 0 end) as gross_sales,
  sum(case when status='cancelled' then total else 0 end) as refunded_amount
FROM wordpress.subscription_data_merged_v2
WHERE subscription_name IS NOT NULL
group by 1
);




########################################################
########################################################



SELECT *
FROM payments_stripe_v2;

SELECT *
from subscriptions_old;

SELECT *
FROM subscription_data_old;


SELECT *
FROM subscription_data_old_v2;


SELECT *
FROM subscription_data_merged;

SELECT COUNT(*)
from subscription_data_merged
where status = 'cancelled';

select *
from subscription_data_merged_v2;

SELECT COUNT(*)
from subscription_data_merged_v2
where status = 'cancelled';

#########################################################
#########################################################

select distinct subscription_name
FROM subscription_data_merged_v2;


SELECT COUNT(*)
FROM subscription_data_merged_v2
WHERE subscription_name is not null and status = 'success'
;

SELECT date, subscription_name, COUNT(DISTINCT user_id)
FROM subscription_data_merged_v2
WHERE subscription_name is not null
GROUP BY 1,2
;