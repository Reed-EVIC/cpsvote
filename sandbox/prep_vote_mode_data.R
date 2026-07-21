# Purpose: Build the weighted YEAR x STATE vote-mode share table used by the
# three ternary-plot GIF scripts (presidential years, midterm years, MA-only).
# This is the same data-prep pipeline as sandbox/animate_snowglobe.R, factored
# out so it only needs to run once.

library(dplyr)
library(tidyr)
library(srvyr)
library(here)

devtools::load_all(here(), quiet = TRUE)

options(cpsvote.datadir = here("cps_data"))

cps <- cps_load_basic(years = seq(1996, 2024, 2))

cps_weighted <- cps %>%
  filter(YEAR > 1995) %>%
  srvyr::as_survey_design(weights = turnout_weight)

vote_mode <- cps_weighted %>%
  select(YEAR, STATE, VRS_VOTEMETHOD_CON) %>%
  filter(if_all(everything(), ~ !is.na(.x))) %>%
  group_by(YEAR, STATE, VRS_VOTEMETHOD_CON) %>%
  summarize(survey_mean(na.rm = TRUE)) %>%
  select(-ends_with('_se')) %>%
  pivot_wider(id_cols = c("YEAR", "STATE"), names_from = "VRS_VOTEMETHOD_CON", values_from = "coef",
              values_fill = 0)

saveRDS(vote_mode, here("sandbox", "vote_mode_data.rds"))

cat("Saved", nrow(vote_mode), "rows across years:", paste(sort(unique(vote_mode$YEAR)), collapse = ", "), "\n")
