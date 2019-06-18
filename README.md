
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cps\_vote

<!-- badges: start -->

<!-- badges: end -->

`cps_vote` is an R package to interface with data from the Current
Population Survey (CPS) Voting and Registration Supplement, a biennial
supplement to the CPS from the US Census Bureau.

## Sources

2010-2018 come straight from the [US Census
Bureau](https://thedataweb.rm.census.gov/ftp/cps_ftp.html). 1972-2008
come from
[ICPSR](https://www.icpsr.umich.edu/icpsrweb/ICPSR/series/24/studies).

## Method

[`R/year_scripts`](R/year_scripts/) has a separate file for each survey
year, to do two things: read the file in (because field locations in the
FWF change Y/Y), and do the factoring (because factors change Y/Y).
These are run and combined by
[`R/combine_survey_years.R`](R/combine_survey_years.R)
