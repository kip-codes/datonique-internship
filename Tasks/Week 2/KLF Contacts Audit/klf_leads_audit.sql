/*
Sample rows of data
 */
SELECT extract(year from date_created), extract(month from date_created), date_created
FROM klf.contacts
LIMIT 2;

/* 1/1/18 - 1/7/18 */
CREATE TABLE kevin_ip.lead_source_report_staging AS (
    SELECT
      CASE
        WHEN family_name IS NOT NULL THEN TRIM(BOTH FROM given_name) + ' ' + TRIM(BOTH FROM family_name)
        ELSE TRIM(BOTH FROM given_name)
      END AS "Name"
      , NULL AS "Phone 1"
      , NULL AS "Postal Code"
      , NULL AS "DateCreatedPT"
      , NULL AS "Owner"
      , NULL AS "Leadsource"
      , NULL AS "Lead Source Category"
      , NULL AS "Lead Mode"
      , NULL AS "Search Engine Referrer"
      , NULL AS "Source / Website"
      , NULL AS "Website/Landing Page"
      , NULL AS "Search Engine"
      , NULL AS "Lead ID"
      , NULL AS "Lead Source Code"
      , NULL AS "ID"
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
    WHERE EXTRACT(year FROM date_created) = 2018 and EXTRACT(month from date_created) = 1
      AND (EXTRACT(day FROM date_created) >= 1 AND EXTRACT(day from date_created) <= 7)
);

SELECT
  CASE
    WHEN family_name IS NOT NULL THEN TRIM(BOTH FROM given_name) + ' ' + TRIM(BOTH FROM family_name)
    ELSE TRIM(BOTH FROM given_name)
  END AS "Name"
FROM klf.contacts
LIMIT 15;
