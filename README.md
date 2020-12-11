
<!-- README.md is generated from README.Rmd. Please edit the Rmd file -->

# cpsvote

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/Reed-EVIC/cpsvote.svg?branch=master)](https://travis-ci.org/Reed-EVIC/cpsvote)
<!-- badges: end -->

`cpsvote` provides an automated method for downloading, recoding, and
merging selected years of the Current Population Survey’s Voting and
Registration Supplement, a biennial large-\(N\) survey about voter
registration, voting, and non-voting in United States federal elections.
The package provides documentation for appropriate use of sample weights
to generate statistical estimates. The package includes multiple
vignettes that illustrate different applications.

## Sources

All years of data come from the [National Bureau of Economic Research
(NBER)](https://data.nber.org/cps/), and the CPS is administered by the
[US Census Bureau and Bureau of Labor Statistics
(BLS)](https://www.census.gov/programs-surveys/cps.html).

## Process

A few main purposess of this package are to:

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

## Instructions for Alpha Testing

### Basic Use Information

1.  *Install the Package*
    1)  If you are a tester, you can install the package using
        `remotes`:
    <!-- end list -->
    ``` r
    remotes::install_github("Reed-EVIC/cpsvote")
    library(cpsvote)
    ```
    2)  If you are a primary developer / contributor and are using a
        localized version control system, create your version control
        project using this URL:
        <https://github.com/Reed-EVIC/cpsvote.git>.
    <!-- end list -->
    1)  `devtools::load_all()` will load the package and all the
        associated functions.
2.  *Quickly view some CPS data*
    1)  There is far more data included in the full CPS than we could
        include here, but there are two options to view a subset of the
        CPS data with ease.
        1)  Running `data(cps_sample_10k, package = 'cpsvote')` will
            load a 10,000 row sample of selected CPS columns into your
            environment.
        2)  Running `cpsvote::cps_load_basic()` will download the data,
            and provide you all rows and a selected set of CPS columns,
            and allow you to save a copy locally for speed in the
            future.
3.  *Download the CPS Files*
    1)  `cpsvote` will download the CPS files directly from a federal
        data repository
        (<http://data.nber.org/data/current-population-survey-data.html>
        for years 1994 - 2018). By default `cpsvote` will create a new
        subdirectory in your working directory named “cps\_data” and
        store the compressed data files in that location.
    2)  If you choose to download data files and store them in a
        separate location, `cpsvote` can only process files that retain
        the original file name. See the “Data Description” vignette for
        a list of the expected file names.
    3)  `cpsvote::cps_download_data(path = "dir", years =
        seq(start,end,sequence))` will download data
        1)  Example: `cpsvote::cps_download_data()` will download all
            data files and place the files in the default download path
            (“./cps\_data”).
        2)  Example: `cpsvote::cps_download_data(path = "~/mydata/CPS",
            years = seq(2000, 2014, 4))` will download the 2000, 2004,
            2008, and 2012 CPS and place them in the path
            “\~/mydata/CPS”.
    4)  `cpsvote::cps_download_docs()` downloads all documentation
        files, and places them in “./cps\_docs”
    5)  `cpsvote::cps_download_docs(path = "dir", years = seq(start,
        end, seqquence)` allows you to control the target directory and
        years for the documentation.
4.  *Import the Data Into R and Create a Data Frame*
    1)  `cpsvote` performs a series of data transformations that produce
        a set of comparably coded variables across all of the survey
        years. These variables are listed in the “Data Description”
        vignette.
    2)  `cpsvote::read_cps(dir = "dir", years =
        seq(start,end,sequence))` will read CPS data files located in
        “dir” into memory. A reminder that the file names must contain
        the 4-digit year associated with their data in order to be read
        easily.
        1)  Example: `cps_vote <- cpsvote::cps_read()` will read all
            data files (1994 - 2018) from the default directory
            (“./cps\_data”), and merge into a single data frame called
            “cps\_vote”.
        2)  Example: `cps_vote <- cpsvote::cps_read(data_dir =
            "~/mydata/CPS", years = seq(1994, 2000, 2))` will load CPS
            data from 1994, 1996, 1998, and 2000, assuming the data
            files are stored in “\~/mydata/CPS”, and merge into the
            object “cps\_vote”.
5.  *Attach proper labels to the numeric data*
    1)  By default, the CPS comes with numeric data values. These
        correspond to factor codes as detailed in the survey
        documentation. The `cps_label` function applies given factor
        codes to this numeric data in order to make it human-readable.
