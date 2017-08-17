#' Serialize a config object
#'
#' We are confined to the 1999 revision of comtrade
#'
#' @param config `list`, comtrade configuration
#'
#' @return `character`
#' @export
#'
ct_serialize_config <- function(config){

  # convenience functions for glue
  glue_config <- function(...) {
    glue::glue_data(.x = config, ...)
  }

  remove_na <- function(x) {
    x %>%
      stringr::str_replace_all("(,)NA(,)", "\\1\\2") %>%
      stringr::str_replace_all("^NA(,)", "\\1") %>%
      stringr::str_replace_all("(,)NA$", "\\1")
  }

  serialize_datetime <- function(x) {
    str_date <- format(x, "%d/%m/%Y", tz = "UTC")
    str_time <- format(x, "%H:%M:%E6S")

    glue::glue("{str_date},{str_time}")
  }

  # variables are names after section numbers in the IEEE standard

  sec_531 <- glue_config("{station_name},{rec_dev_id},{rev_year}")

  sec_532 <- glue_config("{TT},{`##A`}A,{`##D`}D")

  sec_533 <- NULL
  if (config$`##A` > 0) {
    sec_533 <-
      glue::glue_data(
        config$analog_channel,
        "{An},{ch_id},{ph},{ccbm},{uu},{a},{b},{skew},{min},{max},{primary},{secondary},{PS}"
      )
  }

  sec_534 <- NULL
  if (config$`##D` > 0) {
    sec_534 <-
      glue::glue_data(
        config$digital_channel,
        "{Dn},{ch_id},{ph},{ccbm},{y}"
      )
  }

  sec_535 <- glue_config("{lf}")

  sec_536 <- c(
    glue_config("{nrates}"),
    glue::glue_data(
      config$sampling_rate,
      "{samp},{endsamp}"
    )
  )

  sec_537 <-
    c(
      serialize_datetime(config$dtm_first),
      serialize_datetime(config$dtm_trigger)
    )

  sec_538 <- glue_config("{ft}")

  sec_539 <- glue_config("{timemult}")

  result <-
    c(sec_531, sec_532, sec_533, sec_534,
      sec_535, sec_536, sec_537, sec_538, sec_539) %>%
    remove_na()

  result
}
