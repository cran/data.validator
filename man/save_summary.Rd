% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report.R
\name{save_summary}
\alias{save_summary}
\title{Save simple validation summary in text file}
\usage{
save_summary(
  report,
  file_name = "validation_log.txt",
  success = TRUE,
  warning = TRUE,
  error = TRUE
)
}
\arguments{
\item{report}{Report object that stores validation results.}

\item{file_name}{Name of the resulting file (including extension).}

\item{success}{Should success results be presented?}

\item{warning}{Should warning results be presented?}

\item{error}{Should error results be presented?}
}
\description{
Saves \code{print(validator)} output inside text file.
}
