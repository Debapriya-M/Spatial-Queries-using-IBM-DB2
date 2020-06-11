set current function path = current function path, db2gse;

WITH R AS (
	SELECT 
	    facility.FacilityID, facility.FacilityName, facility.Geolocation, facilitycertification.AttributeValue
	FROM
	    cse532.facility facility
	INNER JOIN  cse532.facilitycertification facilitycertification
	    ON facility.FacilityID = facilitycertification.FacilityID
),
S AS (
	SELECT * FROM R WHERE R.AttributeValue = 'Emergency Department'
)
SELECT FacilityID, FacilityName, varchar(st_astext(Geolocation), 30) as location, ST_Distance(ST_Point(-72.993983, 40.824369,1), Geolocation, 'STATUTE MILE') as distance
FROM S WHERE ST_Contains(st_buffer(ST_Point(-72.993983, 40.824369,1), '0.25'), Geolocation) = 1 
ORDER BY distance
fetch first 1 rows only;

