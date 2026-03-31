WITH complaint_times AS (
    SELECT
        borough,
        unique_key,
        DATE_PARSE(created_date, '%Y-%m-%d %H:%i:%s') AS created_ts,
        DATE_PARSE(NULLIF(closed_date, ''), '%Y-%m-%d %H:%i:%s') AS closed_ts,
        DATE_DIFF(
            'minute',
            DATE_PARSE(created_date, '%Y-%m-%d %H:%i:%s'),
            DATE_PARSE(NULLIF(closed_date, ''), '%Y-%m-%d %H:%i:%s')
        ) AS resolution_minutes
    FROM nyc311_db.complaints
    WHERE borough IS NOT NULL
      AND TRIM(borough) <> ''
)

SELECT
    borough,
    COUNT(*) AS total_complaints,
    COUNT(closed_ts) AS closed_complaints,
    ROUND(AVG(resolution_minutes) / 60.0, 2) AS avg_resolution_hours,
    ROUND(AVG(resolution_minutes) / 1440.0, 2) AS avg_resolution_days
FROM complaint_times
GROUP BY borough
ORDER BY total_complaints DESC;
/*
This query calculates the average resolution time for complaints in each borough. 
The first step is making a CTE that parses the created_date and closed_date into timestamps and calculates the resolution time in minutes. 
Then, it groups the results by borough, counting total complaints, closed complaints, and calculating the average resolution time in hours and days.
Expected output (example):
#	borough	total_complaints	closed_complaints	avg_resolution_hours	avg_resolution_days
1	MANHATTAN	50000	45000	48.50	2.02
2	BROOKLYN	40000	35000	36.75	1.
*/
/* Sanity Check Queries*/
SELECT COUNT(*) AS total_rows
FROM nyc311_db.complaints;
/* This query counts the total number of rows in the complaints table to ensure we have the expected number of complaints (200,000). */
SELECT *
FROM nyc311_db.complaints
LIMIT 10;
/* This query retrieves the first 10 rows from the complaints table to verify that the data is being read correctly and to inspect the structure of the data. */
SELECT borough, COUNT(*) AS n
FROM nyc311_db.complaints
GROUP BY borough
ORDER BY n DESC;
/* This query counts the number of complaints in each borough to ensure that the borough data is populated and to get a sense of the distribution of complaints across boroughs. */
SELECT status, COUNT(*) AS n
FROM nyc311_db.complaints
GROUP BY status
ORDER BY n DESC;
/* This query counts the number of complaints by their status (e.g., Open, Closed) to verify that the status field is populated and to understand the distribution of complaint statuses. */
SELECT
    status,
    COUNT(*) AS total,
    COUNT_IF(closed_date IS NULL OR TRIM(closed_date) = '') AS missing_closed_date,
    COUNT_IF(closed_date IS NOT NULL AND TRIM(closed_date) <> '') AS present_closed_date
FROM nyc311_db.complaints
GROUP BY status
ORDER BY total DESC;
/* This query checks for the presence of closed_date values across different complaint statuses to ensure that we have valid closed_date data for analysis. It counts total complaints by status and how many of those have missing or present closed_date values. */
SELECT
    created_date,
    DATE_PARSE(created_date, '%Y-%m-%d %H:%i:%s') AS created_ts,
    closed_date,
    DATE_PARSE(NULLIF(closed_date, ''), '%Y-%m-%d %H:%i:%s') AS closed_ts
FROM nyc311_db.complaints
LIMIT 20;
/* This query retrieves a sample of created_date and closed_date values along with their parsed timestamp versions to verify that the date parsing is working correctly and that the data is in the expected format. */
SELECT
    COUNT(*) AS total_rows,
    COUNT(DATE_PARSE(created_date, '%Y-%m-%d %H:%i:%s')) AS parsed_created,
    COUNT(DATE_PARSE(NULLIF(closed_date, ''), '%Y-%m-%d %H:%i:%s')) AS parsed_closed
