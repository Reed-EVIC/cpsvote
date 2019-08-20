
#' Create an animated ternary plot
#' 
#' @param data The data.frame containing variables corresponding to 
#' time, units of observation changing over time, and three data values 
#' @param out The file location to write the output GIF
#' @param time A column of `data` (as a character), interpreted as states to 
#' transition the animation between
#' @param case A column of `data` (as a character), interpreted as observations 
#' that change between the different states
#' @param tern_vars A vector of three columns of `data` (as a character), 
#' containing values for each case at each state. These should sum to 1, and 
#' will be scaled to do so
#' @param state_time The length of time (in seconds) that each state should 
#' occupy in the output GIF
#' @param transition_time The length of time (in seconds) that each transition 
#' between states should occupy in the output GIF
#' @param fps The frame rate (frames per second) of the output GIF
#' @param plot_show A string describing how cases should be plotted. Current 
#' options are:
#' - "text_label", which plots the case name using `geom_text`
#' - "point_color", which uses `geom_point` with case mapping to color
tern_animate <- function(data, out, time, case, tern_vars,
                         state_time = 1, transition_time = 1, fps = 10,
                         plot_show = "text_label") {
  # enforce rules on inputs
  # data must be a data.frame
  if(!is.data.frame(data)) warning('Variable "data" must be a data.frame')
  
  # tern_vars must be length 3 character
  if (!is.character(tern_vars)) stop('Variable "tern_vars" must be character')
  if (length(tern_vars) != 3) {
    stop('Variable "tern_vars" must have length three')
  }
  
  # time must be length 1 character
  if (!is.character(time)) stop('Variable "time" must be character')
  if (length(time) < 1) {
    stop('Variable "time" must have length one')
  } else if (length(time) > 1) {
    warning('Variable "time" must have length one; first value was used')
    time <- time[1]
  }
  
  # case must be length 1 character
  if (!is.character(case)) stop('Variable "case" must be character')
  if (length(case) < 1) {
    stop('Variable "case" must have length one')
  } else if (length(case) > 1) {
    warning('Variable "case" must have length one; first value was used')
    case <- case[1]
  }
  
  # time, case, and tern_vars must be column names of data
  if(!(time %in% colnames(data))) {
    warning('Variable "time" must be a column name of "data"')
  }
  if(!(case %in% colnames(data))) {
    warning('Variable "case" must be a column name of "data"')
  }
  if(!all(tern_vars %in% colnames(data))) {
    warning('Variables "tern_vars" must all be column names of "data"')
  }
  
  # tern_vars must sum to 1
  # FINISH
  rowSums(data[[tern_vars]]) == 1
  
  # state_time, transition_time, and fps must all be length-one numerics
  if (!is.numeric(state_time)) stop('Variable "state_time" must be numeric')
  if (length(state_time) < 1) {
    stop('Variable "state_time" must have length one')
  } else if (length(state_time) > 1) {
    warning('Variable "state_time" must have length one; first value was used')
    state_time <- state_time[1]
  }
  
  if (!is.numeric(transition_time)) {
    stop('Variable "transition_time" must be numeric')
  }
  if (length(transition_time) < 1) {
    stop('Variable "transition_time" must have length one')
  } else if (length(transition_time) > 1) {
    warning('Variable "transition_time" must have length one; first value used')
    transition_time <- transition_time[1]
  }
  
  if (!is.numeric(fps)) stop('Variable "fps" must be numeric')
  if (length(fps) < 1) {
    stop('Variable "fps" must have length one')
  } else if (length(fps) > 1) {
    warning('Variable "fps" must have length one; first value was used')
    fps <- fps[1]
  }
  
  if (!is.factor(data[[time]])) stop('Variable "time" must be a factor')
  if (!is.ordered(data[[time]])) {
    warning('Factor variable "time" not ordered, animation ordering will be assigned automatically')
  }
  
  
  
  # calculate internal frame counts
  state_frames <- state_time * fps
  transition_frames <- transition_time * fps
  n_states <- length(levels(data[[time]]))
  total_frames <- n_states * state_frames + (n_states - 1) * transition_frames
  
  # separate time chunks
  time_markers <- levels(data[[time]])
  
  tweened_data <- filter(data, !!rlang::sym(time) == time_markers[1]) %>%
    keep_state(state_frames)
  
  for (time_state in time_markers[-1]) {
    tweened_data <- tweened_data %>%
      tween_state(to = filter(data, !!rlang::sym(time) == time_state), 
                  ease = 'linear', 
                  id = !!rlang::sym(case), 
                  nframes = transition_frames) %>%
      keep_state(state_frames)
  }
  
  clean_tern_vars <- stringr::str_replace(tern_vars, "[^\\w]", "_")
  
  # current issue - the space in "Election Day" breaks this
  base_plot <- tweened_data %>%
    ggplot(aes(x = !!(enquo(rlang::sym(tern_vars[1]))), y = Mail, z = Early)) +
    coord_tern()
}