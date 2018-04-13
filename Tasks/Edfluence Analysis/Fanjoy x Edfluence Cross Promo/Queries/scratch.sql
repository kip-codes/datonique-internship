
-- Get all active users
SELECT
  user_id
FROM
  wp_pmpro_memberships_users
WHERE status = 'active'
;

SELECT * FROM wp_users;

-- Get emails for active users
select
  id as userID,
  user_email as email,
  membership_id as membership_level
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