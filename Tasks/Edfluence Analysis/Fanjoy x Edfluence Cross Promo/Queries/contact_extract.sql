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
  AND date(user_registered) <= '2018-07-17'
;