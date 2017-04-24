#' Read a zip file to make a comtrade object
#'
#' @param file character, path to a zip file
#'
#' @return comtrade object
#' @examples
#'   ct_example("keating_1999.zip") %>%
#'   ct_read_zip()
#' @export
#'
ct_read_zip <- function(file) {

  # get files
  filenames <-
    file %>%
    utils::unzip(list = TRUE) %>%
    dplyr::filter_(.dots = list(~!stringr::str_detect(Name, "^__MAC"))) %>%
    `[[`("Name")

  fn_detect <- function(extension) {

    regex <- stringr::regex(paste0("\\.", extension, "$"), ignore_case = TRUE)

    function(x){
      stringr::str_detect(x, regex)
    }
  }

  filename_cfg <- filenames[fn_detect("cfg")(filenames)]
  filename_dat <- filenames[fn_detect("dat")(filenames)]

  # assert that we have
  # - exactly one cfg file
  # - exactly one dat file
  assertthat::assert_that(
    identical(length(filename_cfg), 1L),
    identical(length(filename_dat), 1L)
  )

  cfg <-
    file %>%
    unz(filename_cfg) %>%
    readr::read_file() %>%
    ct_read_config()

  dat <-
    file %>%
    unz(filename_dat) %>%
    readr::read_file() %>%
    ct_read_data_config(cfg)

  comtrade(config = cfg, data = dat)
}
