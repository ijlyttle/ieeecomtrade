% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_data.R
\name{ct_read_data_config}
\alias{ct_read_data_config}
\title{Read data file using config information}
\usage{
ct_read_data_config(file, config)
}
\arguments{
\item{file}{character, single line, path to a file or a single string}

\item{config}{list created using \code{\link[=ct_read_config]{ct_read_config()}}}
}
\value{
tibble (data frame)
}
\description{
This is a wrapper for \code{\link[=ct_read_data]{ct_read_data()}}.
}
\examples{
  config <- ct_example("keating_1999.CFG") \%>\% ct_read_config()
  ct_example("keating_1999.DAT") \%>\% ct_read_data_config(config)
}
\seealso{
\code{\link[=ct_read_data]{ct_read_data()}}
}
