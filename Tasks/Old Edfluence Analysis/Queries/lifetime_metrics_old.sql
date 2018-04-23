
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



-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

CREATE VIEW wordpress.subscription_data_old AS
  (
      SELECT s.*, p.name subscription_name, p.amount, p.recurring, p.interv, p.interval_count
      FROM wordpress.subscriptions_old s
        JOIN wordpress.plans_old p
          ON s.plan_id = p.id
  )