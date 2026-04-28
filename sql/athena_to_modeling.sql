/*
This query creates the modeling table for predicting complaint resolution time.

Business question:
How long will a complaint take to be resolved, and what factors influence that?

Target variable:
days_to_close (difference between created_date and closed_date)

Features:
agency, borough, problem, incident_zip, day_of_week, hour_of_day, same_day_complaint_volume

Transformations:
- Parse created_date and closed_date into timestamps
- Extract day_of_week and hour_of_day
- Compute same_day_complaint_volume using a window function
- Compute days_to_close using date_diff

Filtering:
- Remove rows with blank closed_date
- Keep only valid NYC boroughs
- Restrict resolution time to 0–365 days

Modeling approach:
Regression, since the target variable is continuous
*/

CREATE TABLE nyc311_db.resolution_time_modeling AS
SELECT
    agency,
    borough,
    problem,
    incident_zip,

    day_of_week(date_parse(created_date, '%Y-%m-%d %H:%i:%s')) AS day_of_week,

    hour(date_parse(created_date, '%Y-%m-%d %H:%i:%s')) AS hour_of_day,

    COUNT(*) OVER (
        PARTITION BY agency, problem,
                     DATE(date_parse(created_date, '%Y-%m-%d %H:%i:%s'))
    ) AS same_day_complaint_volume,

    date_diff(
        'day',
        date_parse(created_date, '%Y-%m-%d %H:%i:%s'),
        date_parse(closed_date,  '%Y-%m-%d %H:%i:%s')
    ) AS days_to_close

FROM nyc311_db.complaints
WHERE closed_date <> ''
  AND borough IN ('BROOKLYN', 'QUEENS', 'BRONX', 'MANHATTAN', 'STATEN ISLAND')
  AND date_diff(
        'day',
        date_parse(created_date, '%Y-%m-%d %H:%i:%s'),
        date_parse(closed_date,  '%Y-%m-%d %H:%i:%s')
      ) BETWEEN 0 AND 365;


/*
Validation query:
Preview the modeling table to confirm columns and transformations look correct.
*/

SELECT *
FROM nyc311_db.resolution_time_modeling
LIMIT 10;

/*
expected result:
#
agency  borough        problem              incident_zip  day_of_week  hour_of_day  same_day_complaint_volume  days_to_close
1 DCWP   BRONX          Consumer Complaint   10455         5            13           19                         33
2 DCWP   BROOKLYN       Consumer Complaint   11207         5            11           19                         4
3 DCWP   BROOKLYN       Consumer Complaint   11234         5            3            19                         34
4 DCWP   BRONX          Consumer Complaint   10454         5            11           19                         33
5 DCWP   QUEENS         Consumer Complaint   11423         5            15           19                         33
6 DCWP   BRONX          Consumer Complaint   10470         5            16           19                         33
7 DCWP   BRONX          Consumer Complaint   10467         5            14           19                         3
8 DCWP   BROOKLYN       Consumer Complaint   11214         5            13           19                         33
9 DCWP   QUEENS         Consumer Complaint   11354         5            9            19                         4
10 DCWP  BROOKLYN       Consumer Complaint   11214         5            16           19                         33
*/