/*
These were the queries I ran in Athena to create the modeling database.
In order to run any of the other analysis queries in this project, 
these queries must be run first to create the necessary tables and clean the data for analysis.
*/

-- Making the Complaints table in the nyc311_db database
CREATE EXTERNAL TABLE IF NOT EXISTS nyc311_db.complaints (
  unique_key             int,
  created_date           string,
  closed_date            string,
  agency                 string,
  agency_name            string,
  problem                string,
  problem_detail         string,
  incident_zip           string,
  status                 string,
  resolution_description string,
  borough                string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar'     = '\"'
)
LOCATION 's3://cmse492-dasarkes-nyc311-471112527784-us-east-1-an/raw/complaints/' -- this is where my bucket is
TBLPROPERTIES ('skip.header.line.count'='1');

--Creating the agencies table in the nyc311_db database
CREATE EXTERNAL TABLE IF NOT EXISTS nyc311_db.agencies (
  agency      string,
  agency_name string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar'     = '\"'
)
LOCATION 's3://cmse492-dasarkes-nyc311-471112527784-us-east-1-an/raw/agencies/' 
TBLPROPERTIES ('skip.header.line.count'='1');

--Validation checks:
SELECT * FROM nyc311_db.agencies LIMIT 5;
SELECT * FROM nyc311_db.complaints LIMIT 5;
-- If these queries run successfully and return data, then the tables were created correctly and are ready for analysis.
-- See additional validation queries in warm_ups.sql