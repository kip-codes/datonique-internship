-- Get emails for active users
select
#   id as userID,
  DISTINCT trim(lower(user_email)) as email
#   COUNT(DISTINCT lower(user_email))
#   membership_id as membership_level
from wp_users
where id IN
  (
    SELECT distinct
      user_id
    FROM
      wp_pmpro_memberships_users
    WHERE status = 'active'
  )
;
