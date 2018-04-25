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
;

SELECT * FROM wp_pmpro_membership_orders;

SELECT * from wp_pmpro_membership_orders where status = 'refunded';


/*
  Total Buyers
 */
SELECT
  COUNT(distinct user_id)
FROM wp_pmpro_membership_orders
WHERE status not like '%refunded%' -- refunded is a test entry
;


/*
  Total Transactions
 */
SELECT
  COUNT(*)
FROM wp_pmpro_membership_orders
WHERE status not like '%refunded%'  -- refunded is a test entry
;


/*
  Total Gross Sales – daily and cumulative
 */

-- Group by date
SELECT
  date(timestamp) as date,
  SUM(total) as gross_sales_USD
FROM wp_pmpro_membership_orders
GROUP BY date(timestamp)
ORDER BY date(timestamp)
;



/*
  Total Refunds – daily and cumulative
 */
SELECT
  date(timestamp) as date,
  COUNT(*) as count
FROM wp_pmpro_membership_orders
WHERE status like 'cancelled'
GROUP BY date(timestamp)
ORDER BY date(timestamp)
;

/*
  Total Refunds Amount
 */

SELECT
  date(timestamp) as date,
  SUM(total) as total_refunds_USD
FROM wp_pmpro_membership_orders
WHERE status like 'cancelled'
GROUP by date(timestamp)
ORDER BY date(timestamp)
;


/*
  Net Active – assuming LTD
 */


-- only has new data
SELECT
  date(timestamp) as date,
  COUNT(DISTINCT user_id) AS active_members
FROM wp_pmpro_membership_orders
WHERE status like 'SUCCESS'
GROUP BY date(timestamp)
ORDER BY date(timestamp)
;


SELECT
  status,
  COUNT(*) as count
FROM wp_pmpro_memberships_users
GROUP BY status
;

-- includes historical data
SELECT
  COUNT(DISTINCT user_id)
FROM wp_pmpro_memberships_users
WHERE status like 'active'
;


-- Get last success timestamp for all members from new membership orders data
SELECT
  user_id,
  status,
  max(timestamp) as last_success
FROM wp_pmpro_membership_orders
WHERE status like 'success'
GROUP BY user_id, status
;


-- Get last refund timestamp for all members from new membership order data
SELECT
  user_id,
  status,
  max(timestamp) as last_refund
FROM wp_pmpro_membership_orders
WHERE status like 'cancelled'
GROUP BY user_id, status
;

-- Compare last success to last refund
-- Missing IDs from cancelled set imply link to historical data
SELECT
#   COUNT(DISTINCT A.user_id) AS num_active
  CASE
    WHEN user_id_cancelled IS NULL
      THEN user_id_success
    ELSE  -- user_id_cancelled exists
      CASE
        WHEN last_success > last_refund
          then user_id_success
      END
  END as user_id
FROM
  (
    SELECT
      user_id AS user_id_success,
      status,
      max(timestamp) as last_success
    FROM wp_pmpro_membership_orders
    WHERE status like 'success'
    GROUP BY user_id, status
  ) AS A
  LEFT JOIN
  (
    SELECT
      user_id as user_id_cancelled,
      status,
      max(timestamp) as last_refund
    FROM wp_pmpro_membership_orders
    WHERE status like 'cancelled'
    GROUP BY user_id, status
  ) AS B
  on A.user_id_success = B.user_id_cancelled
;


-- NO REFUNDS with new data
SELECT *
FROM
  (
    SELECT
      user_id AS user_id_success,
      status,
      max(timestamp) as last_success
    FROM wp_pmpro_membership_orders
    WHERE status like 'success'
    GROUP BY user_id, status
  ) AS A
  JOIN
  (
    SELECT
      user_id as user_id_cancelled,
      status,
      max(timestamp) as last_refund
    FROM wp_pmpro_membership_orders
    WHERE status like 'cancelled'
    GROUP BY user_id, status
  ) AS B
  on A.user_id_success = B.user_id_cancelled
  where last_refund > last_success
;



/*
  Monthly Breakdown by User Type

  User Types:

  1. Inner Circle (id 1)
  2. Inner Circle JHA (id 2)
  3. Road Map (id 3)
  4. Roadmap JHA (id 4)
 */

