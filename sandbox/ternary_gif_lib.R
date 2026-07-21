# Shared helpers for rendering animated ternary plots of vote mode share
# (Election Day / Early In-Person / Mail-VBM), in the same visual style as
# img/MDvote_mode.gif. Used by make_presidential_gif.R, make_midterm_gif.R,
# and make_massachusetts_gif.R.

library(dplyr)
library(tweenr)
library(ggtern)
library(magick)
library(here)

#' Tween a YEAR x STATE vote-mode table across a sequence of anchor years,
#' holding on each anchor and smoothly interpolating between them.
build_tweened_frames <- function(vote_mode, years_seq, nframes_hold = 10, nframes_transition = 10) {
  vote_mode <- ungroup(vote_mode)
  years_seq <- sort(unique(years_seq))
  gap <- min(diff(years_seq))

  frames <- filter(vote_mode, YEAR == years_seq[1]) %>%
    keep_state(nframes_hold)

  for (yr in years_seq[-1]) {
    frames <- frames %>%
      tween_state(filter(vote_mode, YEAR == yr), 'linear', id = STATE, nframes = nframes_transition) %>%
      keep_state(nframes_hold)
  }

  frames %>%
    mutate(YEAR = floor((YEAR - years_seq[1]) / gap) * gap + years_seq[1])
}

#' Render one ternary-plot frame per unique .frame value in `tweened_data` and
#' write the resulting PNGs to `frame_dir`.
render_frames <- function(tweened_data, frame_dir, title, subtitle,
                           highlight_states = c(), highlight_color = "red",
                           trail = FALSE, width = 4.25, height = 3.5) {
  dir.create(frame_dir, showWarnings = FALSE, recursive = TRUE)

  tweened_data <- tweened_data %>%
    ungroup() %>%
    mutate(highlight = STATE %in% highlight_states)

  trail_data <- if (trail && length(highlight_states) == 1) {
    tweened_data %>%
      filter(STATE == highlight_states[1]) %>%
      select(.frame, `ELECTION DAY`, `BY MAIL`, EARLY)
  } else {
    NULL
  }

  for (frame in unique(tweened_data$.frame)) {
    frame_data <- filter(tweened_data, .frame == frame)
    yr <- unique(frame_data$YEAR)

    p <- ggplot(frame_data,
                aes(y = `ELECTION DAY`, x = `BY MAIL`, z = EARLY, label = STATE, colour = highlight)) +
      geom_text(vjust = 0.5, hjust = 0.5, size = 1.5, position = "identity") +
      scale_colour_manual(values = c("FALSE" = "black", "TRUE" = highlight_color), guide = "none") +
      coord_tern() +
      labs(x = "Mail",
           y = "Election Day",
           z = "Early",
           title = title,
           subtitle = paste0(subtitle, "\nYear: ", yr)) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5, size = 8),
            plot.subtitle = element_text(hjust = 0.5, size = 6),
            axis.title = element_text(size = 5),
            axis.text = element_text(size = 4))

    if (!is.null(trail_data)) {
      p <- p + geom_path(data = filter(trail_data, .frame <= frame),
                          aes(y = `ELECTION DAY`, x = `BY MAIL`, z = EARLY, group = 1),
                          colour = highlight_color, inherit.aes = FALSE, linewidth = 0.5)
    }

    ggsave(plot = p,
           filename = file.path(frame_dir, paste0('frame', stringr::str_pad(frame, width = 4, pad = "0"), '.png')),
           width = width, height = height)
  }
}

#' Stitch the PNGs in `frame_dir` into a GIF at `output_gif`.
write_gif <- function(frame_dir, output_gif, fps = 10) {
  list.files(path = frame_dir, pattern = "\\.png$", full.names = TRUE) %>%
    sort() %>%
    purrr::map(image_read) %>%
    image_join() %>%
    image_animate(fps = fps) %>%
    image_write(output_gif)
}

#' End-to-end: tween, render frames, write gif, clean up frame_dir.
make_vote_mode_gif <- function(vote_mode, years_seq, output_gif, title, subtitle,
                                highlight_states = c(), highlight_color = "red",
                                trail = FALSE, fps = 10,
                                nframes_hold = 10, nframes_transition = 10,
                                frame_dir = NULL, cleanup = TRUE) {
  if (is.null(frame_dir)) {
    frame_dir <- file.path(tempdir(), paste0("frames_", tools::file_path_sans_ext(basename(output_gif))))
  }

  tweened <- build_tweened_frames(vote_mode, years_seq, nframes_hold, nframes_transition)
  render_frames(tweened, frame_dir, title, subtitle,
                highlight_states = highlight_states, highlight_color = highlight_color,
                trail = trail)
  write_gif(frame_dir, output_gif, fps = fps)

  if (cleanup) unlink(frame_dir, recursive = TRUE)

  invisible(output_gif)
}
