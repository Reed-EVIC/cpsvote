## R CMD check results

0 errors | 0 warnings | 1 note

* NOTE: unable to verify current time
  This is a transient network issue during the check and is not a problem
  with the package.

## URL check notes

Some URLs return 403 Forbidden when checked by urlchecker due to server-side
access restrictions on automated requests; they are valid and accessible in a
browser:

- https://doi.org/10.1093/poq/nft042 (Hur & Achen 2013, Public Opinion Quarterly)
- https://www.nber.org/research/data/current-population-survey-cps-supplements-voting-and-registration
- https://academic.oup.com/poq/article/77/4/985/1843466/

## Test environments

* local macOS (aarch64), R 4.5.2
* win-builder (R-devel), 0 errors, 0 warnings, 1 note
* GitHub Actions: macOS-latest, windows-latest, ubuntu-latest (R release + devel)

## Submission notes

This is a resubmission. Changes since the last CRAN release (0.1.0):

- Added CPS VRS data for 2020, 2022, and 2024
- 2024 microdata sourced from Census Bureau (not NBER); VEP reweighting data
  from University of Florida Election Lab
- Added 10k-row sample datasets for 2020, 2022, and 2024 CPS VRS
- Added turnout validation vignette comparing estimates to Census Bureau figures
- Added cps_data_dir() and cps_docs_dir() helpers for user-configurable
  download directories (overridable via options() in .Rprofile)
- Updated maintainer from Jay Lee to Paul Gronke (gronkep@reed.edu)
- Changed PDF download method for Windows compatibility
- Replaced Travis CI with GitHub Actions
