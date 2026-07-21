# Animated ternary plot of Massachusetts's vote mode share over time
# (1996-2024), all years. A single dot labeled "MA", with a trail showing
# its path through the ternary space over time.

library(here)
library(dplyr)
source(here("sandbox", "ternary_gif_lib.R"))

vote_mode <- readRDS(here("sandbox", "vote_mode_data.rds")) %>%
  filter(STATE == "MA")

years_seq <- seq(1996, 2024, 2)

make_vote_mode_gif(
  vote_mode = vote_mode,
  years_seq = years_seq,
  output_gif = here("sandbox", "massachusetts_vote_mode.gif"),
  title = "The Move Away From Election Day Voting in Massachusetts",
  subtitle = "Share of votes cast by mode, 1996-2024",
  highlight_states = c("MA"),
  highlight_color = "red",
  trail = TRUE
)

cat("Wrote", here("sandbox", "massachusetts_vote_mode.gif"), "\n")
