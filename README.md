
<!-- README.md is generated from README.Rmd. Please edit the Rmd file -->

# `cpsvote`: A Social Science Toolbox for Using the Current Population Survey’s Voting and Registration Supplement

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/Reed-EVIC/cpsvote.svg?branch=master)](https://travis-ci.org/Reed-EVIC/cpsvote)
<!-- badges: end -->

<<<<<<< HEAD
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
=======
`cpsvote` helps you work with data from the Current Population Survey’s
(CPS) [Voting and Registration
Supplement](https://www.census.gov/topics/public-sector/voting/about.html)
(VRS), published by the U.S. Census Bureau and Bureau of Labor
Statistics. This high-quality, large-sample survey has been conducted
after every federal election (in November of even years) since 1964,
surveying Americans about their voting practices and registration. The
raw data, archived by the [National Bureau of Economic
Research](http://data.nber.org/data/current-population-survey-data.html),
is spread across several fixed-width files with different question
locations and formats.

This package consolidates common questions and provides the data in a
structure that is much easier to work with and interpret, since much of
the basic factor recoding has already been done. We also calculate
alternative sample weights based on demonstrated changes in non-response
bias over the decades, recommended by several elections researchers as a
best practice. Documentation of this reweighting is provided in
`vignette("voting")`.

We have provided access to VRS data from 1994 to 2018, and anticipate
updating the package when 2020 data becomes available.

## Installing and Loading the Package

[Version 0.1](https://cran.r-project.org/package=cpsvote) is on CRAN\!
>>>>>>> 7c79dff017ff8abe25ce01778e4e05ddce25a174

``` r
install.packages('cpsvote')
library(cpsvote)
```

You can also install the development version from our [GitHub
repository](https://github.com/Reed-EVIC/cpsvote).

``` r
remotes::install_github("Reed-EVIC/cpsvote")
library(cpsvote)
```

## Basic Use (AKA Tips if You Don’t Like Reading Documentation)

We have written several functions to transform the VRS from its original
format into a more workable structure. The easiest way to access the
data is with the `cps_load_basic()` command:

``` r
# Load All Years
# May take some time to download and process files the first time! 
cps <- cps_load_basic()  
```

``` r
# Just load 2006 and 2008
cps <- cps_load_basic(years = c(2006, 2008))
```

This will load the prepared VRS data into your environment as a tibble
called `cps`. The first time you try to load a given year of data, the
raw data file will be downloaded to your computer (defaulting to the
relative path “./cps\_data”). This can take some time depending on your
internet speeds. In future instances, R will just read from the data
files that have already been downloaded (defaulting to the same
“cps\_data” folder), as long as you correctly specify where these are
stored. See `?cps_allyears_10k` for a description of the columns and
fields that `cps_load_basic()` outputs.

We recommend using a single [R
project](https://r4ds.had.co.nz/workflow-projects.html) for your CPS
analysis where these files can be stored (this will work with the
default options), or storing one set of CPS files in a steady location
and specifying this absolute file path each time you load in the data.
If you specify a location that does not have the correct files, these
functions will attempt to re-download the data from NBER, which can take
up noticeable time and storage space.

We have also included a 10,000 row sample of the full VRS data, which
comes with the package as `cps_allyears_10k`. This is particularly
useful for planning out a given analysis before you download the full
data sets.

``` r
library(dplyr)
data("cps_allyears_10k")

cps_allyears_10k %>%
  select(1:3, VRS_VOTE:VRS_REG, VRS_VOTEMETHOD_CON, turnout_weight) %>%
  sample_n(10)
```

| FILE             | YEAR | STATE | VRS\_VOTE | VRS\_REG | VRS\_VOTEMETHOD\_CON | turnout\_weight |
| :--------------- | ---: | :---- | :-------- | :------- | :------------------- | --------------: |
| cps\_nov2012.zip | 2012 | VA    | YES       | NA       | ELECTION DAY         |        2219.511 |
| cps\_nov2010.zip | 2010 | MI    | YES       | NA       | ELECTION DAY         |        2205.806 |
| cps\_nov2008.zip | 2008 | CA    | NA        | NA       | NA                   |           0.000 |
| cps\_nov1996.zip | 1996 | CA    | YES       | NA       | ELECTION DAY         |        2949.914 |
| cps\_nov2000.zip | 2000 | TX    | YES       | NA       | EARLY                |        2257.311 |
| cps\_nov1996.zip | 1996 | CA    | YES       | NA       | ELECTION DAY         |        1581.404 |
| cps\_nov2000.zip | 2000 | OH    | YES       | NA       | ELECTION DAY         |        1869.228 |
| cps\_nov2004.zip | 2004 | TX    | NO        | NO       | NA                   |        4676.750 |
| cps\_nov1998.zip | 1998 | WI    | YES       | NA       | ELECTION DAY         |        2633.379 |
| cps\_nov1996.zip | 1996 | ND    | NA        | NA       | NA                   |           0.000 |

The CPS has survey weights that are necessary to calculate accurate
estimates about the US population. Two R packages that work with survey
weighting are [`survey`](http://r-survey.r-forge.r-project.org/survey/)
and [`srvyr`](https://github.com/gergness/srvyr) (a tidyverse-compatible
wrapper for `survey`). You can see more examples and details on
weighting in `vignette("voting")`, but here is one example of using
`srvyr` to calculate state-level voter turnout among eligible voters in
2018.

``` r
<<<<<<< HEAD
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
=======
library(srvyr)

cps18_weighted <- cps_load_basic(years = 2018, datadir = here::here('cps_data')) %>%
  as_survey_design(weights = turnout_weight)

turnout18 <- cps18_weighted %>%
  group_by(STATE) %>%
  summarize(turnout = survey_mean(hurachen_turnout == "YES", na.rm = TRUE))

head(turnout18, 10)
>>>>>>> 7c79dff017ff8abe25ce01778e4e05ddce25a174
```

| STATE |   turnout | turnout\_se |
| :---- | --------: | ----------: |
| AL    | 0.4689987 |   0.0136831 |
| AK    | 0.5445797 |   0.0192402 |
| AZ    | 0.4691557 |   0.0158490 |
| AR    | 0.4096583 |   0.0140608 |
| CA    | 0.4834399 |   0.0073204 |
| CO    | 0.5996610 |   0.0209483 |
| CT    | 0.5416752 |   0.0193049 |
| DE    | 0.5079879 |   0.0186637 |
| DC    | 0.4242351 |   0.0156001 |
| FL    | 0.5361329 |   0.0103791 |

These estimates follow closely Dr. Michael McDonald’s [estimates of
turnout](http://www.electproject.org/2018g) among eligible voters in the
November 2018 General Election. For a detailed examination of how
non-response bias has affected the use of CPS for estimating turnout,
see `vignette("voting")`. We thank the U.S. Elections Project at the
University of Florida for the turnout estimates.

## Advanced Use

In addition to the basic function listed above, you can customize
several steps in the process of reading in the VRS data. If you’ve
worked with the CPS before, you may already have some code to read in
analyze this survey data. We still hope that this package can help you
organize your workflow or ease some of the more tedious steps necessary
to work with the CPS.

Be sure to refer to the CPS documentation files when working with
alternative versions of the VRS data. We have included the function
`cps_download_docs()` to provide the documentation versions that match
this data. These are all in PDF format (and several are not text-based),
so they are not easy to search through.

`cps_load_basic()` is a wrapper for several constituent steps that have
their own parameters and assumptions. We’ve detailed the changes made to
get from the raw data file to the cleaned file in
`vignette("add-variables")`.

``` r
cps_download_data(path = "cps_data",
                  years = seq(1994, 2018, 2))
cps_download_docs(path = "cps_data",
                  years = seq(1994, 2018, 2))

cps_read(years = seq(1994, 2018, 2),
         dir = "cps_data",
         cols = cpsvote::cps_cols,
         names_col = "new_name",
         join_dfs = TRUE) %>%
    cps_label(factors = cpsvote::cps_factors,
              names_col = "new_name",
              na_vals = c("-1", "BLANK", "NOT IN UNIVERSE"),
              expand_year = TRUE,
              rescale_weight = TRUE,
              toupper = TRUE) %>%
    cps_refactor(move_levels = TRUE) %>%
    cps_recode_vote(vote_col = "VRS_VOTE",
                    items = c("DON'T KNOW", "REFUSED", "NO RESPONSE")) %>%
    cps_reweight_turnout()
```

  - `cps_download_data()` will download the data files from NBER
    according to `years` into the folder at `path`. This is
    automatically called by `cps_read()` when the CPS data files are not
    found in the provided `dir` - it will search for files with the
    4-digit year associated with their data.
  - `cps_download_docs()` will downlaod the pdf documentation into
    `path` for each year supplied in `years`.The documentation here is
    aligned with the NBER data, and other data sources (such as ICPSR)
    may have edited the data such that their data or documentation does
    not line up with the NBER data and documentation. By using the NBER
    data through `cps_download_docs()`, you can make sure that the
    fields you look up in documentation are the proper fields referenced
    in the data.
  - `cps_read()` is the function that actually loads in the original,
    (mostly) numeric data from files defined by the arguments `years`
    and `dir`. Since the raw data is in fixed-width files, you have to
    define the range of characters that are read. You can see the
    default set of columns in the included data set `cps_cols`, or
    supply `cols` with your own specifications of columns (for details
    on adding other columns, see `vignette("add-variables")`). The
    `names_col` argument details which variable in `cols` will become
    the column names for the output; we have provided the original CPS
    names as `cps_name`, but recommend using `new_name` as it is more
    informative and accounts for questions changing names (“PES5”,
    “PES6”, etc.) across multiple years. `join_dfs` lets you join
    multiple years into one `tibble`, and should only be used if you’re
    sure that a column name (like “PES5”) refers to the same question
    across all years you read in.
  - `cps_label()` replaces the numeric entries from the raw data with
    appropriate factor levels (as given by the data documentation; see
    `cps_download_docs()`). We have taken the factor levels as written
    from the PDFs, including capitalization, typos, and differences
    across years. This is provided in the included `cps_factors`
    dataset, but you can supply the `factors` argument with your own
    coding (for details on changing factor levels or adding them for a
    new column, see `vignette("add-variables")`). The `names_col`
    argument defines which column of `factors` contains the column names
    that match the incoming data set to be labelled. Further: `na_vals`
    defines which factor levels should be marked as `NA`, `expand_year`
    turns the two-digit years in some files into four-digit years
    (e.g. “94” becomes “1994”), and `rescale_weight` divides the
    given weight by 10,000 (as noted by the data documentation) to
    ensure accurate population sums. `toupper` will make all the factor
    levels upper case, which is useful because as-is the factors are a
    mix of sentence case and upper case.
  - `cps_refactor` deals with all of the typos, capitalization, and
    shifting questions across years. We have attempted here to
    consolidate factor levels and variables in a way that makes sense.
    For example, one common method of assessing vote mode (in-person on
    Election Day, early in-person, or by mail) has been split between
    two separate questions from 2004 onwards, and this function
    consolidates those two questions (and the one question of previous
    surveys) into one `VRS_VOTEMETHOD_CON` variable. Note that this
    function will only work with certain column names in the data; see
    `?cps_refactor` for more details.
  - `cps_recode_vote()` recodes the variable `VRS_VOTE` according to two
    different assessments of voter turnout. The new variable
    `cps_turnout` will calculate turnout the same way that the Census
    does, while another new variable `hurachen_turnout` will calculate
    turnout according to Hur & Achen (2013). These two methods differ in
    how they count responses of “Don’t know”, “Refused”, and “No
    response”; see `vignette("background")` for more details.
  - `cps_reweight_turnout()` adds a new variable, `turnout_weight`, that
    reweights the original `WEIGHT` according to Hur & Achen (2013) to
    account for the adjusted turnout measure. This corrects for
    increased nonresponse to the VRS over time, as well as a general
    pattern of respondents overreporting their personal voting history
    (though the CPS sees less overreporting than other surveys). See
    `vignette("background")` for details.

You can use different combinations of these functions to customize which
CPS data is read in. For example, this code would load the 2014 VRS data
with the original column names and numeric data.

``` r
cps14 <- cps_read(2014, names_col = "cps_name")
```

You can then apply factor labels to this data.

``` r
cps14_lab <- cps_label(cps14, names_col = "cps_name")
```

Note that some features (like `cps_refactor()`) won’t work on certain
customized versions of the data, because they are relatively hard-coded
based on specific column names. For example, correcting “HIPSANIC” to
“HISPANIC” only works if you know which column represents the Hispanic
flag. Feel free to take the code from functions like this and adapt
based on your own column names.

## Examples, Background Reading, and Data Sources

  - Vignettes:
      - `vignette("basics")` provides an intro to the package with some
        basic instructions for use, and mirrors our [GitHub
        README](https://github.com/Reed-EVIC/cpsvote)
      - `vignette("background")` describes our intellectual rationale
        for creating this package
      - `vignette("add-variables")` describes how additional variables
        from the CPS can be merged with the default dataset
      - `vignette("voting")` does a deep dive into how to use the CPS
        and the default datasets from `cpsvote` to look at voter turnout
        and mode of voting
  - Aram Hur, Christopher H. Achen. *Coding Voter Turnout Responses in
    the Current Population Survey*. Public Opinion Quarterly, Volume 77,
    Issue 4, Winter 2013, Pages 985–993.
    <https://doi.org/10.1093/poq/nft042>
  - Michael McDonald. *What’s Wrong with the CPS?* Presented at the 2014
    American Political Science Association Conference, Washington, D.C.,
    August 27-31.
    <http://www.electproject.org/home/voter-turnout/cps-methodology>
  - The [Current Population
    Survey](https://www.census.gov/programs-surveys/cps.html) is
    conducted monthly by the U.S. Census Bureau and the Bureau of Labor
    Statistics, and the Voting and Registration Supplement is
    administered as part of this survey after each federal election. The
    [CPS
    data](http://data.nber.org/data/current-population-survey-data.html)
    that this package downloads is provided by the [National Bureau of
    Economic Research](https://data.nber.org/info.html).
  - This is an animated ternary plot made using vote mode data from
    `cpsvote`. See NOT YET WRITTEN vignette for the code that created
    this.

![](img/vote_mode.gif)

## Acknowledgements

The `cpsvote` package was originally created at the [Early Voting
Information Center at Reed College](https://evic.reed.edu/). We are
indebted to support from the [Elections Team at the Democracy
Fund](https://democracyfund.org/) and [Reed
College](https://www.reed.edu/) for supporting the work of EVIC.
