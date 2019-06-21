library(here)
library(dplyr)
library(srvyr)
library(ggplot2)
library(ggtern)
library(gganimate)

load(here('tmp', 'cpsvrs.RData'))

cpsvrs_weighted <- as_survey_design(cpsvrs, weights = WEIGHT)

threevote <- cpsvrs_weighted %>%
  mutate(CPS_YEAR = factor(CPS_YEAR, ordered = TRUE)) %>%
  filter(!is.na(VRS_VOTEMETHOD_COLLAPSE)) %>%
  group_by(CPS_YEAR, CPS_STATE) %>%
  summarize(`Election day` = survey_mean(VRS_VOTEMETHOD_COLLAPSE == 'Election day'),
            Mail = survey_mean(VRS_VOTEMETHOD_COLLAPSE == 'Mail'),
            Early = survey_mean(VRS_VOTEMETHOD_COLLAPSE == 'Early')) %>%
  select(-ends_with('_se')) %>%
  mutate(check = `Election day` + Mail + Early)
threevote$CPS_YEAR <- as.numeric(levels(threevote$CPS_YEAR))[threevote$CPS_YEAR]

ggplot() + coord_tern() +
  geom_text(data = threevote, aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) +
  facet_wrap(~CPS_YEAR)

ggplot() + coord_tern() +
  geom_text(data = threevote, aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) +
  labels(y = "Election day")


# okay so gganimate and ggtern don't play nice together
# now we try to hack around the back end with tweenr
# this is also currently not working, but might be closer at some point
# it's making a gif, but the plot itself doesn't look like what I want it to

test <- mutate(threevote,
               ease = 'linear',
               CPS_YEAR = as.numeric(CPS_YEAR)) %>%
  tween_elements(time = 'CPS_YEAR', group = 'CPS_STATE', ease = 'ease', nframes = 270)


img3 <- image_graph(res = 96)
datalist3 <- split(test, test$.frame)
out3 <- lapply(datalist3, function(data){
  p3 <- ggplot() + coord_tern() +
    geom_text(data = threevote, aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE))
  print(p3)
})
dev.off()
animation3 <- image_animate(img3, fps = 20)
image_write(animation3, "animation3.gif")
