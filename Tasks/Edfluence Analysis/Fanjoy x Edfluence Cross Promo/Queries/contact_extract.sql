-- Get emails for active users
select
  DISTINCT trim(lower(user_email)) as email
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

