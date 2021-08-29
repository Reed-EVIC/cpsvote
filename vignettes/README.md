# `cpsvote` Vignette Writing Guide

Vignettes have a [few extra steps](https://r-pkgs.org/vignettes.html#vignette-metadata) that make them different from regular R markdown documents. For example, the YAML of a vignette might have several extra arguments necessary to attach to the R package correctly.

```
---
title: "Using the CPS and `cpsvote` to Understand Voting"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{voting}
  %\VignetteEncoding{UTF-8}
  \usepackage[utf8]{inputenc}
  %\VignetteEngine{knitr::rmarkdown}
editor_options: 
  chunk_output_type: console
---
```

Additionally, there are some steps we can take to reduce the burden on users (and CRAN) of running the `cpsvote` vignettes.

- First, try to avoid calls that require reading a raw `cpsvote` data set. There are three built-in package data sets which you can substitute instead: `cps_allyears_10k` for analyses across several years, plus `cps_2020_10k` and `cps_2016_10k` for analyses focused on a single year. The latter are 10,000 rows from each of the 2020 and 2016 surveys in a more "raw" format, and are best for things like demonstrating data transformation paths and calculating state-level statistics (where the multi-year sample might not have enough cases from each state in a given year to be representative).
- If you must read in a raw `cpsvote` data set (like in [`add-variables.Rmd`](add-variables.Rmd)), you should always refer to the data directory at the root of a project directory, rather than in whichever folder the vignettes live. You can accomplish this by setting `datadir = here::here('cps_data')` in the call to your function (perhaps `read_cps()`).
- Any vignette which takes more than a few seconds to run should be set up so that CRAN will skip over trying to run it during the package build and testing. You can set this up by adding the following code to your setup R chunk:

```
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN,
  eval = NOT_CRAN
)
```
