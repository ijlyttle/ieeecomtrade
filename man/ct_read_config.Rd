% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_config.R
\name{ct_read_config}
\alias{ct_read_config}
\title{Read config file}
\usage{
ct_read_config(file)
}
\arguments{
\item{file}{character, single line, path to a file or a single string}
}
\value{
list, specified in \code{vignette("config")}
}
\description{
The thought here is to return a list where the names hew as closely as
possible to the names in the standard.
}
\examples{
  ct_example("keating_1999.CFG") \%>\%
  ct_read_config()
}
