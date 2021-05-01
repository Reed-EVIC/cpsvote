# Date: 14 August 2019
# Author: Jay Lee, Paul Gronke
# Purpose: Creates an animated ternary plot of voting modes over time
# Note: Runs in about 5 minutes on Jay's machine
# Also note: May run into disk size limits if significantly modified

library(here)
library(dplyr)
library(srvyr)
library(tweenr)
library(ggtern)
library(rlang)
library(magick)

cps <- cps_load_basic()

# It is necessary to use sample weights to obtain proper estimates from the CPS
cps_weighted <- cps %>%
  filter(YEAR > 1995) %>%
  srvyr::as_survey_design(weights = turnout_weight)

vote_mode <- cps_weighted %>%
  select(YEAR, STATE, VRS_VOTEMETHOD_CON) %>%
  filter(across(everything(), function (x) !is.na(x))) %>%
  group_by(YEAR, STATE, VRS_VOTEMETHOD_CON) %>%
  summarize(survey_mean(na.rm = TRUE)) %>%
  select(-ends_with('_se')) %>%
  pivot_wider(id_cols = c("YEAR", "STATE"), names_from = "VRS_VOTEMETHOD_CON", values_from = "coef",
              values_fill = 0)

# This first plot is left in place in order to visually check the individual years
# size may not work correctly, so check output
ggplot(filter(vote_mode, YEAR == 2018), aes(y = `ELECTION DAY`, x = `BY MAIL`, z = EARLY, label = STATE)) +
  geom_text(vjust = "inward", hjust = "inward", size = 1.5) +
  coord_tern() +
  labs(x = "Mail",
       y = "Election Day",
       z = "Early",
       title = "The Move Away From Election Day Voting in America: 1996-2020",
       subtitle = paste("Share of votes cast in federal elections, by mode",
                        "\nYear:", unique(filter(vote_mode, YEAR == 2018)$YEAR))) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, size = 8),
        plot.subtitle = element_text(hjust = 0.5, size = 6),
        axis.title = element_text(size = 5),
        axis.text = element_text(size = 4))

ggsave(filename = here('img', 'test_frame.png'),
       width = 4.25, height = 3.5)

# interpolate transition frames
tweened_data <- filter(vote_mode, YEAR == 1996) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, YEAR == 1998), 'linear', id = STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, YEAR == 2000), 'linear', id = STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, YEAR == 2002), 'linear', id = STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, YEAR == 2004), 'linear', id = STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, YEAR == 2006), 'linear', id = STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, YEAR == 2008), 'linear', id = STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, YEAR == 2010), 'linear', id = STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, YEAR == 2012), 'linear', id = STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, YEAR == 2014), 'linear', id = STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, YEAR == 2016), 'linear', id = STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, YEAR == 2018), 'linear', id = STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, YEAR == 2020), 'linear', id = STATE, nframes = 10) %>%
  keep_state(10) %>%
  mutate(YEAR = floor(YEAR / 2) * 2,
         check2 = `ELECTION DAY` + `BY MAIL` + EARLY)

# add the write directory, if it doesn't exist
dir.create(here('img', 'plot_frames'), showWarnings = FALSE)

for (frame in unique(tweened_data$.frame)) {
  ggplot(filter(tweened_data, .frame == frame), aes(y = `ELECTION DAY`, x = `BY MAIL`, z = EARLY, label = STATE)) +
    geom_text(vjust = "inward", hjust = "inward", size = 1.5) +
    coord_tern() +
    labs(x = "Mail",
         y = "Election Day",
         z = "Early",
         title = "The Move Away From Election Day Voting in America: 1996-2020",
         subtitle = paste("Share of votes cast in federal elections, by mode",
                          "\nYear:", unique(filter(tweened_data, .frame == frame)$YEAR))) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5, size = 8),
          plot.subtitle = element_text(hjust = 0.5, size = 6),
          axis.title = element_text(size = 5),
          axis.text = element_text(size = 4))
  ggsave(filename = here('img', 
                         'plot_frames',
                         paste0('frame', stringr::str_pad(frame, width = 3, pad = "0"), '.png')),
         width = 4.25, height = 3.5)
}

# optimize all these png files, ImageMagick terminal
system('find ./img/plot_frames -name "*.png" -exec convert "{}" -strip "{}" \\; -exec echo "{}" \\;')

# write the gif
list.files(path = here('img', 'plot_frames'), pattern = "\\.png$", full.names = T) %>% 
  purrr::map(image_read) %>% # reads each path file
  image_join() %>% # joins image
  image_animate(fps=10) %>% # animates, can opt for number of loops
  image_write(here('img', 'vote_mode.gif')) # write to output directory

# optimize the gif, ImageMagick terminal
system('convert img/vote_mode.gif -coalesce  -layers OptimizeFrame  img/vote_mode.gif')