FROM nyc311_db.complaints;
/* This query counts the total number of rows and how many of those have successfully parsed created_date and closed_date values to ensure that the date parsing is working correctly and that we have valid date data for analysis. */
SELECT
    unique_key,
    borough,
    created_date,
    closed_date,
    DATE_DIFF(
        'minute',
        DATE_PARSE(created_date, '%Y-%m-%d %H:%i:%s'),
        DATE_PARSE(NULLIF(closed_date, ''), '%Y-%m-%d %H:%i:%s')
    ) AS resolution_minutes
FROM nyc311_db.complaints
WHERE closed_date IS NOT NULL
  AND TRIM(closed_date) <> ''
LIMIT 25;
/* This query retrieves a sample of complaints with valid closed_date values and calculates the resolution time in minutes to verify that the resolution time calculation is working correctly. */
SELECT COUNT(*) AS negative_durations
FROM nyc311_db.complaints
WHERE closed_date IS NOT NULL
  AND TRIM(closed_date) <> ''
  AND DATE_DIFF(
        'minute',
        DATE_PARSE(created_date, '%Y-%m-%d %H:%i:%s'),
        DATE_PARSE(NULLIF(closed_date, ''), '%Y-%m-%d %H:%i:%s')
      ) < 0;
/* This query checks for any complaints that have a negative resolution time, which would indicate data quality issues (e.g., closed_date before created_date). It counts how many such cases exist to assess the extent of potential data problems. */
WITH complaint_times AS (
    SELECT
        borough,
        DATE_DIFF(
            'minute',
            DATE_PARSE(created_date, '%Y-%m-%d %H:%i:%s'),
            DATE_PARSE(NULLIF(closed_date, ''), '%Y-%m-%d %H:%i:%s')
        ) AS resolution_minutes
    FROM nyc311_db.complaints
)
SELECT
    borough,
    COUNT(*) AS total_complaints,
    COUNT(resolution_minutes) AS complaints_used_in_avg
FROM complaint_times
GROUP BY borough
ORDER BY total_complaints DESC;
/* This query checks how many complaints in each borough have valid resolution_minutes values that can be used in the average resolution time calculation. It counts total complaints and how many of those have valid resolution times to ensure that we have sufficient data for our analysis. */
SELECT
    COUNT(*) AS total_complaints,
    COUNT(
        DATE_DIFF(
            'minute',
            DATE_PARSE(created_date, '%Y-%m-%d %H:%i:%s'),
            DATE_PARSE(NULLIF(closed_date, ''), '%Y-%m-%d %H:%i:%s')
        )
    ) AS closed_complaints,
    AVG(
        DATE_DIFF(
            'minute',
            DATE_PARSE(created_date, '%Y-%m-%d %H:%i:%s'),
            DATE_PARSE(NULLIF(closed_date, ''), '%Y-%m-%d %H:%i:%s')
        )
    ) AS avg_resolution_minutes
FROM nyc311_db.complaints
WHERE borough = 'BRONX';
/* This query calculates the total number of complaints, the number of closed complaints (with valid resolution times), and the average resolution time in minutes specifically for the Bronx borough to verify that our calculations are working correctly for a specific subset of the data. */
SELECT borough, COUNT(*) AS n
FROM nyc311_db.complaints
WHERE borough IS NOT NULL
  AND TRIM(borough) <> ''
GROUP BY borough
ORDER BY n DESC;
/* This query counts the number of complaints in each borough while ensuring that we only include valid borough values (non-null and non-empty). It groups the results by borough and orders them in descending order to verify the distribution of complaints across boroughs. */
WITH complaint_times AS (
    SELECT
        borough,
        unique_key,
        DATE_PARSE(created_date, '%Y-%m-%d %H:%i:%s') AS created_ts,
        DATE_PARSE(NULLIF(closed_date, ''), '%Y-%m-%d %H:%i:%s') AS closed_ts
    FROM nyc311_db.complaints
    WHERE borough IS NOT NULL
      AND TRIM(borough) <> ''
)
SELECT borough, COUNT(*) AS n
FROM complaint_times
GROUP BY borough
ORDER BY n DESC;
/* This query is a sanity check to ensure that the CTE for parsing dates and filtering valid boroughs is working correctly. It counts the number of complaints in each borough using the complaint_times CTE and orders the results in descending order to verify that we have the expected distribution of complaints across boroughs. */
