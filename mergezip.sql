-- DROP TABLE CSE532.ZIPPOP;

-- CREATE TABLE CSE532.ZIPPOP
--   ( ZIP 			VARCHAR(25) NOT NULL, --zip code duplicates present
--     COUNTY			INT,  
--     GEOID			INT, --can be null
--     ZPOP 			INT --population, can be null
-- 	)COMPRESS YES;


WITH TABLE1 AS (
	SELECT zippop.ZIP, zippop.ZPOP, uszip.ZCTA5CE10, uszip.SHAPE
	FROM cse532.zippop zippop, cse532.uszip uszip
	WHERE zippop.ZIP = uszip.ZCTA5CE10
),

NEIGHBOURS AS (

	SELECT a.ZIP AS zipcode, b.ZCTA5CE10 AS Neighbors, b.ZIPPOP
	FROM TABLE1 a
	JOIN TABLE1 b 
	ON ST_Touches(a.shape, b.shape)
)
SELECT * FROM NEIGHBOURS WHERE NEIGHBOURS.ZIPPOP > AVG(NEIGHBOURS.ZIPPOP);



-- Logic:
-- Find the neighbours and go on merging the populations
-- check if the new population in each merged region (combined zipcodes) is large than the current average population