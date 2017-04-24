#' Make an "instant" data frame
#'
#' This could be used in a dygraph, for instance.
#'
#' The data frame returned has a column called `instant`, which is a double
#' representing the time (s) since the start of the waveform. The remaining
#' columns represent the the channels in the comtrade object, and are
#' named according to the `channel_name` argument.
#'
#' @param ct            comtrade object (see [`comtrade()`])
#' @param channel_name  list or function -
#'  list has two members: `analog` and `digital` -
#'  each of which is a vector of character column-names.
#'  function must take one argument, `ct`, and return such a list of names.
#'  A convenience function, [`ct_attr()`] is provided.
#' @param use_timestamp logical to use the timestamp provided
#'   in the data file, or to use the sampling-rate provided in the
#'   configuration file.
#' @param side          character to indicate if we want primary or
#'   secondary values
#'
#' @return data frame
#' @examples
#'   ct_instant(keating_1999)
#' @export
#'
ct_instant <- function(ct, channel_name = ct_attr("ph"), use_timestamp = FALSE,
                        side = c("primary", "secondary")){

  assertthat::assert_that(
    inherits(ct, "comtrade"),
    is.function(channel_name) || is.list(channel_name),
    is.logical(use_timestamp)
  )

  side <- match.arg(side)

  # if function, use it
  if (is.function(channel_name)) {
    channel_name <- channel_name(ct)
  }

  # look at channel_name, make sure that lengths match up
  assertthat::assert_that(
    identical(length(channel_name[["analog"]]), ct[["config"]][["##A"]]),
    identical(length(channel_name[["digital"]]), ct[["config"]][["##D"]])
  )

  # timestamp and sample-rate
  has_sampling_rate <- ct[["config"]][["nrates"]] > 0L
  has_timestamp <- any(!is.na(ct[["data"]][["timestamp"]]))

  stopifnot(
    has_sampling_rate || has_timestamp
  )

  if (use_timestamp && !has_timestamp){
    use_timestamp <- FALSE
    warning("timestamp not available, setting use_timestamp to FALSE")
  }

  if (!use_timestamp && !has_sampling_rate){
    use_timestamp <- TRUE
    warning("sampling rate not available, setting use_timestamp to TRUE")
  }

  if (use_timestamp){
    # timestamp is expressed in integer microseconds
    instant <-
      ct[["data"]][["timestamp"]] * ct[["config"]][["timemult"]] / 1.e6
  } else {
    instant <- get_instant(ct[["config"]][["sampling_rate"]])
  }

  # names
  data <-
    ct[["data"]] %>%
    dplyr::select_(.dots = list(~-n, ~-timestamp)) %>%
    magrittr::set_names(
      c(channel_name[["analog"]], channel_name[["digital"]])
    )

  # add instant
  data[["instant"]] <- instant

  # reorder columns
  data <- data %>%
    dplyr::select_(.dots = list(~instant, ~dplyr::everything()))

  # scale analog columns
  for (i in seq_along(channel_name[["analog"]])) {

    ch_name <- channel_name[["analog"]][[i]]

    scale_channel <- fn_scale_channel(ct[["config"]], i)
    scale_side <- fn_scale_side(ct[["config"]], i, side)

    data[[ch_name]] <- data[[ch_name]] %>% scale_channel() %>% scale_side()
  }

  data
}

#' Helper function for channel names
#'
#' @inheritParams ct_instant
#' @param attr character indicating which attribute of channels to use as names
#'
#' @return list with two members: `analog` and `digital` -
#'  each of which is a vector of character column-names
#' @examples
#'   ct_channel_name(keating_1999, attr = "ch_id")
#'   ct_channel_name(keating_1999, attr = "ph")
#' @export
#'
ct_channel_name <- function(ct, attr = c("ch_id", "ph")) {

  assertthat::assert_that(
    inherits(ct, "comtrade")
  )

  attr <- match.arg(attr)

  list(
    analog = ct[["config"]][["analog_channel"]][[attr]],
    digital = ct[["config"]][["digital_channel"]][[attr]]
  )
}

#' Make a function that gets variable-names
#'
#' This is essentially a wrapper for [`ct_channel_name()`],
#' allowing you to delay the evaluation of the comtrade object.
#'
#' @inheritParams ct_channel_name
#'
#' @return function to get variable-names from config
#' @examples
#'   ch_name <- ct_attr("ch_id")
#'   ch_name(keating_1999)
#' @export
#'
ct_attr <- function(attr = c("ch_id", "ph")) {

  function(ct) {
    ct_channel_name(ct, attr = attr)
  }

}


#' Get function to scale analog-channel
#'
#' Given a config file and an analog-channel number,
#' return a function to scale the value.
#'
#' @inheritParams comtrade
#' @param i_analog integer, analog channel-number
#'
#' @return function that takes a value and returns a scaled value
#' @keywords internal
#' @export
#'
fn_scale_channel <- function(config, i_analog) {

  a <- config[["analog_channel"]][["a"]][[i_analog]]
  b <- config[["analog_channel"]][["b"]][[i_analog]]

  function(x) {
    (a * x) + b
  }
}

#' Get function to scale side
#'
#' Given a config file and a side, return a function to scale a value
#'
#' @inheritParams comtrade
#' @inheritParams fn_scale_channel
#' @inheritParams ct_instant
#'
#' @return function that takes a value and returns a scaled value
#' @keywords internal
#' @export
#'
fn_scale_side <- function(config, i_analog, side = c("primary", "secondary")) {

  side <- match.arg(side)

  scale <- c(
    primary = config[["analog_channel"]][["primary"]][[i_analog]],
    secondary = config[["analog_channel"]][["secondary"]][[i_analog]]
  )

  measurement_key <- c(
    p = "primary",
    s = "secondary"
  )

  measurement <-
    measurement_key %>%
    `[[`(as.character(config[["analog_channel"]][["PS"]][[i_analog]]))

  function(x) {
    x * scale[[side]] / scale[[measurement]]
  }

}

get_instant <- function(sampling_rate) {

  n <- max(sampling_rate[["endsamp"]])

  instant <- rep(0, n)

  now <- 0
  index_rate <- 1
  for (i in seq_along(instant)) {

    # advance sampling-rate index if needed
    while (sampling_rate[["endsamp"]][[index_rate]] < i) {
      index_rate <- index_rate + 1
    }

    # advance "now"
    now <- now + 1 / sampling_rate[["samp"]][[index_rate]]

    # capture "now"
    instant[i] <- now
  }

  instant <- instant - instant[1]

  instant
}
