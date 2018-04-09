SELECT SUM(price), 'team10' as name
FROM kevin_ip.fld_team10
UNION
SELECT SUM(price), 'jp' as name
FROM kevin_ip.fld_jakepaul
UNION
SELECT SUM(price), 't10 no jp' as name
FROM kevin_ip.fld_team10_nojake
;



SELECT *
FROM fld_team10
WHERE id NOT IN
      (
        SELECT id
        from fld_jakepaul
      )
  AND id NOT IN
      (
        SELECT id
        from fld_team10_nojake
      )
;