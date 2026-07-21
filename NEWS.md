# cpsvote 0.2

- Add `cps_check_codes()`, which warns when a response documented in the codebook (e.g. the `-9` "No Response" code for `PES1`/`VRS_VOTE`) is entirely absent from a given year's data. `cps_recode_vote()` now calls this automatically. This catches a real discontinuity: the Census Bureau's public-use file stops including any `-9` respondents starting in 2022, without documenting the change (see `vignette("voting")` for details, h/t Michael Hanmer)
- Include new 2020, 2022, and 2024 CPS VRS data
- Note: 2024 microdata downloaded from Census Bureau (not NBER); VEP reweighting data from University of Florida Election Lab
- Update maintainer and copyright info
- Change PDF download method for Windows
- Add new dataset, a 10k row sample of the raw 2020 CPS VRS
- Add new user option to set cps_data directory, otherwise this defaults to a single location so duplicate copies of the data are avoided.
- Validation vignette demonstrates how the reweighting corrects turnout estimates

# cpsvote 0.1

- Initial submission to CRAN
