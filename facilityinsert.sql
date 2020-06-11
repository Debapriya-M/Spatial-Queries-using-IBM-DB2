INSERT INTO cse532.facility (
	FacilityID, 
	FacilityName, 
	Description, 
	Address1, 
	Address2, 
	City, 
	State, 
	ZipCode, 
	CountyCode, 
	County, 
	Geolocation)
SELECT 
	FacilityID, 
	FacilityName, 
	Description, 
	Address1, 
	Address2, 
	City, 
	State, 
	ZipCode, 
	CountyCode, 
	County, 
	db2gse.st_point(Longitude, Latitude, 1) 
	FROM cse532.facilityoriginal;

reorg table cse532.facility;