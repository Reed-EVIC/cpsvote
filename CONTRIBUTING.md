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

Also confirm the download URL for the new year works. The URL pattern is in `R/cps_download.R` (lines 205–208 for data, lines 89–93 for docs). For recent years the data URL follows the pattern `data.nber.org/cps/novXXpub.zip` (e.g., `nov22pub.zip` for 2022).

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

The reweighting data comes from Dr. Michael McDonald's VEP turnout estimates at [electproject.org](http://www.electproject.org/home/voter-turnout/voter-turnout-data).

To add a new year:

1. Find the Google Sheet for the new election year on McDonald's site
2. Extract the spreadsheet ID from the URL (the string between `/d/` and `/edit`)
3. Check the column layout of the new sheet — **the column order changes between election years** and must be verified before assigning `col_names`

To inspect the column layout:
```r
library(googlesheets4)
gs4_deauth()   # these sheets are public; use gs4_deauth(), NOT the old sheets_deauth()
x <- read_sheet("SPREADSHEET_ID", range = "A2:R2", col_names = FALSE, col_types = "c")
as.character(x[1,])
```

4. Add a `gid_XXXX` variable and a `vep_XXXX <- read_sheet(...)` block in `cps_reweight.R`, modeled after the prior years
5. Add `vep_XXXX` to the `bind_rows()` call
6. Run the script and verify:

```r
source("data-raw/cps_reweight.R")
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

## Key Rules

- **Never edit `.rda` files directly.** Always regenerate them by running the appropriate `data-raw/` script.
- **The CSV files are the source of truth.** If the binary and CSV disagree, trust the CSV and regenerate.
- **Factor codes vary by election type.** Compare new years to a same-type election (presidential vs. midterm), not just the immediately prior year.
- **VEP sheet column order varies.** Always inspect the new year's sheet before writing `col_names`.
- **Use `gs4_deauth()`, not `sheets_deauth()`.** The old `googlesheets` package function is gone; the current package is `googlesheets4`.
