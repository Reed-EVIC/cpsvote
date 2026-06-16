## R CMD check results

0 errors | 0 warnings | 1 note

* NOTE: unable to verify current time
  This is a transient network issue during the check and is not a problem
  with the package.

## Test environments

* local macOS (aarch64), R 4.5.2
* win-builder (R-devel)
* GitHub Actions: macOS-latest, windows-latest, ubuntu-latest (R release + devel)

## Submission notes

This is a resubmission. Changes since the last CRAN release (0.1.0):

- Added CPS VRS data for 2020, 2022, and 2024
- 2024 microdata sourced from Census Bureau (not NBER); VEP reweighting data
  from University of Florida Election Lab
- Added 10k-row sample dataset of the 2020 CPS VRS
- Added turnout validation vignette comparing estimates to Census Bureau figures
- Updated maintainer from Jay Lee to Paul Gronke (gronkep@reed.edu)
- Changed PDF download method for Windows compatibility
- Replaced Travis CI with GitHub Actions
