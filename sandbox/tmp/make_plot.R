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

cpsvrs <- readRDS(here('tmp', 'cpsvrs.RDS'))

# It is necessary to use sample weights to obtain proper estimates from the CPS
cpsvrs_weighted <- cpsvrs %>%
  filter(CPS_YEAR > 1995) %>%
  srvyr::as_survey_design(weights = WEIGHT)

vote_mode <- cpsvrs_weighted %>%
  filter(!is.na(VOTEMETHOD_COLLAPSE)) %>%
  group_by(CPS_YEAR, CPS_STATE) %>%
  summarize(`Election day` = srvyr::survey_mean(VOTEMETHOD_COLLAPSE == 'Election day'),
            Mail = srvyr::survey_mean(VOTEMETHOD_COLLAPSE == 'Mail'),
            Early = srvyr::survey_mean(VOTEMETHOD_COLLAPSE == 'Early')) %>%
  select(-ends_with('_se'))

# This first plot is left in place in order to visually check the individual years
# size may not work correctly, so check output
ggplot(filter(vote_mode, CPS_YEAR == 2018), aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) +
  geom_text(vjust = "inward", hjust = "inward", size = 1.5) +
  coord_tern() +
  labs(y = "Election Day",
       title = "The Move Away From Election Day Voting in America: 1996-2018",
       subtitle = paste("Share of votes cast in federal elections, by mode",
                        "\nYear:", unique(filter(vote_mode, CPS_YEAR == 2018)$CPS_YEAR))) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, size = 8),
        plot.subtitle = element_text(hjust = 0.5, size = 6),
        axis.title = element_text(size = 5),
        axis.text = element_text(size = 4))

ggsave(filename = here('img', 'test_frame.png'),
       width = 4.25, height = 3.5)

# interpolate transition frames
tweened_data <- filter(vote_mode, CPS_YEAR == 1996) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, CPS_YEAR == 1998), 'linear', id = CPS_STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, CPS_YEAR == 2000), 'linear', id = CPS_STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, CPS_YEAR == 2002), 'linear', id = CPS_STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, CPS_YEAR == 2004), 'linear', id = CPS_STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, CPS_YEAR == 2006), 'linear', id = CPS_STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, CPS_YEAR == 2008), 'linear', id = CPS_STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, CPS_YEAR == 2010), 'linear', id = CPS_STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, CPS_YEAR == 2012), 'linear', id = CPS_STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, CPS_YEAR == 2014), 'linear', id = CPS_STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, CPS_YEAR == 2016), 'linear', id = CPS_STATE, nframes = 10) %>%
  keep_state(10) %>%
  tween_state(filter(vote_mode, CPS_YEAR == 2018), 'linear', id = CPS_STATE, nframes = 10) %>%
  keep_state(10) %>%
  mutate(CPS_YEAR = floor(CPS_YEAR / 2) * 2,
         check2 = `Election day` + Mail + Early)

# add the write directory, if it doesn't exist
dir.create(here('img', 'plot_frames'), showWarnings = FALSE)

for (frame in unique(tweened_data$.frame)) {
  ggplot(filter(tweened_data, .frame == frame), aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) +
    geom_text(vjust = "inward", hjust = "inward", size = 1.5) +
    coord_tern() +
    labs(y = "Election Day",
         title = "The Move Away From Election Day Voting in America: 1996-2018",
         subtitle = paste("Share of votes cast in federal elections, by mode",
                          "\nYear:", unique(filter(tweened_data, .frame == frame)$CPS_YEAR))) +
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

list.files(path = here('img', 'plot_frames'), pattern = "\\.png$", full.names = T) %>% 
  purrr::map(image_read) %>% # reads each path file
  image_join() %>% # joins image
  image_animate(fps=10) %>% # animates, can opt for number of loops
  image_write(here('img', 'vote_mode.gif')) # write to output directory

# optimize the gif, ImageMagick terminal
system('convert img/vote_mode.gif -coalesce  -layers OptimizeFrame  img/vote_mode.gif')
