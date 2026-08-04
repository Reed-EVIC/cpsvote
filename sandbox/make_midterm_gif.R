# Animated ternary plot of vote mode share by state, midterm election years
# only (1998-2022). One dot per state per year.

library(here)
source(here("sandbox", "ternary_gif_lib.R"))

vote_mode <- readRDS(here("sandbox", "vote_mode_data.rds"))

years_seq <- seq(1998, 2022, 4)

make_vote_mode_gif(
  vote_mode = vote_mode,
  years_seq = years_seq,
  output_gif = here("sandbox", "midterm_vote_mode.gif"),
  title = "The Move Away From Election Day Voting in America",
  subtitle = "Midterm elections: share of votes cast by mode, 1998-2022"
)

cat("Wrote", here("sandbox", "midterm_vote_mode.gif"), "\n")
