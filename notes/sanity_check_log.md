# Sanity Check Log

This file cooresponds to the queries located in my sql folder, and documents why I ran each of the queries I did on the Athena AWS database.

## Query: Initialize complaints table (2026-03-27)

* **File:** sql/nyc311_db_init.sql

* **Business question:** Can I reliably load and structure raw 311 complaint data from S3 into Athena for downstream analysis?

* **What I expected:**
  I expected the table to load successfully and return rows that match the CSV structure, with columns like `agency`, `created_date`, and `problem` populated correctly. I also expected no header rows to appear in the data due to the `skip.header.line.count` setting.

* **Issues encountered:**
  No immediate errors during table creation.

* **Checks performed:**
  I ran a `SELECT * LIMIT 5` query to confirm that the table was accessible and that columns were mapped correctly. I also verified that the header row was skipped and not included as data. 

* **Final outcome:**
  The table was created successfully and is usable for analysis.

* **Confidence:** High. Would present to stakeholder.

## Query: Initialize agencies table (2026-03-27)

* **File:** nyc311_db_init.sql

* **Business question:** Can I create a clean lookup table to map agency codes to full agency names?

* **What I expected:**
  I expected a small, clean table with unique agency codes and corresponding full names, which could be used for joins to improve readability in analysis queries.

* **Issues encountered:**
  No issues during table creation or initial validation. The dataset is simple and well-structured compared to the complaints table, so there were fewer risks of malformed data.

* **Checks performed:**
  I ran a `SELECT * LIMIT 5` query to confirm that the table loaded correctly and that both `agency` and `agency_name` fields were populated as expected. 

* **Final outcome:**
  The agencies table functions as intended and provides a clean mapping for use in joins. 

* **Confidence:** High. Would present to stakeholder.

## Query: Average resolution time by agency (2026-03-27)

* **File:** sql/resolution_time.sql

* **Business question:** How long does each agency take to resolve complaints?

* **What I expected:**
  I expected variation across agencies based on the type of work they do.

* **Issues encountered:**
  The original query failed with the error `Invalid format: ""`. This indicated that at least one of the date fields contained an empty string. Even though there were no NULL values, `date_parse` cannot handle empty strings, which caused the query to break.

* **Checks performed:**
  I ran a validation query to check for NULL values and confirmed that all 200,000 complaints had a `closed_date`. This ruled out missing data as the issue. I then checked for empty strings in the date fields and confirmed that blank values existed, which explained the parsing error. After filtering out rows where `created_date` or `closed_date` was an empty string, the query ran successfully.

* **Final outcome:**
  The corrected query produced reasonable results. Agencies like OOS and DCWP had higher average resolution times, while NYPD had an extremely low average, which is plausible given that many NYPD complaints are resolved almost immediately. The results align with expectations about operational differences across agencies. The main takeaway is that string-based date fields require careful validation before parsing, especially in datasets where missing values may be encoded as empty strings instead of NULLs. No further refinements are strictly necessary for this level of analysis, though future work could improve precision by measuring resolution time in hours instead of whole days.

* **Confidence:** High. Would present to stakeholder.

## Query: Resolution time modeling table (2026-03-30)

* **File:** sql/athena_to_modeling.sql

* **Business question:**
  How long will a complaint take to be resolved, and what factors influence that?

* **What I expected:**
  I expected to successfully create a clean modeling table with a clear target variable (`days_to_close`) and relevant features that could later be used in a regression model. 

* **Issues encountered:**
  No major errors during execution.

* **Checks performed:**
  I ran a `SELECT * LIMIT 10` query on the new table to verify that all columns were created correctly and that transformations worked as intended. I checked that:

- day_of_week and hour_of_day were within expected ranges
- same_day_complaint_volume looked consistent across similar rows
- days_to_close was non-negative and within the filtered 0 to 365 day range

* **Final outcome:**
  The modeling table was created successfully and contains both the target variable and relevant features for analysis. The values look reasonable and consistent.

* **Confidence:** High. Would present to stakeholder.
