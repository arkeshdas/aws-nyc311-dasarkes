# NYC 311 Modeling Plan

**Date created:** 04/01/2026

## Business question
Predict expected resolution time at the moment a complaint is filed, so they can set realistic expectations with residents. What factors drive that time?

## Data source
- **S3 path:** `cmse492-dasarkes-nyc311-471112527784-us-east-1-an/modeling/q2_modeling_data.csv`
- **Records:** [number from df.shape[0]]
- **Athena query:** sql/athena_to_modeling.sql

## Features (update/expand based on your query)
- agency (string)
- borough (string)
- n_complaints (numeric, count of complaints)
- avg_days_to_close (numeric, average resolution time)
- ... (other features)

## Target
- **Name:** days_to_close
- **Type:** 
- **Balance/Distribution:** [paste results from your target variable distribution check]

## Modeling approach (update based on your question and data)
- **Baseline:** Logistic regression (interpretable, fast to train)
- **Metrics:** Accuracy, precision, recall
- **Train/test split:** 80/20
MLS and do dummy vairables to not imply heirarchy, etc. 
## Data quality notes
- [Any missing values, outliers, or issues to watch for]

## Next steps (What you'll work on in the next class period; update/modify based on your plan)
- Train/test split
- Fit baseline logistic regression
- Evaluate and interpret results
```