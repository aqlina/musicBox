% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/server.R
\name{musicBox_server}
\alias{musicBox_server}
\title{server function for MusicBox Shiny App}
\usage{
musicBox_server(input, output, session)
}
\arguments{
\item{input}{shiny input}

\item{output}{shiny output}

\item{session}{environment that can be used to access information and functionality}
}
\description{
server function for MusicBox Shiny App
}
\details{
server function generates the back-end for MusicBox Shiny App. The function sources
two R scripts: 01_addValuesToDB and 02_queriesToDB
}
\author{
"Alina Tselinina \href{mailto:tselinina@gmail.com}{tselinina@gmail.com}"
}
