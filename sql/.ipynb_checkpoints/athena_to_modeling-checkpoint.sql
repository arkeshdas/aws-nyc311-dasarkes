CREATE TABLE nyc311_db.resolution_time_modeling AS
SELECT
    agency,
    borough,
    problem,
    incident_zip,
    day_of_week(date_parse(created_date, '%Y-%m-%d %H:%i:%s'))  AS day_of_week,
    hour(date_parse(created_date, '%Y-%m-%d %H:%i:%s'))          AS hour_of_day,
    -- Count of same complaint type filed on same day (proxy for surge volume)
    COUNT(*) OVER (
        PARTITION BY agency, problem,
                     DATE(date_parse(created_date, '%Y-%m-%d %H:%i:%s'))
    ) AS same_day_complaint_volume,
    -- Continuous target: days to close
    date_diff('day',
        date_parse(created_date, '%Y-%m-%d %H:%i:%s'),
        date_parse(closed_date,  '%Y-%m-%d %H:%i:%s')) AS days_to_close
FROM nyc311_db.complaints
WHERE closed_date <> ''
  AND borough IN ('BROOKLYN','QUEENS','BRONX','MANHATTAN','STATEN ISLAND')
  AND date_diff('day',
        date_parse(created_date, '%Y-%m-%d %H:%i:%s'),
        date_parse(closed_date,  '%Y-%m-%d %H:%i:%s')) BETWEEN 0 AND 365;

---- I am answering the stakeholder questions: Agency directors want a tool that estimates expected resolution time at the moment a complaint is filed, so they can set realistic expectations with residents. What factors drive that time?


-- What would the **target variable** be? (i.e., what would you be trying to predict)?
-- the target variable is the resolution time, so that is what I am trying to predict

-- What **features** should be included in the model?
-- I think that since this is an exploratory analysis, for now all of the features in the data should be included, because I don't know what is and isn't significant just yet.

-- What **aggregations** or **transformations** are needed to create the features and target variable?
-- This isn't really a transformation but I should keep in mind that variables like zip, burough and agency and problem are not continous veriables, and I might need to convert them into columns like BRONX_True, etc as binary 1 0 variables. 


-- What sort of **modeling approach** would be appropriate for the question and data you've created? (e.g., classification, regression, clustering)
-- I think that the cleanest and most interpretable thing would be to just do a MLS regression model. I could potentially do Backwards Selection and start with the full model, maybe even compare it to forward selection and stuff. Then, I will use coorelation statistics to determine the best model (in terms of over all predictions), the most efficient (compromise) model, adn alos just answer which features are the most significant.