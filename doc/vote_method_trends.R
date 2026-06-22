## ----include = FALSE, echo = FALSE--------------------------------------------
options(rmarkdown.html_vignette.check_title = FALSE)
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", 
  message = FALSE, warning = FALSE,
  fig.width = 6, fig.height = 3,
  purl = NOT_CRAN,
  eval = NOT_CRAN
)
library(knitr)
library(cpsvote)

