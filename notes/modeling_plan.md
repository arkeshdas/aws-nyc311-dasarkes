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

### Interpretation

The baseline regression model captures some variation in resolution time, but performance is limited by the structure of the data. The `problem` feature initially dominated the model, suggesting that complaint type is the strongest driver of resolution time, but this reduces interpretability. After restricting to more common problems and applying backward selection, the model became more balanced and highlighted broader patterns, though overall predictive power remained modest.

### Limitation

A major limitation is that the target variable is highly skewed and dominated by same-day resolutions, which makes it difficult for a linear model to accurately capture longer resolution times. Additionally, high-cardinality categorical variables, especially `problem` and `incident_zip`, can lead to overfitting or models that rely on very specific categories rather than generalizable patterns.