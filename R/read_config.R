#' Read config file
#'
#' The thought here is to return a list where the names hew as closely as
#' possible to the names in the standard.
#'
#' @param file character, single line, path to a file or a single string
#'
#' @return list, specified in `vignette("config")`
#' @examples
#'   ct_example("keating_1999.CFG") %>%
#'   ct_read_config()
#' @export
#'
ct_read_config <- function(file){

  assertthat::assert_that(
    is.character(file)
  )

  is_file <- !stringr::str_detect(file, "\n")

  text <- readr::read_lines(file)
  # if (is_file) {
  #   text <- readr::read_lines(file)
  # } else {
  #   text <- stringr::str_split(file, "\n")
  # }

  # text is a vector of character strings

  # warn only 1999 is valid now

  index <- 0

  # station, channels
  config <- c(
    parse_station(text[index + 1]),
    parse_nchan(text[index + 2])
  )
  index <- 2

  # analog channels
  analog_channel <- NULL
  if (config[["##A"]] > 0L) {
    indices <- index + (1:config[["##A"]])
    config[["analog_channel"]] <- parse_analog_channel(text[indices])
    index <- index + config[["##A"]]
  }

  # digital channels
  digital_channel <- NULL
  if (config[["##D"]] > 0L) {
    indices <- index + (1:config[["##D"]])
    config[["digital_channel"]] <- parse_digital_channel(text[indices])
    index <- index + config[["##D"]]
  }

  # line frequency, nrates
  config <- c(
    config,
    parse_line_frequency(text[index + 1]),
    parse_nrates(text[index + 2])
  )
  index <- index + 2

  # sampling_rate
  config[["sampling_rate"]] <-
    parse_sampling_rate(text[index + (1:max(config$nrates, 1))])
  index <- index + config$nrates

  # datetime - using nanotime package for because we need better precision
  # than POSIXct can afford us
  #
  # TODO: ask Dave Glasgow about nanosecond-precision datetimes
  # not using c() so as to avoid stripping the nanotime attributes
  config[["dtm_first"]] <- parse_nanotime(text[index + 1])
  config[["dtm_trigger"]] <- parse_nanotime(text[index + 2])

  # data type (ascii or binary)
  #
  # TODO: warn that we support only ascii for now
  config <- c(
    config,
    parse_file_type(text[index + 3]),
    parse_timemult(text[index + 4])
  )

  config
}

parse_station <- function(text){

  station <-
    parse_config_list(
      text,
      col_names = c("station_name", "rec_dev_id", "rev_year"),
      col_types = "cci"
    )

  # rev_year can be only 1991, 1999, 2013
  station[["rev_year"]] <-
    station[["rev_year"]] %>%
    factor(levels = c(1991L, 1999L, 2013L))

  station
}

parse_nchan <- function(text){

  nchan <-
    parse_config_list(
      text,
      col_names = c("TT", "##A", "##D"),
      col_types = "icc"
    )

  # parse for number, convert to integer
  nchan[["##A"]] <-
    nchan[["##A"]] %>%
    stringr::str_extract("^\\d+") %>%
    as.integer()

  nchan[["##D"]] <-
    nchan[["##D"]] %>%
    stringr::str_extract("^\\d+") %>%
    as.integer()

  # assert that the number of channels is consistent
  assertthat::assert_that(
    nchan[["TT"]] == nchan[["##A"]] + nchan[["##D"]]
  )

  nchan
}

parse_analog_channel <- function(text) {

  analog_channel <-
    parse_config(
      text,
      col_names = c("An", "ch_id", "ph", "ccbm", "uu", "a", "b", "skew",
                    "min", "max", "primary", "secondary", "PS"),
      col_types = "iccccdddiiddc"
    )

  analog_channel[["PS"]] <-
    analog_channel[["PS"]] %>%
    factor(levels = c("P", "S"))

  analog_channel
}

parse_digital_channel <- function(text) {

  digital_channel <-
    parse_config(
      text,
      col_names = c("Dn", "ch_id", "ph", "ccbm", "y"),
      col_types = "iccci"
    )

  digital_channel
}

parse_line_frequency <- function(text){
  parse_config_list(
    text,
    col_names = "lf",
    col_types = "d"
  )
}

parse_nrates <- function(text){
  parse_config_list(
    text,
    col_names = "nrates",
    col_types = "i"
  )
}

parse_sampling_rate <- function(text){
  parse_config(
    text,
    col_names <- c("samp", "endsamp"),
    col_types <- c("di")
  )
}

# note, this returns "nanotime" (POSIXct does not have enough precision)
# note, assuming UTC
#
# format is dd/mm/yyyy,hh:mm:ss.ssssss
#
parse_nanotime <- function(text){

  # get fractional seconds
  regex_fracsecond <- "\\.\\d+"

  frac_second <-
    text %>%
    stringr::str_extract(regex_fracsecond) %>%
    as.numeric()

  posixct <-
    text %>%
    lubridate::dmy_hms(tz = "UTC") %>%
    lubridate::floor_date("seconds")

  nanotime::nanotime(posixct) + frac_second * 1.e9
}

parse_file_type <- function(text) {

  file_type <-
    parse_config(
      text,
      col_names = c("ft"),
      col_types = c("c")
    )

  file_type[["ft"]] <-
    file_type[["ft"]] %>%
    tolower() %>%
    factor(levels = c("ascii", "binary"))

  file_type
}

parse_timemult <- function(text) {
  parse_config(
    text,
    col_names = c("timemult"),
    col_types = c("d")
  )
}

#' parse into a data frame
#'
#' @param text  character, vector of strings
#' @param ...   other args passed to [readr::read_csv()]
#'
#' @return tibble
#' @keywords internal
#'
parse_config <- function(text, ...){

  result <-
    text %>%
    paste(collapse = "\n") %>%  # collapse into a single character vector
    paste0(sep = "\n") %>%      # terminate with newline
    readr::read_csv(...)        # read csv

  attr(result, "spec") <- NULL

  result
}

#' parse into a list
#'
#' @inheritParams parse_config
#'
#' @return tibble
#' @keywords internal
#'
parse_config_list <- function(text, ...){

  result <-
    parse_config(text, ...) %>%
    as.list()

  attr(result, "spec") <- NULL

  result
}

