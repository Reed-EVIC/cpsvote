# Contributing to cpsvote

Documentation created using claude by Paul Gronke and Frank Adonteng,
5/28/2026

## Adding a New Election Year

The CPS Voting and Registration Supplement is conducted every two years (even years only). This guide explains how to add support for a new year. Follow the stages in order and verify each one before proceeding.

### Overview of how years are supported

The package relies on three CSV files as the **source of truth** for all year-specific data. The compiled `.rda` binary files in `data/` are always generated from these CSVs — never edit the `.rda` files directly.

| File | Purpose |
|------|---------|
| `data-raw/cps_cols.csv` | Fixed-width column positions for reading raw CPS files |
| `data-raw/cps_factors.csv` | Factor code mappings (numeric codes → character labels) |
| `data-raw/cps_reweight.R` | Fetches VEP turnout data and builds reweighting table |

---

### Stage 1 — Audit the current state

Before making any changes, verify what the package already supports:

```r
devtools::load_all()
table(cps_cols$year)      # should include all supported years
table(cps_factors$year)   # should include all supported years
table(cps_reweight$YEAR)  # should include all supported years
```

Also confirm the download URL for the new year works. The URL pattern is in `R/cps_download.R`. **The source has changed over time:**

| Years | Microdata URL | Docs URL |
|-------|--------------|----------|
| 1994–2010 | `data.nber.org/cps/cpsnov{YY}.zip` | `data.nber.org/cps/cpsnov{YY}.pdf` |
| 2012–2016 | `data.nber.org/cps/cpsnov{YYYY}.zip` | `data.nber.org/cps/cpsnov{YYYY}.pdf` |
| 2018–2022 | `data.nber.org/cps/nov{YY}pub.zip` | `data.nber.org/cps/cpsnov{YY}.pdf` |
| 2024+ | `https://www2.census.gov/programs-surveys/cps/datasets/{YYYY}/supp/nov{YY}pub.zip` | `https://www2.census.gov/programs-surveys/cps/techdocs/cpsnov{YY}.pdf` |

For 2026 and beyond, verify whether the Census Bureau path is still `/supp/` or has reverted to `/november/` — it changed between 2022 and 2024. Add a new `years == XXXX` case in the `case_when` blocks before the general `years > 2017` case.

---

### Stage 2 — Add column positions (`cps_cols.csv`)

Open `data-raw/cps_cols.csv`. Each row specifies where a variable lives in the raw fixed-width CPS file for a given year.

Format: `year,cps_name,new_name,start_pos,end_pos,col_type,description,notes`

To add a new year:
1. Download the CPS technical documentation for the new year: `cps_download_docs(years = XXXX)`
2. Look up the start and end positions for each variable in the codebook
3. Add a row for each variable, modeled after the most recent prior year

**Check:** The non-voting demographic columns (YEAR, STATE, AGE, SEX, etc.) usually shift position slightly between years. The voting supplement columns (PES1–PES8) also shift. Verify each position against the codebook — do not assume they match the prior year.

Then regenerate the binary:

```r
source("data-raw/save_colspecs.R")
devtools::load_all()
table(cps_cols$year)   # new year should appear
```

---

### Stage 3 — Add factor codes (`cps_factors.csv`)

Open `data-raw/cps_factors.csv`. Each row maps a numeric code to a character label for a given year and variable.

Format: `year,cps_name,new_name,code,value`

**Critical:** The factor codes for the voting supplement questions **change between presidential and midterm elections**. Presidential election years (2020, 2016, ...) have different response options than midterm years (2022, 2018, ...). Always check the codebook for the new year and compare to the most similar prior year — do not assume it matches the immediately preceding year.

For example:
- 2022 matched 2018 (both midterms), NOT 2020 (presidential — had COVID-specific response options)

To add a new year:
1. Check the codebook for any new or changed response options in PES1–PES8
2. Copy the rows from the most similar prior year and change the year field to the new year
3. Edit any rows where the response options differ

**Verify the row count:** After adding, the new year should have the same number of rows as the prior year it was modeled on (or close to it). A dramatically higher count (e.g., double) indicates accidental duplication.

```r
source("data-raw/save_colspecs.R")
devtools::load_all()
table(cps_factors$year)   # new year should appear with expected row count
```

**Warning about editing the CSV in place with shell tools:** If you use `grep ... >> file` to append to the same file you are reading from, the first appended row may get concatenated to the last existing line if the file lacks a trailing newline. Use a script or editor that handles this correctly, and verify the output with a byte-level check before regenerating the binary.

---

### Stage 4 — Add reweighting data (`cps_reweight.R`)

