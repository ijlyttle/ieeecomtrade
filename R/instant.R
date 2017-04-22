#' Make an "instant" data frame
#'
#' This could be used in a dygraph, for instance.
#'
#' The data frame returned has a column called `instant`, which is a double
#' representing the time (s) since the start of the waveform. The remaining
#' columns represent the the channels in the comtrade object, and are
#' named according to the `channel_name` argument.
#'
#' @param ct            comtrade object (see [comtrade()])
#' @param channel_name  list with two members: `analog` and `digital` -
#'  each of which is a vector of character column-names. You can use
#'  [`ct_channel_name()`] to get names. `NULL` indicates
#'  to use the default names.
#' @param use_timestamp logical to use the timestamp provided
#'   in the data file, or to use the sampling-rate provided in the
#'   configuration file.
#' @param side          character to indicate if we want primary or
#'   secondary values
#'
#' @return data frame
#' @export
#'
ct_instant <- function(ct, channel_name = NULL, use_timestamp = FALSE,
                        side = c("primary", "secondary")){

  assertthat::assert_that(
    inherits(ct, "comtrade"),
    is.list(channel_name) || is.null(channel_name),
    is.logical(use_timestamp)
  )

  side <- match.arg(side)

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

  data
}

#' helper function for channel names
#'
#' @inheritParams ct_instant
#' @param attr character indicating which attribute of channels to use as names
#'
#' @return list with two members: `analog` and `digital` -
#'  each of which is a vector of character column-names
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

  NULL
}


# given a config file and a side return a function to scale a value

#' Get function to scale side
#'
#' Given a config file and a side, return a function to scale a value
#'
#' @inheritParams comtrade
#' @inheritParams ct_instant
#'
#' @return
#' @keywords internal
#' @export
#'
fn_scale_side <- function(config, side = c("primary", "secondary")) {

  NULL
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
