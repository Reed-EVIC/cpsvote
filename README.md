
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cpsvote

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/Reed-EVIC/cpsvote.svg?branch=master)](https://travis-ci.org/Reed-EVIC/cpsvote)
<!-- badges: end -->

`cpsvote` is an R package to interface with data from the Current
Population Survey (CPS) Voting and Registration Supplement, a biennial
supplement to the monthly CPS.

## Sources

All years of data come from the [National Bureau of Economic Research
(NBER)](https://data.nber.org/cps/), and the CPS is administered by the
[US Census Bureau and Bureau of Labor Statistics
(BLS)](https://www.census.gov/programs-surveys/cps.html).

## Process

A few main functions of this package are to:

1.  Download the CPS data (`cps_download_data`) and documentation
    (`cps_download_docs`) from NBER

2.  Load the raw, numeric CPS data into R (`cps_read`)

3.  Help you apply the correct factor labels to this numeric data
    (`cps_label`)

4.  Access a “basic” version of the CPS that we have included with the
    package (`cps_load_basic`)

For help with these, see the documentation for these functions and the
vignettes. Additional vignettes are provided with examples of some basic
analyses that are possible with the CPS.

## Testing

1.  `devtools::load_all()` will load the package
2.  `cpsvote::download_data(path = "dir", years =
    seq(start,end,sequence))` will download data
3.  `cpsvote::read_cps()` will read all data files (1994 - 2018)
4.  `cpsvote::read_cps(path = "dir", years = seq(start,end,sequence)`
    will read data into memory
