/*
This SQL script contains a series of queries designed to analyze the complaints data in the 'nyc311_db' database,
and to explore its structure and content. 
The queries include counting the total number of complaints, finding the earliest and latest complaint dates, 
identifying the top agencies receiving complaints, and analyzing the distribution of complaints by borough and problem type. 
Additionally, a join query is included to link complaints with their corresponding agency names for a more comprehensive analysis.
If these queries succeed, then that means the database is properly set up and contains the expected data.
*/



SELECT COUNT(*) AS n_complaints
FROM nyc311_db.complaints;
-- This query counts the total number of complaints in the 'complaints' table of the 'nyc311_db' database. The expected result is 200,000 (as a single number).
SELECT 
  MIN(created_date) AS earliest,
  MAX(created_date) AS latest
FROM nyc311_db.complaints;
-- this query will return the earliest and latest dates in the 'complaints' table. The expected result is: 2026-01-29 08:18:28     2026-03-21 02:24:50
SELECT agency, COUNT(*) AS n
FROM nyc311_db.complaints
GROUP BY agency
ORDER BY n DESC
LIMIT 10;
/*
this query groups the complaints by the 'agency' column, counts the number of complaints for each agency, and orders the results in descending order of complaint count. It then limits the output to the top 10 agencies.
expected result:
#
#	agency	n
1	NYPD	71182
2	HPD	59457
3	DSNY	23321
4	DOT	18838
5	DEP	9880
6	DOB	5266
7	DPR	3802
8	DOHMH	3521
9	TLC	1703
10	DHS	1163
*/

SELECT borough, problem, COUNT(*) AS n
FROM nyc311_db.complaints
GROUP BY borough, problem
ORDER BY n DESC
LIMIT 20;
/*
This query groups the complaints by both 'borough' and 'problem', counts the number of complaints 
#	agency	n
1	NYPD	71182
2	HPD	59457
3	DSNY	23321
4	DOT	18838
5	DEP	9880
6	DOB	5266
7	DPR	3802
8	DOHMH	3521
9	TLC	1703
10	DHS	1163
*/

SELECT 
  c.agency,
  a.agency_name,
  COUNT(*) AS n
FROM nyc311_db.complaints AS c
JOIN nyc311_db.agencies AS a
  ON c.agency = a.agency
GROUP BY c.agency, a.agency_name
ORDER BY n DESC;
/*
#	agency	agency_name	n
1	NYPD	New York City Police Department	71182
2	HPD	Department of Housing Preservation and Development	59457
3	DSNY	Department of Sanitation	23321
4	DOT	Department of Transportation	18838
5	DEP	Department of Environmental Protection	9880
6	DOB	Department of Buildings	5266
7	DPR	Department of Parks and Recreation	3802
8	DOHMH	Department of Health and Mental Hygiene	3521
9	TLC	Taxi and Limousine Commission	1703
10	DHS	Department of Homeless Services	1163
11	DCWP	Department of Consumer and Worker Protection	952
12	EDC	Economic Development Corporation	545
13	OOS	Office of the Sheriff	216
14	DOE	Department of Education	147
15	OTI	Office of Technology and Innovation	7
*/