SELECT
  date(timestamp) as date,
  CASE
    WHEN membership_id = 1 THEN count(distinct user_id)
    else 0
  END AS "Inner Circle",
  CASE
    WHEN membership_id = 2 THEN count(distinct user_id)
    else 0
  END AS "Inner Circle JHA",
  CASE
    WHEN membership_id = 3 THEN count(distinct user_id)
    else 0
  END AS "Roadmap",
  CASE
    WHEN membership_id = 4 THEN count(distinct user_id)
    else 0
  END AS "Roadmap JHA",
  count(distinct user_id) as total_success,
  sum(total) as gross_sales_USD
FROM wp_pmpro_membership_orders
WHERE status like 'success'
GROUP BY date(timestamp), membership_id
ORDER BY date
;


SELECT *
FROM wp_pmpro_memberships_users
LIMIT 5
;

SELECT *
FROM wp_pmpro_membership_orders
WHERE user_id = 17;

select user_id, status, total
FROM wp_pmpro_membership_orders
WHERE user_id = 6408
;


SELECT *
FROM wp_users
LIMIT 5
;

SELECT *
FROM wp_pmpro_membership_orders
LIMIT 5
;


CREATE TABLE wordpress.plans_old
(
  id INT(10) UNSIGNED AUTO_INCREMENT,
  plan_id VARCHAR(255),
  course_id INT(11),
  name VARCHAR(255),
  amount DECIMAL(8,2),
  recurring TINYINT(1),
  interv VARCHAR(255),
  interval_count INT(11),
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  deleted_at TIMESTAMP NULL,
  PRIMARY KEY (id)
);


CREATE TABLE wordpress.transactions_old
(
  id INT(10) UNSIGNED AUTO_INCREMENT,
  user_id int(11),
  course_id int(11),
  plan_id int(11),
  interv varchar(255),
  interval_count int(11),
  subscription_id int(11),
  transaction_id varchar(255),
  amount decimal(8,2),
  is_refunded tinyint(1),
  amount_refunded DECIMAL(8,2),
  refund_processor int(11),
  refund_reason VARCHAR(255),
  refund_status VARCHAR(255),
  refund_date datetime,
  source_id VARCHAR(255),
  source_object VARCHAR(255),
  source_brand VARCHAR(255),
  source_country VARCHAR(255),
  source_exp_month varchar(255),
  source_exp_year VARCHAR(255),
  source_funding varchar(255),
  source_last4 VARCHAR(255),
  status VARCHAR(255),
  created_at timestamp NULL,
  updated_at timestamp NULL,
  deleted_at timestamp NULL,
  PRIMARY KEY (id)
);


CREATE TABLE wordpress.users_old
(
  id int(10) unsigned AUTO_INCREMENT,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  address VARCHAR(255),
  city VARCHAR(255),
  state varchar(255),
  zip VARCHAR(255),
  country VARCHAR(255),
  email VARCHAR(255),
  facebook_id VARCHAR(255),
  facebook_token VARCHAR(255),
  profile_pic VARCHAR(255),
  is_admin tinyint(1),
  is_creator tinyint(1),
  is_affiliate tinyint(1),
  is_suspended tinyint(1),
  password VARCHAR(255),
  api_token VARCHAR(60),
  remember_token VARCHAR(100),
  affiliate_code VARCHAR(255),
  referral_code VARCHAR(255),
  w9 TINYINT(1),
  suspension_reason text,
  stripe_id VARCHAR(255),
  card_brand VARCHAR(255),
  card_last_four VARCHAR(255),
  trial_ends_at timestamp null,
  created_at timestamp null,
  updated_at timestamp null,
  deleted_at timestamp null,
  has_forum tinyint(1),
  PRIMARY KEY (id)
);


LOAD DATA LOCAL INFILE '/Users/kevinip/Documents/POST GRAD/TEMP : INTERNSHIPS/Datonique/Tasks/Old Edfluence Analysis/Data Extracts/edflu_plans.csv'
INTO TABLE wordpress.plans_old
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;


select *
FROM plans_old;


