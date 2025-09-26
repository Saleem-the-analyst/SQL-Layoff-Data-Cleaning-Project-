📊 SQL Layoff Data Cleaning Project
🔎 Project Overview

This project focuses on cleaning a Layoff dataset using SQL.
The raw data had duplicates, inconsistent formats, null values, and unnecessary rows/columns.
The goal was to transform messy raw data into a clean and structured dataset that is ready for analysis.

🛠️ Steps Followed
1️⃣ Finding and Removing Duplicates

Used ROW_NUMBER() to detect duplicate rows.

Kept the first valid entry and deleted the extra ones.

2️⃣ Standardizing Data Formats

Converted inconsistent date formats into proper SQL DATE.

Standardized text fields (company names, industries, locations) by trimming spaces and fixing capitalization.

3️⃣ Identifying Null or Blank Values

Checked for NULL / blank values across important columns.

Pulled them separately for review and handled them accordingly (fill / remove).

4️⃣ Removing Unwanted Columns & Rows

Dropped columns not needed for analysis.

Removed invalid rows (e.g., incomplete data that cannot be fixed).

⚙️ Tools Used

SQL (MySQL / PostgreSQL)

Key functions: ROW_NUMBER(), TRIM(), IS NULL, DELETE, ALTER

✅ Final Outcome

A clean layoff dataset that is:
✔️ Free from duplicates
✔️ Standardized and consistent
✔️ Without unnecessary nulls or unwanted rows

Ready for analysis of layoff trends, company insights, and industry impact.

📂 Repository Files

Portfolio Project layoff_Data Cleaning.sql → Full SQL script with step-by-step cleaning process.

👤 Author

Saleem (Saleem-the-analyst)
