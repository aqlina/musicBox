#' Launch MusicBox Shiny App
#'
#' Launch MusicBox Shiny App
#'
#' This function launches MusicBox Shiny App based on the data from Postgres database
#' which must be connected to R before launching.
#'
#' @export
#' @author "Alina Tselinina <tselinina@gmail.com>"
#'
#' @import shiny
#'
#' @aliases \link{musicBox_ui} \link{musicBox_server}

launch_app <- function(){
  shinyApp(ui = musicBox_ui, server = musicBox_server)
}
