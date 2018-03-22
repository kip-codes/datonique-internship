/*
Sample rows of data
 */
SELECT extract(year from date_created), extract(month from date_created), date_created
FROM klf.contacts
LIMIT 2;


SELECT *
FROM klf.contacts
WHERE phone1 IS NOT NULL AND address_billing_postal_code IS NOT NULL
  AND EXTRACT(year FROM date_created) = 2018 and EXTRACT(month from date_created) = 3
      AND (EXTRACT(day FROM date_created) >= 5 AND EXTRACT(day from date_created) <= 11)
LIMIT 25;

/* 1/1/18 - 1/7/18 */
CREATE TABLE kevin_ip.lead_source_report_staging AS (
    SELECT
      CASE
        WHEN family_name IS NOT NULL THEN TRIM(BOTH FROM given_name) + ' ' + TRIM(BOTH FROM family_name)
        ELSE TRIM(BOTH FROM given_name)
      END AS "Name"
      , regexp_replace(phone1, '[^0-9]+', '') AS "Phone 1"
      , address_billing_postal_code AS "Postal Code"
      , to_char(date_created::timestamp, 'MM/DD/YYYY HH12:MI:SS PM') AS "DateCreatedPT" -- will need to calc for breakdown
      , salesperson AS "Owner" -- Point of Sales contact
      , NULL AS "Leadsource" -- FIXME
      , NULL AS "Lead Source Category" -- FIXME
      , lead_mode AS "Lead Mode"
      , NULL AS "Search Engine Referrer" -- FIXME
      , "source_/_website" AS "Source / Website"
      , NULL AS "Website/Landing Page" -- FIXME
      , NULL AS "Search Engine" -- FIXME
      , NULL AS "Lead ID" -- FIXME
      , newleadsource AS "New Lead Source"
      , id AS "ID"
      , date_retained AS "Date Retained"
      , retainer_amount AS "Retainer Amount"
      , amount_paid AS "Amount Paid"
      , to_char(to_date(to_char(date_created::timestamp, 'MM/DD/YYYY HH12:MI:SS PM'), 'MM/DD/YYYY'), 'MM/DD/YYYY')
          AS "DateCreated" -- unsure if correct var type
      , to_char(date_created, 'HH12:MI:SS PM') AS "Time" -- unsure if correct var type
      , CASE
          WHEN substring(substring(to_char(date_created, 'HH12:MI:SS PM'),1,2),1,1) = '0'
            THEN substring(substring(to_char(date_created, 'HH12:MI:SS PM'),1,2),2,1)
          ELSE substring(to_char(date_created, 'HH12:MI:SS PM'),1,2)
        END AS "Hour"
      , NULL AS "Month and Year"
      , NULL AS "Year"
      , NULL AS "Month"
      , NULL AS "Day"
      , NULL AS "Week"
      , NULL AS "Weekday"
      , NULL AS "County of Arrest"
      , NULL AS "Court"
      , NULL AS "TimeGroup" -- keep null
      , NULL AS "Id" -- keep null
      , NULL AS "Shift" -- keep null
      , NULL AS "Offense"
      , NULL AS "Spend" -- keep null
      , NULL AS "Radio/TV/Internet"
      , NULL AS "What Station of Website"

    FROM klf.contacts
    -- Custom date range
    WHERE EXTRACT(year FROM date_created) = 2018 and EXTRACT(month from date_created) = 1
      AND (EXTRACT(day FROM date_created) >= 1 AND EXTRACT(day from date_created) <= 7)
);


-- Name
SELECT
  CASE
    WHEN family_name IS NOT NULL THEN TRIM(BOTH FROM given_name) + ' ' + TRIM(BOTH FROM family_name)
    ELSE TRIM(BOTH FROM given_name)
  END AS "Name"
FROM klf.contacts
LIMIT 15;


-- Phone 1
SELECT
  regexp_replace(phone1, '[^0-9]+', '') as "Phone 1"
FROM klf.contacts
LIMIT 15;
-- Cannot guarantee format of phone number (international vs local), so will not truncate


-- Zip code
SELECT
  address_billing_postal_code as zip
FROM klf.contacts
LIMIT 50;


-- Date created PT
SELECT
  date_created
  , to_char(date_created::timestamp, 'MM/DD/YYYY HH12:MI:SS PM') AS "DateCreatedPT" -- will need to calc for breakdown
  , to_timestamp(to_char(date_created::timestamp, 'MM/DD/YYYY HH12:MI:SS PM'), 'MM/DD/YYYY HH12:MI:SS PM') AS "DateCreatedPT" -- will need to calc for breakdown
FROM klf.contacts
LIMIT 15;
-- accept raw timestamp


-- Owner / Sales person
SELECT salesperson
FROM klf.contacts
LIMIT 15;


-- Lead Source Category
-- UNAVAILABLE


-- Lead Mode
SELECT lead_mode
from klf.contacts
LIMIT 15;


-- Search Engine Referrer
-- UNAVAILABLE


-- Source / Website"
-- UNAVAILABLE


-- "Website/Landing Page"
-- UNAVAILABLE


-- "Search Engine"
-- UNAVAILALE


-- "Lead ID"
-- UNAVAILABLE


-- "New Lead Source"
SELECT newleadsource
FROM klf.contacts
LIMIT 15;
-- Returns integer for new lead code
-- missing strings for website leads


-- ID
SELECT id
FROM klf.contacts
LIMIT 15;
-- Unique identifier per contact
-- unsure if PK


-- Date retained
SELECT date_retained
FROM klf.contacts
LIMIT 15;


-- Retainer amount
SELECT retainer_amount
FROM klf.contacts
LIMIT 15;


-- Amount Paid
SELECT amount_paid
FROM klf.contacts
LIMIT 15;


-- Date Created
SELECT date_created::timestamp::date
  , to_char(to_date(to_char(date_created::timestamp, 'MM/DD/YYYY HH12:MI:SS PM'), 'MM/DD/YYYY'), 'MM/DD/YYYY')
  , to_date(to_char(to_date(to_char(date_created::timestamp, 'MM/DD/YYYY HH12:MI:SS PM'), 'MM/DD/YYYY'), 'MM/DD/YYYY'), 'MM/DD/YYYY'
)
FROM klf.contacts
LIMIT 15;
-- Casted to format similarly to the spreadsheet with slashes instead of dashes.

-- Time
SELECT to_char(date_created, 'HH12:MI:SS PM')
FROM klf.contacts
LIMIT 15;


-- Time: hour
SELECT to_char(date_created, 'HH12:MI:SS PM'),
  substring(to_char(date_created, 'HH12:MI:SS PM'),1,2),
  CASE
    WHEN substring(substring(to_char(date_created, 'HH12:MI:SS PM'),1,2),1,1) = '0'
      THEN substring(substring(to_char(date_created, 'HH12:MI:SS PM'),1,2),2,1)
    ELSE substring(to_char(date_created, 'HH12:MI:SS PM'),1,2)
  END AS hour
FROM klf.contacts
LIMIT 15;





SELECT SUM(retainer_amount)
FROM klf.contacts
WHERE EXTRACT(year FROM date_created) = 2018

-- breakdown by month
-- do the same for 2016, 2017