#' Launch MusicBox Shiny App
#'
#' Launch MusicBox Shiny App
#'
#' This function launches MusicBox Shiny App based on the data from Postgres database
#' which must be connected to R before launching.
#'
#' @export
#' @author Alina Tselinina <tselinina@gmail.com>
#'
#' @import shiny
#'
#' @aliases \link{musicBox_ui} \link{musicBox_server}

launch_app <- function(){
  shinyApp(ui = musicBox_ui, server = musicBox_server,
           options=list(port=9999, host="0.0.0.0", launch.browser=FALSE))
}

#' musicBox: A package with a Shiny App inside
#'
#' this package provides functionality for running Shiny App which allows for
#' adding new values to Postgres database containing data with musicians, bands and
#' music events interactively and for showing relations between musicians and bands
#' based on User's choice of interest.
#'
#' @author Alina Tselinina \email{tselinina@gmail.com}
#' @docType package
#' @name musicBox
# to make note about '.' quiet while checking a package with check() function
if(getRversion() >= "2.15.1") utils::globalVariables(c("."))
"_PACKAGE"

#' Example musicians data
#'
#' A dataset contains example of 'musicians' table
#'
#' @format A \code{data.frame} of 3 columns and 10 rows
#' \describe{
#' \item{id}{id value}
#' \item{name}{character value with the first name of a musician}
#' \item{surname}{character value with the surname of musician}
#' }
#'@source Simulated data
#'
"musicians"

#' Example bands data
#'
#' A dataset contains example of 'bands' table
#'
#' @format A \code{data.frame} of 2 columns and 10 rows
#' \describe{
#' \item{id}{id value}
#' \item{name}{character value with the name of a band}
#' }
#'@source Simulated data
#'
"bands"

#' Example music events data
#'
#' A dataset contains example of 'events' table
#'
#' @format A \code{data.frame} of 4 columns and 10 rows
#' \describe{
#' \item{id}{id value}
#' \item{name}{character value with the name of an event}
#' \item{musician_id}{id value of a musician took part in the event as a member of band_id band}
#' \item{band_id}{id value of a band took part in the event}
#' }
#'@source Simulated data
#'
"events"
