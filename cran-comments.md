## R CMD check results

0 errors | 0 warnings | 2 notes

* NOTE: Maintainer email changed from jaylee@reed.edu to jay.lee.tx@gmail.com.
  The author's institutional email is no longer active; the Gmail address
  is the correct current contact. This package has been submitted before
  under the same maintainer name.

* NOTE: unable to verify current time (local network issue; not a package problem)

## Test environments
* local macOS Sequoia 15.6, R 4.4.3 (x86_64-apple-darwin20)

## Submission notes

This is a resubmission of cpsvote. Changes since last CRAN release (0.1.0):
- Added 2022 and 2024 CPS Voting and Registration Supplement data
- Updated all vignettes to reflect data coverage through 2024
- Added 10k-row sample datasets for 2022 and 2024
- Fixed factor recoding bug (fct_recode → fct_collapse for NULL levels)
- Added 2022 turnout validation report
- Replaced Travis CI with GitHub Actions
- Pre-built vignette HTML committed to inst/doc/ (vignettes use NOT_CRAN
  guard so figures would not render on CRAN servers without pre-built output)
