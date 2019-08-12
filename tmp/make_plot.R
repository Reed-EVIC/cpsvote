library(here)
library(dplyr)
library(srvyr)
library(ggplot2)
library(ggtern)
library(gganimate)
library(magick)


# The data file was created by "combine_survey_years.R"
load(here('tmp', 'cpsvrs.RData'))

# It is necessary to use sample weights to obtain proper estimates from the CPS
cpsvrs_weighted <- cpsvrs %>%
  filter(CPS_YEAR > 1995) %>%
  as_survey_design(weights = WEIGHT)

# Creates an output data frame that contains estimates of the rates of voting, by
# year, for Election Day, Early in Person, and Vote By Mail

threevote <- cpsvrs_weighted %>%
  mutate(CPS_YEAR = factor(CPS_YEAR, ordered = TRUE)) %>%
  filter(!is.na(VOTEMETHOD_COLLAPSE)) %>%
  group_by(CPS_YEAR, CPS_STATE) %>%
  summarize(`Election day` = survey_mean(VOTEMETHOD_COLLAPSE == 'Election day'),
            Mail = survey_mean(VOTEMETHOD_COLLAPSE == 'Mail'),
            Early = survey_mean(VOTEMETHOD_COLLAPSE == 'Early')) %>%
  select(-ends_with('_se')) %>%
  mutate(check = `Election day` + Mail + Early)
threevote$CPS_YEAR <- as.numeric(levels(threevote$CPS_YEAR))[threevote$CPS_YEAR]


# This first plot is left in place in order to visually check the individual years
ggplot() + coord_tern() +
  geom_text(data = threevote, aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) +
            facet_wrap(~CPS_YEAR) 

# INDIVIDUAL YEAR PLOTS 
#
# This next set of steps should be handled via some sort of loop
#
# Individual ternary plots are made for each year from 1996 - 2016 and saved as PNG files
#


ggplot() + coord_tern() +
  geom_text(data = subset(threevote, CPS_YEAR == 1996), aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) 
ggsave(filename = "~/Downloads/pngs/v1996.png")

ggplot() + coord_tern() +
  geom_text(data = subset(threevote, CPS_YEAR == 1998), aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) 
ggsave(filename = "~/Downloads/pngs/v1998.png")

ggplot() + coord_tern() + 
  geom_text(data = subset(threevote, CPS_YEAR == 2000), aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) 
ggsave(filename = "~/Downloads/pngs/v2000.png")

ggplot() + coord_tern() + 
  geom_text(data = subset(threevote, CPS_YEAR == 2002), aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) 
ggsave(filename = "~/Downloads/pngs/v2002.png")

ggplot() + coord_tern() + 
  geom_text(data = subset(threevote, CPS_YEAR == 2004), aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) 
ggsave(filename = "~/Downloads/pngs/v2004.png")

ggplot() + coord_tern() + 
  geom_text(data = subset(threevote, CPS_YEAR == 2006), aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) 
ggsave(filename = "~/Downloads/pngs/v2006.png")

ggplot() + coord_tern() + 
  geom_text(data = subset(threevote, CPS_YEAR == 2008), aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) 
ggsave(filename = "~/Downloads/pngs/v2008.png")

ggplot() + coord_tern() + 
  geom_text(data = subset(threevote, CPS_YEAR == 2010), aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) 
ggsave(filename = "~/Downloads/pngs/v2010.png")

ggplot() + coord_tern() + 
  geom_text(data = subset(threevote, CPS_YEAR == 2012), aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) 
ggsave(filename = "~/Downloads/pngs/v2012.png")

ggplot() + coord_tern() + 
  geom_text(data = subset(threevote, CPS_YEAR == 2014), aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) 
ggsave(filename = "~/Downloads/pngs/v2014.png")

ggplot() + coord_tern() + 
  geom_text(data = subset(threevote, CPS_YEAR == 2016), aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) 
ggsave(filename = "~/Downloads/pngs/v2016.png")

# This does the magic of stringing together the files to make an animated gif
#
# Thanks to Ryan Peek for a clear explication of using ImageMagick to create animated
# gifs in R. https://ryanpeek.github.io/2016-10-19-animated-gif_maps_in_R/

list.files(path = "~/Downloads/pngs", pattern = "*.png", full.names = T) %>% 
       map(image_read) %>% # reads each path file
       image_join() %>% # joins image
       image_animate(fps=2) %>% # animates, can opt for number of loops
       image_write("~/Downloads/test3.gif") # write to output directory


