# Animated ternary plot of vote mode share by state, presidential election
# years only (1996-2024). One dot per state per year.

library(here)
source(here("sandbox", "ternary_gif_lib.R"))

vote_mode <- readRDS(here("sandbox", "vote_mode_data.rds"))

years_seq <- seq(1996, 2024, 4)

make_vote_mode_gif(
  vote_mode = vote_mode,
  years_seq = years_seq,
  output_gif = here("sandbox", "presidential_vote_mode.gif"),
  title = "The Move Away From Election Day Voting in America",
  subtitle = "Presidential elections: share of votes cast by mode, 1996-2024"
)

cat("Wrote", here("sandbox", "presidential_vote_mode.gif"), "\n")
