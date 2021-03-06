# Spatial-Queries-using-IBM-DB2
Spatial queries using IBM DB2 database as part of course - Theory of Database Systems.

Three datasets have been used here:

1. New York State Health Facility General Information - This includes the address and geolocation of each healthcare facility: 
(Facility ID, Facility Name, Description, Facility Address 1, Facility Address 2,Facility City, Facility State, Facility Zip Code, Facility County Code, Facility County, Facility Latitude, Facility Longitude)

2. Health Facility Certification Information - This includes information on certifications for services and beds for each facility. 
(Facility ID, Facility Name, Description, Attribute Type, Attribute Value, Measure Value, County)

3. The US zip code tabulation areas from US Census Bureau, which contains the boundary of each zip code.  After unzipping the file, following command under db2 command line can be used to find metadata for the format.
        db2se shape_info -fileName tl_2019_us_zcta510.shp
       
        The shapefile has a multipolygon object to represent the boundary of each zip code. 

1. Setting up the database. 

     a. Enable the sample database (or your own database) for spatial support: 
        db2se enable_db sample

     b. Load the zip code area dataset using the import SQL file: 
        db2 -tf import_zip.sql

     c. Create two tables for facilities using the  createfacilititytable.sql (we create two tables, facilityoriginal for original data, and facility with a spatial column).  
        db2 -tf createfacilititytable.sql

     d. Load Health_Facility_General_Information.csv into facilityoriginal using script:
        db2 load from "C:\myfolder\Health_Facility_General_Information.csv" of del MESSAGES load.msg INSERT INTO facilityoriginal

     e. Write a SQL script  facilityinsert.sql to insert data into facility by selecting data from facilityoriginal table and converting  (Latitude, Longitude) attributes into DB2GSE.ST_POINT type with srs_id  1 for geolocation attribute in facility.
 
     f. Create a SQL script createfacilititycertificationtable.sql to create a table:
        facilitycertification (FacilityID, FacilityName, Description, AttributeType, AttributeValue, MeasureValue, County)
        and load the csv file into the table:
        db2 load from "C:\yourpath\Health_Facility_Certification_Information.csv" of del MESSAGES load.msg INSERT INTO facilitycertification

     g. Update the createindexes.sql to add additional indexes besides spatial indexes for the queries below. 
        db2 -tf createindexes.sql

2. Write a query nearester.sql to find closest healthcare facility with an ER room (AttributeValue = 'Emergency Department') from  "2799 Horseblock Road Medford, NY 11763"(40.824369, -72.993983) (latitude, longitude). Please return location and distance in your result. You can use unit 'KILOMETER', 'METER', or 'STATUTE MILE' for distance measurement.

Nearest neighbor search is not directed supported by DB2. You can use ST_BUFFER to create a buffered area (polygon/circle) from a point within a certain distance and search only stores within the buffer. Note that 0.25 degree is roughly 10 miles. For all the datasets, we use spatial reference nad83_srs_1 with srs ID as 1. 
You can find information here on functions such as ST_POINT, ST_BUFFER, ST_WITHIN or ST_CONTAINS, and ST_DISTANCE.
3. Write a query noerzips.sql to find zip codes without any "Emergency Department", neither in their neighboring zip codes.  

4. Drop all indexes and perform the two queries again, and compare the query performance in terms of execution time for above two queries. 
Show your time difference with and without indexes in the result file. 

5. Write SQL queries or stored procedure mergezip.sql to merge zip code areas into large ones with neighboring zip code areas, so that the new population in each merged region (combined zipcodes) is large than the current average population, using the zip code population table in Homework1. For simplicity,  you can remove the duplicates from the population table. 

