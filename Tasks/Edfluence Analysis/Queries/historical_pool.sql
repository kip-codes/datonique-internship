
/*
  Uses the Users table to retrieve all data, including information for customers altered before the new system.
 */


select
  count(DISTINCT user_id)
from wp_pmpro_memberships_users
where count(DISTINCT user_id) > 1
GROUP BY user_id;

-- Pool data by status
SELECT
  status,
#   l.name,
  count(distinct user_id) as num_customers,
  sum(u.initial_payment) as total_spent_USD
FROM wp_pmpro_memberships_users u
  JOIN wp_pmpro_membership_levels l
    ON u.membership_id = l.id
GROUP BY status
;


-- Using last date of activity, count the customer status changes
SELECT
  date(modified) as last_activity,
  sum(case when status = 'active' then 1 else 0 end) as num_active,
  sum(case when status = 'active' then initial_payment else 0 end) as active_spent,
  sum(case when status = 'inactive' then 1 else 0 end) as num_inactive,
  sum(case when status = 'inactive' then initial_payment else 0 end) as inactive_spent,
  sum(case when status = 'cancelled' then 1 else 0 end) as num_cancelled,
  sum(case when status = 'cancelled' then initial_payment else 0 end) as cancelled_spent,
  sum(case when status = 'changed' then 1 else 0 end) as num_changed,
  sum(case when status = 'changed' then initial_payment else 0 end) as changed_spent,
  sum(case when status = 'admin_cancelled' then 1 else 0 end) as num_admincancel,
  sum(case when status = 'admin_cancelled' then initial_payment else 0 end) as admincancel_spent,
  sum(case when status = 'admin_changed' then 1 else 0 end) as num_adminchange,
  sum(case when status = 'admin_changed' then initial_payment else 0 end) as adminchange_spent
FROM wp_pmpro_memberships_users
GROUP BY date(modified)
;


-- Alternative
SELECT
  date(modified) as last_activity,
  status,
  l.name,
  count(*) as num_customers,
  sum(u.initial_payment) as total_spent_USD
FROM wp_pmpro_memberships_users u
  JOIN wp_pmpro_membership_levels l
    ON u.membership_id = l.id
GROUP BY date(modified), status, l.name
;


SELECT
  count(DISTINCT A.user_id)
FROM
  (
    SELECT DISTINCT user_id
    FROM wp_pmpro_memberships_users
  ) as A
  JOIN
  (
    SELECT DISTINCT user_id
    FROM wp_pmpro_membership_orders
  ) as B
  ON A.user_id = B.user_id
;