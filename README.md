# NYC 311 Service Request Analysis Project

## Project Overview

This is my version of the NYC 311 Project for CMSE 492. Ideally with this project, my end goal is to be able to get real experience working with a cloud computing service and integrating it into a data science workflow. I used AWS Learner Lab to conduct the majority of the analysis and to store the data and environments. 

This project analyzes NYC 311 service request data using AWS to build an end-to-end, cloud-based data science workflow. The goal is to understand what factors influence complaint resolution time and to develop a model that predicts expected resolution time at the moment a complaint is filed.

The workflow integrates AWS S3 for storage, Athena for querying and feature engineering, and SageMaker for model training, alongside Python-based modeling with scikit-learn.


## Workflow Overview

This project follows a cloud-first data pipeline:

1. **Data Storage (S3)**
   Raw NYC 311 data is stored in S3 and used as the source of truth.

2. **Querying and Feature Engineering (Athena)**
   External tables are created over S3 data using schema-on-read. SQL queries are used to:

   * Clean and filter complaint data
   * Parse timestamp fields
   * Engineer features such as day of week, hour of day, and complaint volume
   * Construct a modeling-ready table

3. **Modeling Dataset (S3 export)**
   The final modeling dataset is generated in Athena and exported back to S3.

4. **Local Modeling (scikit-learn)**
   The dataset is loaded into Python for exploratory analysis and baseline regression modeling.

5. **Cloud Modeling (SageMaker)**
   A SageMaker training job is launched using the built-in Linear Learner algorithm. The model is trained on the same dataset and evaluated to compare performance against the local baseline.


## Data Source and Provenance

* **Source**: [NYC Open Data 311 Service Requests](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9/)

* **Time period**: Jan 29–Mar 21, 2026 (Q1 2026)

* **Prep**: Instructor-generated random sample of 200,000 complaints from 15 agencies

* **Files**:

  * `raw/complaints.csv` (main requests table)
  * `raw/agencies.csv` (agency lookup table)

* **S3 paths**:

  * `s3://cmse492-dasarkes-nyc311-471112527784-us-east-1-an/raw/complaints.csv`
  * `s3://cmse492-dasarkes-nyc311-471112527784-us-east-1-an/raw/agencies.csv`


## Project Structure

```
aws-nyc311-dasarkes
├── README.md
├── DATA_DICTIONARY.md
├── notebooks
│   ├── data_load_verify.ipynb
│   ├── model_train_and_eval.ipynb
│   └── sagemaker_linear_learner_baseline.ipynb
├── sql
│   ├── nyc311_db_init.sql
│   ├── resolution_time.sql
│   ├── athena_to_modeling.sql
│   └── warm_ups.sql
├── notes
│   ├── modeling_plan.md
│   └── sanity_check_log.md
└── reports
```


## Data Summary

See [DATA_DICTIONARY.md](DATA_DICTIONARY.md) for full schema.

**Key relationship:**
`complaints.agency = agencies.agency`

**Stakeholder question:**
Predict how long a complaint will take to be resolved at the time it is filed, and identify which factors most influence that time.

## Modeling

* **Target:** `days_to_close` (resolution time in days)
* **Approach:** Multiple Linear Regression (scikit-learn baseline)
* **Cloud comparison:** SageMaker Linear Learner

**Key observations:**

* Complaint type (`problem`) is the strongest predictor of resolution time
* The target variable is highly skewed, with most complaints resolved the same day
* Model performance is limited by zero-inflation and high-cardinality categorical features


## Assumptions and Known Issues

* Empty `closed_date` values indicate open or unresolved requests
* Some records contain empty strings in date fields, which require filtering before parsing
* `incident_zip` contains missing or invalid values
* Text fields like `problem` are not standardized and may introduce noise
* Resolution time is highly skewed, with a majority of complaints resolved on the same day
* High-cardinality categorical features, especially `incident_zip` and `problem`, may impact model stability and interpretability


## Notes on SageMaker Usage

The SageMaker notebook (`sagemaker_linear_learner_baseline.ipynb`) was provided as part of the course and used to launch a managed training job on AWS. It was adapted to run on this project’s dataset and serves as a benchmark against the scikit-learn baseline model.