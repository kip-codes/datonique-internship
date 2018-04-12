
/*
  Uses the Users table to retrieve all data, including information for customers altered before the new system.
 */


select * from wp_pmpro_memberships_users;

-- Pool data by status
SELECT
  status,
  count(*) as num_customers,
  sum(u.initial_payment) as total_spent_USD
FROM wp_pmpro_memberships_users u
  JOIN wp_pmpro_membership_levels l
    ON u.membership_id = l.id
GROUP BY status
;


-- Using last date of activity, count the customer status changes
SELECT
  modified as last_activity,
  sum(case when status = 'active' then 1 else 0 end) as num_active,
  sum(case when status = 'inactive' then 1 else 0 end) as num_inactive,
  sum(case when status = 'cancelled' then 1 else 0 end) as num_cancelled,
  sum(case when status = 'changed' then 1 else 0 end) as num_changed,
  sum(case when status = 'admin_cancelled' then 1 else 0 end) as num_admincancel,
  sum(case when status = 'admin_changed' then 1 else 0 end) as num_adminchange
FROM wp_pmpro_memberships_users
GROUP BY modified