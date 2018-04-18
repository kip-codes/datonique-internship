-- Get emails for active users
select
#   id as userID,
#   DISTINCT lower(user_email) as email
  COUNT(DISTINCT lower(user_email))
#   membership_id as membership_level
from wp_users
join
  (
    SELECT distinct
      user_id,
      membership_id
    FROM
      wp_pmpro_memberships_users
    WHERE status = 'active'
  ) AS A
ON wp_users.id = A.user_id
;

