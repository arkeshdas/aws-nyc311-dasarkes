# NYC 311 Service Request Analysis Project

This is my version of the NYC 311 Project for CMSE 492. Ideally with this project, my end goal is to be able to get real experience working with a cloud computing service and integrating it into a data science workflow. We will be using AWS Learner Lab to conduct the majority of the analysis and to store the data and environments. 

By the end of this project, I want to have an understanding of how to use not just AWS's S3 buckets, SageMaker AI and EC2 instances, but how to use cloud computing in general, especially its strengths and limitations. 

## Data Source and Provenance
- **Source**: [NYC Open Data 311 Service Requests](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9/)
- **Time period**: Jan 29–Mar 21, 2026 (Q1 2026)
- **Prep**: Instructor-generated random sample of 200k complaints from 15 agencies
- **Files**: 
  - `raw/complaints.csv` (200k rows, main requests table)
  - `raw/agencies.csv` (unique agencies lookup table)
- **S3 paths**:
  - `s3://cmse492-dasarkes-nyc311-471112527784-us-east-1-an/raw/complaints.csv`
  - `s3://cmse492-dasarkes-nyc311-471112527784-us-east-1-an/raw/agencies.csv`

## Project Structure

```
aws-nyc311-yourMSUNetID/      # Update with your GitHub repo name
├── README.md                 # Data source, S3 paths, assumptions
├── data-dictionary.md        # Column details
├── raw/                      # Local copies of S3 uploads
│   ├── complaints.csv
│   └── agencies.csv
├── sql/                      # Athena queries
├── notes/                    # Observations, decisions
└── reports/                  # Stakeholder outputs
```

## Data Summary
See [the data dictionary](DATA_DICTIONARY.md) for full schema.

**Key relationships**: Join `complaints.agency = agencies.agency`

**Stakeholder questions**:
- [Paste your specific problem brief here]

## Assumptions and Known Issues
- Empty `closed_date` = open/unresolved requests
- The `status` may not be a simple open and closed, so when filtering I will need to filter out anything that is not just open/closed OR filter out all empty entries and examine additional entries (basically I cannot assume this is a binary variable)
- Some `incident_zip` values are 0 or missing
- String dates need parsing in Athena/SQL
- Any analysis on the frequency of problems/how they were resolved will need complex parsing. They are not predetermined one word answers but rather entries written by the operator (so not garuenteed to be consistent)