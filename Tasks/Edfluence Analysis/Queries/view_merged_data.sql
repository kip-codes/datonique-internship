
##########################################################################################
/*
  Create subscription_data_old_v2
 */
##########################################################################################


# create table wordpress.subscription_data_old_v2 as
# (
#   select * from wordpress.subscription_data_old
# );
#
# commit;
#
# truncate wordpress.subscription_data_old_v2;
#
# LOAD DATA LOCAL INFILE '/Users/murali/Documents/Personal Docs/Consulting/Datonique/Team10/modified_stripe_payments.csv'
# INTO TABLE wordpress.subscription_data_old_v2
# FIELDS TERMINATED BY ','
# LINES TERMINATED BY '\n'
# ignore 1 lines
# ;


##########################################################################################
/*
  Create Merged Data v1
 */
##########################################################################################

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

DROP VIEW IF EXISTS wordpress.subscription_data_merged;
DROP TABLE IF EXISTS wordpress.subscription_data_merged_v2;
DROP TABLE IF EXISTS wordpress.intermediate_table;



CREATE VIEW wordpress.subscription_data_merged AS
  (
    SELECT *
    FROM
      (
        # Static, old data
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
        # New data
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
          WHERE DATE(o.timestamp) < CURDATE() - 1
        )
      ) data
  )
;


# SELECT *
# from subscription_data_merged
# WHERE date = curdate() - 1
# ORDER BY date desc;

##########################################################################################
/*
  Merged Data v2 after Merged Data has been created
 */
##########################################################################################


create table wordpress.subscription_data_merged_v2 as
(
select distinct date, subscription_name, user_id, email, total, status from wordpress.subscription_data_merged
);

commit;

# Creates an intermediate table that changes the statuses of incorrect successes to cancelled for refunds.
create table wordpress.intermediate_table as
(
  select m.email, m.total, 'cancelled' as status
  from wordpress.subscription_data_merged_v2 m
  join
  (
    select distinct email, total, m.status from wordpress.subscription_data_merged_v2 m
    join payments_stripe_v2 w
    on m.email = w.customer_email
    and m.total = w.amount
    and w.status='Refunded'
    and m.status<>'cancelled'
    order by email
  ) w
    on m.email = w.email
    and m.total = w.total
)
;

commit;

# With the pool of all data (including incorrect fields), join merged_v2 with the intermediate_table (i.e., the fix)
# This will remedy ONLY the old incorrect data.
# merged_v2 contains old (Static) data AND newest data pulled from pmpro_membership_orders
update wordpress.subscription_data_merged_v2 t1
/*select* from wordpress.subscription_data_merged_v2 m*/
join wordpress.intermediate_table t2
on t1.email = t2.email
and t1.total = t2.total
SET t1.status = t2.status # changes all incorrect 'success' to 'cancelled'
;



SELECT date, subscription_name, COUNT(DISTINCT user_id)
FROM subscription_data_merged_v2
WHERE subscription_name is not null
GROUP BY 1,2
ORDER BY date desc
;