/*
I was given a buggy query that tried to calculate the average resolution time for complaints by agency.

Issue identified:
The original query failed with the error "Invalid format: """.
This indicates that at least one of the date columns contains an empty string ("").
Even though there are no NULL values (as shown in the validation query), date_parse cannot
convert empty strings into timestamps, which causes the query to fail.

Fix:
Filter out rows where created_date or closed_date is an empty string before parsing.
This ensures that only valid timestamps are used in the calculation.
*/

SELECT
  agency,
  AVG(
    date_diff(
      'day',
      date_parse(created_date, '%Y-%m-%d %H:%i:%s'),
      date_parse(closed_date,  '%Y-%m-%d %H:%i:%s')
    )
  ) AS avg_days_to_close
FROM nyc311_db.complaints
WHERE created_date <> ''
  AND closed_date <> ''
GROUP BY agency
ORDER BY avg_days_to_close DESC;
/*
This query calculates the average number of days it takes to close a complaint for each agency,
after removing rows with invalid (empty string) dates.

expected result:
#
agency  avg_days_to_close
1  OOS   34.166666666666664
2  DCWP  9.905448717948717
3  TLC   6.620762711864407
4  HPD   4.91492755251039
5  DOB   4.109570831750855
6  OTI   4.0
7  DPR   3.7256191950464395
8  DOHMH 2.4383414108777597
9  DOT   2.225174642554025
10 DOE   2.1448275862068966
11 DEP   2.096577859439596
12 DSNY  1.7657275527972496
13 DHS   1.523320895522388
14 NYPD  0.0019723310134963793
*/

SELECT
  COUNT(*) AS total_complaints,
  COUNT_IF(created_date = '') AS blank_created_date_rows,
  COUNT_IF(closed_date = '') AS blank_closed_date_rows,
  COUNT_IF(created_date <> '' AND closed_date <> '') AS usable_rows
FROM nyc311_db.complaints;
/*
This query checks for empty string values in the date columns to confirm the source of the error.

expected result:
#
#	total_complaints	blank_created_date_rows	blank_closed_date_rows	usable_rows
1	200000	            0	                    26031	                173969

- There are 200,000 total complaints.
- There are no NULL closed_date values, but some rows contain empty strings.
- Those rows caused the original query to fail and were excluded in the fixed query.
*/