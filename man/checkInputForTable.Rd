% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{checkInputForTable}
\alias{checkInputForTable}
\title{Create list of input names}
\usage{
checkInputForTable(df)
}
\arguments{
\item{df}{A \code{data.frame} for which the input will be generated}
}
\value{
A \code{list} with input names used by UI
}
\description{
Create list of UI input names for the table chosen by the User
}
\details{
This function has been designed to help in creating dynamic UI input based on
the types of data frame columns. Only integer and character columns
are being considered.
}
\author{
Alina Tselinina \href{mailto:tselinina@gmail.com}{tselinina@gmail.com}
}
