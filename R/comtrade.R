#' comtrade constructor
#'
#' @param config list, configuration generated using [ct_read_config()]
#' @param data   data frame, data generated using [ct_read_data()]
#' @param header character, header (not yet allocated)
#' @param info   character, information (not yet alllocated)
#'
#' @return comtrade object
#' @export
#'
comtrade <- function(config, data, header = NULL, info = NULL) {

  # TODO: validate inputs

  structure(
    list(
      config = config,
      data = data,
      header = header,
      info = info
    ),
    class = "comtrade"
  )

}
