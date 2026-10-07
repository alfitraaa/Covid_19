# COVID-19 Data Analysis

Legacy educational SQL analysis of bundled COVID-19 data using MySQL and Tableau-oriented queries.

### Project purpose
This is an educational portfolio project demonstrating:
- SQL querying
- Joins
- CTE and window functions
- Descriptive COVID case, death, and vaccination analysis
- Queries prepared for visualization

### Repository contents
- `SQL Query Covid Project.sql`: Main analysis SQL.
- `SQL Queries - Tableau Visualization.sql`: Tableau-oriented SQL queries.
- `covid_csv.zip`: Bundled ZIP containing two CSVs (`covid_deaths.csv` and `covid_vaccinations.csv`).

### Dataset snapshot
- 239,478 rows per CSV.
- Date range: `2020-01-01` to `2022-12-01`.
- `(location, date)` is unique in each dataset.
- Aggregate entities exist where `continent` is empty (e.g., World, High income).
- No source attribution is preserved in the repository.

### Setup
Minimal reproducible steps:
1. Clone this repository.
2. Extract `covid_csv.zip` into the working repository directory.
3. Create/select a MySQL 8.x database.
4. Enable client/server support for `LOAD DATA LOCAL INFILE` as permitted by your environment (e.g., launching the client with `--local-infile=1`).
5. Execute the main SQL from `SQL Query Covid Project.sql`.
6. Optionally run the Tableau-oriented queries from `SQL Queries - Tableau Visualization.sql`.

### Analytical caveats
- CFR (Case-Fatality Ratio) is descriptive, not an individual's mortality probability.
- Reported cases are not the same as unique infected people.
- Vaccination totals represent vaccine doses administered where stated.
- Aggregate OWID-style location rows (e.g., 'World', 'Europe') are excluded from country rankings using continent presence (`continent IS NOT NULL AND continent <> ''`).

### Tableau status
- SQL queries for Tableau-style visualization are included.
- No `.twb` or `.twbx` workbook is stored in this repository.
- No dashboard artifact has been independently revalidated in this cleanup.
