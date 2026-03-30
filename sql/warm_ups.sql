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
