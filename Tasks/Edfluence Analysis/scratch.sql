SELECT *
FROM wordpress.wp_pmpro_membership_orders;


SELECT *
FROM wordpress.wp_pmpro_membership_levels;


SELECT
  DISTINCT STATUS,
  COUNT(*)
FROM wp_pmpro_memberships_users
group by status
;


SELECT
  status,
  COUNT(*) as count
FROM wp_pmpro_memberships_users
GROUP BY status
;

SELECT *
FROM wp_pmpro_memberships_users
;

select *
from wp_users
;

SELECT *
FROM wp_pmpro_membership_orders
WHERE
  user_id = 6826
  or user_id = 6843
  or user_id = 6851
  or user_id = 6852
ORDER BY user_id
;


SELECT *
FROM wp_pmpro_membership_orders
WHERE date(timestamp) = '2018-02-04'