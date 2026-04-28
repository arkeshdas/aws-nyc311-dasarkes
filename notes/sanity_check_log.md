# Sanity Check Log

This file cooresponds to the queries located in my sql folder, and documents why I ran each of the queries I did on the AWS database.

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
