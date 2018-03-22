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
      , date_created AS "DateCreatedPT"
      , salesperson AS "Owner" -- Point of Sales contact
      , NULL AS "Leadsource" -- FIXME
      , NULL AS "Lead Source Category" -- FIXME
      , lead_mode AS "Lead Mode"
      , NULL AS "Search Engine Referrer" -- FIXME
      , "source_/_website" AS "Source / Website"
      , NULL AS "Website/Landing Page" -- FIXME
      , NULL AS "Search Engine" -- FIXME
      , NULL AS "Lead ID" -- FIXME
      , NULL AS "New Lead Source" -- FIXME
      , id AS "ID"
      , NULL AS "Date Retained"
      , NULL AS "Retainer Amount"
      , NULL AS "Downpay"
      , NULL AS "Type"
      , NULL AS "DateCreated"
      , NULL AS "Time"
      , NULL AS "Hour"
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
-- UNAVAILABLE


-- ID
SELECT id
FROM klf.contacts
LIMIT 15;
-- Unique identifier per contact
-- unsure if PK


