#' read data file
#'
#' @inheritParams ct_read_config
#' @param config list created using [`ct_read_config()`]
#'
#' @return tibble, specified in `vignette("data")`
#' @export
#'
ct_read_data_config <- function(file, config){

  # TODO: validate config
  # TODO: find a way to check for the existance of config$sampling_rate$endsamp

  ct_read_data(
    file,
    n_analog = config[["##A"]],
    n_digital = config[["##D"]],
    n_max = max(config[["sampling_rate"]][["endsamp"]])
  )
}

#' read data file
#'
#' @inheritParams ct_read_config
#' @param n_analog  integer, number of analog channels
#' @param n_digital integer, number of digital channels
#' @param n_max  integer, maximum number of records to read
#'
#' @return tibble, specified in `vignette("data")`
#' @export
#'
ct_read_data <- function(file, n_analog, n_digital, n_max = Inf) {

  make_names <- function(root, n) {

    n <- as.integer(n)

    if (identical(n, 0L)) {
      return(NULL)
    }

    names <- sprintf(paste0(root, "%06d"), seq(n))

    names
  }

  col_names <-
    c("n", "timestamp", make_names("a", n_analog), make_names("d", n_digital))

  col_types <- paste(rep("i", 2 + n_analog + n_digital), collapse = "")

  readr::read_csv(
    file,
    col_names = col_names,
    col_types = col_types,
    n_max = n_max
  )
}