The reweighting data comes from Dr. Michael McDonald's VEP turnout estimates. **The data source changed in 2024:**

| Years | Source | Format |
|-------|--------|--------|
| 1980–2022 | Google Sheets (public) via `googlesheets4` | `read_sheet()` |
| 2024+ | UF Election Lab CSV (public) at [election.lab.ufl.edu](https://election.lab.ufl.edu/voter-turnout/) | `read_csv()` from direct URL |

**For years up to 2022 (Google Sheets path):**

1. Find the Google Sheet at the old electproject.org archive or the UF Election Lab site
2. Extract the spreadsheet ID from the URL (between `/d/` and `/edit`)
3. Check the column layout — it changes between election years:
```r
library(googlesheets4)
gs4_deauth()   # use gs4_deauth(), NOT the old sheets_deauth()
x <- read_sheet("SPREADSHEET_ID", range = "A2:R2", col_names = FALSE, col_types = "c")
as.character(x[1,])
```
4. Add a `gid_XXXX` variable and `vep_XXXX <- read_sheet(...)` block, then add to `bind_rows()`

**For 2024 and later (UF Election Lab CSV path):**

1. Find the dataset at [election.lab.ufl.edu/data-archive](https://election.lab.ufl.edu/data-archive/) — look for "General Election Turnout Rates"
2. Get the direct CSV download URL (publicly accessible without login)
3. Check the documentation `.txt` file alongside the CSV for column names
4. The key columns are: `STATE` (name), `STATE_ABV` (abbreviation), `VEP_TURNOUT_RATE` (as a percent string, e.g. `"64.3%"` — divide by 100), `VEP`, `VAP`, `NONCITIZEN_PCT` (also percent string)
5. Use `parse_number(as.character(col))` to handle both numeric and percent/comma-formatted columns
6. Add a `url_XXXX` variable and `vep_XXXX <- read_csv(url_XXXX, ...) %>% transmute(...)` block, modeled on the 2024 block, then add to `bind_rows()`

**Important:** `cps_reweight.R` calls `cps_load_basic()` to compute CPS-side turnout, which loads all years. If the session crashes due to memory, run only the new year's CPS data separately and append to the existing `cps_reweight` object rather than re-running the full script.

**Verify:**
```r
devtools::load_all()
table(cps_reweight$YEAR)   # new year should appear with ~102 rows (2 per state/territory)
```

---

### Stage 5 — Create a sample dataset

Each supported year should have a 10,000-row sample dataset for documentation and examples. Create `data-raw/cps_XXXX_10k.R` modeled on `data-raw/cps_2020_10k.R`:

```r
devtools::load_all()

set.seed(XXXXXXXX)   # use a memorable date (e.g., election day: 20221108)
cps_XXXX_10k <- cps_read(years = XXXX) %>%
  dplyr::sample_n(10000) %>%
  dplyr::arrange(YEAR, STATE)

usethis::use_data(cps_XXXX_10k, overwrite = TRUE)

devtools::document()
```

Run the script. It will download the raw CPS data if not already present.

**Prerequisite:** Stage 3 must be complete so that factor labels are correct in the sample.

---

### Stage 6 — Update documentation (`R/data_doc.R`)

1. Add a roxygen documentation block for `cps_XXXX_10k`, modeled after the existing `cps_2020_10k` block
2. Update the row count in the `cps_cols` documentation to reflect the new total number of rows
3. Update the row count in the `cps_factors` documentation to reflect the new total number of rows

To get the exact counts:
```r
nrow(cps_cols)     # after devtools::load_all()
nrow(cps_factors)
```

Then run:
```r
devtools::document()
```

---

### Stage 7 — Update year ranges in R functions

Search for hardcoded year limits and update them to the new maximum year:

| File | What to update |
|------|---------------|
| `R/cps_download.R` | `years = seq(1994, XXXX, 2)` default and `years > XXXX` validation (two functions) |
| `R/cps_read.R` | `years = seq(1994, XXXX, 2)` default and `years > XXXX` validation |
| `R/cps_load_basic.R` | `years = seq(1994, XXXX, 2)` default |

Also update:
- `NEWS.md` — add an entry for the new year
- `README.Rmd` and `README.md` — update any "1994 to XXXX" range mentions

---

### Stage 8 — Final verification

```r
devtools::check()              # 0 errors, 0 warnings expected
cps_load_basic(years = XXXX)   # full pipeline should return a labeled tibble
```

The `cps_load_basic()` pipeline runs: `cps_read` → `cps_label` → `cps_refactor` → `cps_recode_vote` → `cps_reweight_turnout`. Check that the output has sensible values for VRS_VOTE, STATE, EDUCATION, etc.

---

## Year-by-Year Addition Log

### 2022 (Midterm)

**Added:** May 2026 — Paul Gronke and Frank Adonteng, with Claude (claude-sonnet-4-6)

| Stage | What was done |
|-------|--------------|
| Audit | Binary `cps_factors.rda` had 340 rows for 2022 (duplicated); `cps_reweight.rda` was correct at 102 rows |
| Cols | All 16 column positions identical to 2020; already added to CSV in prior work |
| Factors | Template: **2018** (midterm), NOT 2020 (presidential with COVID options). CSV had 0 rows for 2022; binary was wrong. Added 170 rows. Fixed a file-concatenation bug (grep >> same file caused first row to merge with last existing line) |
| Reweight | Fixed `sheets_deauth()` → `gs4_deauth()`. Added 2022 VEP Google Sheet (`gid_2022`); column layout verified interactively |
| Sample | Created `data-raw/cps_2022_10k.R`; seed `20221108` (Election Day) |
| Docs | Row counts updated: cps_cols 220→236, cps_factors 2135→2305 |
| Check | `devtools::check()` — 0 errors, 0 warnings; `cps_load_basic(years = 2022)` → 126,097 rows |

---

### 2024 (Presidential)

**Added:** May 2026 — Paul Gronke and Frank Adonteng, with Claude (claude-sonnet-4-6)

| Stage | What was done |
|-------|--------------|
| Audit | Verified column positions from `cpsnov24.pdf` (PDF decompressed via Python zlib); all 16 variables identical to 2022 |
| Cols | Positions unchanged from 2022. Added 16 rows to `cps_cols.csv`. Updated year-range defaults to `seq(1994, 2024, 2)` in `cps_read.R`, `cps_download.R`, `cps_load_basic.R` |
| Factors | Template: **2016** (presidential without COVID), NOT 2020. Added 170 rows. 2020 had COVID-specific response options in PES3 (code 5) and PES4 (code 3, different ordering) that do not appear in 2024 |
| Reweight | McDonald's VEP data moved from electproject.org to **UF Election Lab** (CSV, not Google Sheet). URL: `https://election.lab.ufl.edu/data-downloads/turnoutdata/Turnout_2024G_v0.4.csv`. Columns `VEP_TURNOUT_RATE` and `NONCITIZEN_PCT` are percent strings (e.g. `"64.3%"`); used `parse_number(as.character(col)) / 100`. `read_csv()` auto-parses some columns as numeric, so `as.character()` wrap required before `parse_number()`. R session crashed during full script run (memory); 2024 rows computed separately with `cps_load_basic(years = 2024)` and appended to existing `cps_reweight` |
| Download URL | NBER does not have 2024 data. Census Bureau changed path from `/november/` to `/supp/`. Fixed in `cps_download.R` by adding `years == 2024` case pointing to `https://www2.census.gov/programs-surveys/cps/datasets/2024/supp/nov24pub.zip` |
| Sample | Created `data-raw/cps_2024_10k.R`; seed `20241105` (Election Day) |
| Docs | Row counts updated: cps_cols 236→253, cps_factors 2305→2475 |
| Check | `devtools::check()` — 0 errors, 0 warnings; `cps_load_basic(years = 2024)` → 126,686 rows |

---

## Key Rules

- **Never edit `.rda` files directly.** Always regenerate them by running the appropriate `data-raw/` script.
- **The CSV files are the source of truth.** If the binary and CSV disagree, trust the CSV and regenerate.
- **Factor codes vary by election type.** Compare new years to a same-type election (presidential vs. midterm), not just the immediately prior year.
- **VEP sheet column order varies.** Always inspect the new year's sheet before writing `col_names`.
- **Use `gs4_deauth()`, not `sheets_deauth()`.** The old `googlesheets` package function is gone; the current package is `googlesheets4`.
- **VEP data source changed in 2024.** McDonald's data moved from electproject.org Google Sheets to UF Election Lab CSV downloads. For 2024+, use `read_csv()` with the direct URL from [election.lab.ufl.edu](https://election.lab.ufl.edu/data-archive/). Turnout and noncitizen columns are percent strings (e.g. `"64.3%"`) — use `parse_number(as.character(col)) / 100`.
- **CPS download URL changed in 2024.** NBER does not yet mirror the 2024 data. The Census Bureau changed the path from `/november/` to `/supp/`. Always verify the path for new years and add a specific `years == XXXX` case in `cps_download.R` before the general fallback.
- **Memory:** `cps_reweight.R` loads all years at once. If the R session crashes, compute only the new year's reweighting rows and append to the existing `cps_reweight` object manually.
