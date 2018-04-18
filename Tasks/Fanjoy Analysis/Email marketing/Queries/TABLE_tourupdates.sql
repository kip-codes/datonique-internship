
DROP TABLE IF EXISTS kevin_ip.jakepaul_tourupdates;


CREATE TABLE kevin_ip.jakepaul_tourupdates_test
(
  date  VARCHAR(50),
  email  VARCHAR(50),
  name VARCHAR(1)
);


COPY kevin_ip.jakepaul_tourupdates
FROM 's3://kevin-ip-test/Tour_Page_Email_Signups-Sheet1.csv'
CREDENTIALS 'aws_access_key_id=AKIAIZG5DHLMMST6DBWQ;aws_secret_access_key=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'
CSV DELIMITER ',' IGNOREHEADER 1
;

COPY kevin_ip.jakepaul_tourupdates_test
FROM 's3://kevin-ip/Tour_Page_Email_Signups-Sheet1.csv'
CREDENTIALS 'aws_access_key_id=AKIAIZG5DHLMMST6DBWQ;aws_secret_access_key=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'
CSV DELIMITER ',' IGNOREHEADER 1
;


-- ACCESS_KEY_ID 'AKIAIZG5DHLMMST6DBWQ'
-- SECRET_ACCESS_KEY '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'



SELECT count(*)
FROM kevin_ip.jakepaul_tourupdates;

SELECT count(*)
FROM kevin_ip.jakepaul_tourupdates_test;


SELECT *
from stl_load_errors
ORDER BY starttime DESC
LIMIT 1;