6.  *Attach proper turnout modifiers*
    1)  Certain steps have to be taken to properly reweight the CPS for
        voter turnout analyses. The functions `cps_recode_vote` and
        `cps_reweight_turnout` help to redo these codings to
        appropriately calculate voter turnout.

### Recommended First Steps

The steps shown below install the package locally, download all CPS
files from 1994 - 2018, load the files into memory, and results in a
data frame with CPS Voting and Registration Supplement data from
1994-2018.

1.  `remotes::install_github("Reed-EVIC/cpsvote")`
2.  `library(cpsvote)`
3.  `cpsvote::cps_download_data()` (Only necessary if using the package
    for the first time; after that, the files will already be downloaded
    and you can skip this step)
4.  `cps_vote <- cpsvote::cps_read()` Will read all available years into
    memory, merging them in a data frame named `cps_vote`

## Advanced Use: Manually Adding Variables to the Output Dataset

Adding variables at this time is tricky, and we can’t guarantee yet that
it will work smoothly. However, if you wish to modify `cpsvote` to add
variables from individual years of the CPS, you can make edited versions
of the included objects `cps_cols` and `cps_factors`. To identify the
names, column locations, and factor levels for new variables, please
refer to the documentation for individual years of the CPS
(`cpsvote::cps_download_docs()`).

For an example, let’s say that I wanted to add annual family income in
2006 and 2008 to the default data. First, I would define the column
positions and factor levels for income and add them to the default
`cps_cols` and `cps_factors`.

``` r
library(cpsvote)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

income_cols <- data.frame(
  year = c(2006, 2008),
  cps_name = "HUFAMINC",
  new_name = "INCOME",
  start_pos = 39,
  end_pos = 40,
  stringsAsFactors = FALSE
)

income_factors <- data.frame(
  year = c(rep(2006, 16), rep(2008, 16)),
  cps_name = "HUFAMINC",
  new_name = "INCOME",
  code = c(1:16, 1:16),
  value = rep(c("LESS THAN $5,000",
                "5,000 TO 7,499",
                "7,500 TO 9,999",
                "10,000 TO 12,499",
                "12,500 TO 14,999",
                "15,000 TO 19,999",
                "20,000 TO 24,999",
                "25,000 TO 29,999",
                "30,000 TO 34,999",
                "35,000 TO 39,999",
                "40,000 TO 49,999",
                "50,000 TO 59,999",
                "60,000 TO 74,999",
                "75,000 TO 99,999",
                "100,000 TO 149,999",
                "150,000 OR MORE"), 2),
  stringsAsFactors = FALSE
)

my_cols <- bind_rows(cps_cols, income_cols)
my_factors <- bind_rows(cps_factors, income_factors)
```

Then, I read in the 2006 and 2008 CPS data using my new column data, and
factor it with my new factor data.

``` r
cps_income <- cps_read(years = c(2006, 2008),
                       cols = my_cols) %>%
  cps_label(factors = my_factors)
#> No new data files downloaded
#> Reading 2 data file(s)...
#> 2006 file read
#> 2008 file read
#> Warning in cps_read(years = c(2006, 2008), cols = my_cols): The column names
#> provided by the CPS do not refer to the same question across all years. Be
#> cautious that you are joining columns which correspond across years.
```

Now we can look at the unweighted breakdown of income by year.

``` r
janitor::tabyl(cps_income, INCOME, YEAR)
#>              INCOME  2006  2008
#>    LESS THAN $5,000  2800  2647
#>      5,000 TO 7,499  2224  1963
#>      7,500 TO 9,999  2188  2164
#>    10,000 TO 12,499  3447  2992
#>    12,500 TO 14,999  3057  2815
#>    15,000 TO 19,999  5046  4596
#>    20,000 TO 24,999  6352  5945
#>    25,000 TO 29,999  6833  6192
#>    30,000 TO 34,999  7213  6901
#>    35,000 TO 39,999  6662  6068
#>    40,000 TO 49,999 10231  9951
#>    50,000 TO 59,999 10604  9855
#>    60,000 TO 74,999 12607 12488
#>    75,000 TO 99,999 14291 13838
#>  100,000 TO 149,999 11881 12886
#>     150,000 OR MORE  8257  8936
#>                <NA> 39562 40562
```

## Examples of CPS data analysis

![](img/vote_mode.gif)
