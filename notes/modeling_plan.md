# NYC 311 Modeling Plan

**Date created:** 04/01/2026

## Business question

Predict expected resolution time at the moment a complaint is filed, so agencies can set realistic expectations. What factors drive that time?

## Data source

* **S3 path:** `cmse492-dasarkes-nyc311-471112527784-us-east-1-an/modeling/q2_modeling_data.csv`
* **Records:** 172,086 (after filtering missing values, from original 173,851)
* **Athena query:** `sql/athena_to_modeling.sql`

## Features

* agency (categorical, 9 unique values)
* borough (categorical, 5 values)
* problem (categorical, moderate cardinality)
* incident_zip (numeric/categorical, high cardinality)
* day_of_week (numeric, 1–7)
* hour_of_day (numeric, 0–23)
* same_day_complaint_volume (numeric)

## Target

* **Name:** days_to_close
* **Type:** Continuous (integer)
* **Distribution:**
  Highly right-skewed with strong zero inflation.

  * Mean: ~2.06 days
  * Median: 0 days
  * ~62% of complaints are resolved the same day (0 days)
  * Long tail up to 49 days

## Modeling approach

* **Baseline:** Multiple Linear Regression
* **Preprocessing:** One-hot encoding for categorical variables (to avoid imposing artificial ordering)
* **Metrics:** RMSE, MAE, $R^2$
* **Train/test split:** 80/20