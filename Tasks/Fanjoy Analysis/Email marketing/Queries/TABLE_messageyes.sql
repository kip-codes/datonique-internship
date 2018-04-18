DROP TABLE IF EXISTS kevin_ip.jakepaul_optin;

CREATE TABLE kevin_ip.jakepaul_optin
(
  USER_ID   varchar(32),
  PHONE_NUMBER  varchar(32),
  OPTED_IN  INTEGER,
  UNSUBSCRIBED  INTEGER,
  TOTAL_ENGAGEMENTS  INTEGER,
  TOTAL_YESES  INTEGER,
  TOTAL_SUCCESSFUL_ORDERS  INTEGER
);

COPY kevin_ip.jakepaul_optin
FROM 's3://kevin-ip-test/jp_initial_csv_dump-user-level-details-73a8c78cdef7-2018-02-13-19-21-37.csv'
CREDENTIALS 'aws_access_key_id=AKIAIZG5DHLMMST6DBWQ;aws_secret_access_key=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'
IGNOREHEADER 1
CSV DELIMITER ','
-- ACCESS_KEY_ID 'AKIAIZG5DHLMMST6DBWQ'
-- SECRET_ACCESS_KEY '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'
;


SELECT count(*)
FROM kevin_ip.jakepaul_optin;