% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/semantic_report_constructors.R
\name{make_accordion_element}
\alias{make_accordion_element}
\title{Create a UI accordion element.}
\usage{
make_accordion_element(
  results,
  color = "green",
  label,
  active = FALSE,
  type,
  mark,
  df_error_head_n
)
}
\arguments{
\item{results}{Results to display.}

\item{color}{Color of the label icon.}

\item{label}{Label.}

\item{active}{Is active?}

\item{type}{Result type.}

\item{mark}{Icon to display.}

\item{df_error_head_n}{Number of rows to display in error table.}
}
\value{
Accordion.
}
\description{
Create a UI accordion element.
}
\keyword{internal}