LOAD DATA LOCAL INFILE '/Users/kevinip/Documents/POST GRAD/TEMP : INTERNSHIPS/Datonique/Tasks/Old Edfluence Analysis/Data Extracts/edflu_transactions.csv'
INTO TABLE wordpress.transactions_old
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;


SELECT *
FROM transactions_old;


LOAD DATA LOCAL INFILE '/Users/kevinip/Documents/POST GRAD/TEMP : INTERNSHIPS/Datonique/Tasks/Old Edfluence Analysis/Data Extracts/edflu_users.csv'
INTO TABLE wordpress.users_old
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;


SELECT *
FROM users_old;



CREATE TABLE wordpress.payments_stripe
(
  id VARCHAR(255),
  description VARCHAR(255),
  created_utc TIMESTAMP NULL,
  amount DECIMAL(8,2),
  amount_refunded DECIMAL(8,2),
  currency VARCHAR(10),
  converted_amt DECIMAL(8,2),
  converted_amt_refunded DECIMAL(8,2),
  fee DECIMAL(8,2),
  tax DECIMAL(8,2),
  converted_currency VARCHAR(10),
  mode VARCHAR(30),
  status VARCHAR(30),
  statement_descriptor VARCHAR(255),
  customer_id VARCHAR(255),
  customer_description VARCHAR(255),
  customer_email VARCHAR(255),
  captured VARCHAR(30),
  card_id VARCHAR(255),
  card_last4 int(10),
  card_brand VARCHAR(30),
  card_funding VARCHAR(30),
  card_exp_month int(2),
  card_exp_year int(5),
  card_name VARCHAR(255),
  card_address_line1 VARCHAR(255),
  card_address_line2 VARCHAR(255),
  card_address_city VARCHAR(255),
  card_address_state VARCHAR(255),
  card_address_country VARCHAR(255),
  card_address_zip VARCHAR(255),
  card_issue_country VARCHAR(30),
  card_fingerprint VARCHAR(255),
  card_cvc_status VARCHAR(30),
  card_avs_zip_status VARCHAR(255),
  card_avs_line1_status VARCHAR(255),
  card_tokenization_method VARCHAR(255),
  disputed_amt DECIMAL(8,2),
  dispute_status VARCHAR(255),
  dispute_reason VARCHAR(255),
  dispute_date_utc TIMESTAMP null,
  dispute_evidence_due_utc TIMESTAMP null,
  invoice_id VARCHAR(255),
  payment_source_type VARCHAR(30),
  destination VARCHAR(255),
  transfer VARCHAR(255),
  transfer_group VARCHAR(255),
  PRIMARY KEY (id)
);



LOAD DATA LOCAL INFILE '/Users/kevinip/Documents/POST GRAD/TEMP : INTERNSHIPS/Datonique/Tasks/Old Edfluence Analysis/Data Extracts/payments_noheader.csv'
INTO TABLE wordpress.payments_stripe
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

select count(distinct customer_id)
FROM payments_stripe;


CREATE TABLE wordpress.subscriptions_old
(
  id int(10) unsigned AUTO_INCREMENT,
  user_id int(11),
  plan_id int(11),
  course_id int(11),
  name VARCHAR(255),
  stripe_id VARCHAR(255),
  stripe_plan VARCHAR(255),
  quantity int(11),
  trial_ends_at timestamp null,
  ends_at timestamp null,
  created_at timestamp null,
  updated_at timestamp null,
  deleted_at timestamp null,
  is_refunded smallint(6),
  PRIMARY KEY (id)
);

LOAD DATA LOCAL INFILE '/Users/kevinip/Documents/POST GRAD/TEMP : INTERNSHIPS/Datonique/Tasks/Old Edfluence Analysis/Data Extracts/edflu_subscriptions.csv'
INTO TABLE wordpress.subscriptions_old
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

select DISTINCT plan_id from subscriptions_old;

select * from plans_old;

SELECT count(*)
FROM subscriptions_old
WHERE plan_id != 1 and plan_id != 2 and plan_id != 6 and plan_id != 0
  AND is_refunded = 1;


SELECT * from subscriptions_old;

SELECT * from users_old;

SELECT * from payments_stripe;

SELECT * FROM subscription_data_old;


