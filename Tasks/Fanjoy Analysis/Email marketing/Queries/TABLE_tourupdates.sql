
DROP TABLE IF EXISTS kevin_ip.jakepaul_tourupdates;
DROP TABLE IF EXISTS kevin_ip.jakepaul_tourupdates_test;


CREATE TABLE kevin_ip.jakepaul_tourupdates
(
  date  VARCHAR(50),
  email  VARCHAR(50),
  name VARCHAR(1)
);

CREATE TABLE kevin_ip.jakepaul_tourupdates_test
(
  date TIMESTAMP,
  email VARCHAR(50),
  name varchar(1)
);


COPY kevin_ip.jakepaul_tourupdates
FROM 's3://kevin-ip-test/Tour_Page_Email_Signups-Sheet1.csv'
CREDENTIALS ''
CSV DELIMITER ',' IGNOREHEADER 1
;



SELECT count(*)
FROM kevin_ip.jakepaul_tourupdates;

SELECT *
from stl_load_errors
ORDER BY starttime DESC
LIMIT 1;