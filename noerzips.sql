set current function path = current function path, db2gse;

WITH FACILITYWITHATTRIBUTES AS (
	SELECT facility.FacilityID, SUBSTR(facility.ZipCode, 1, 5) as ZipCode, uszip.SHAPE
					FROM cse532.facility facility, cse532.uszip uszip
					WHERE ZipCode = uszip.GEOID10
),
NEIGHBOURS (FacilityID, FormattedZipCode, NEIGHBOURINGZIP) AS (
	SELECT f1.FacilityID, f1.ZipCode, f2.ZipCode
	FROM FACILITYWITHATTRIBUTES f1, FACILITYWITHATTRIBUTES f2
	WHERE 
		ST_touches(f1.SHAPE, f2.SHAPE) = 1
),
WITH_ER (FacilityID, ZipCode) AS (
	SELECT facility.FacilityID, SUBSTR(facility.ZipCode, 1, 5) 
	FROM cse532.facility facility, cse532.facilitycertification facilitycertification
	WHERE 
		facility.FacilityID = facilitycertification.FacilityID and facility.FacilityID AND
		facilitycertification.attributevalue = 'Emergency Department'
)
SELECT SUBSTR(ZipCode, 1, 5) as ZipCode FROM cse532.facility facility 
WHERE SUBSTR(facility.ZipCode, 1, 5) not IN (SELECT ZipCode FROM WITH_ER) AND SUBSTR(facility.ZipCode, 1, 5) IN (SELECT GEOID10 FROM cse532.uszip)
EXCEPT
SELECT FormattedZipCode FROM NEIGHBOURS WHERE NEIGHBOURS.NEIGHBOURINGZIP IN (SELECT ZipCode FROM WITH_ER);



-- The query above takes into account, all the zips. Among the above zips, 2 zips do not have shape. After taking that into consideration, the query results in 208 records.
-- But I have kept the final query for all the zips. 

