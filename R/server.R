#' server function for MusicBox Shiny App
#'
#' server function for MusicBox Shiny App
#'
#' server function generates the back-end for MusicBox Shiny App. The function sources
#' two R scripts: 01_addValuesToDB and 02_queriesToDB
#'
#' @author "Alina Tselinina <tselinina@gmail.com>"
#'
#' @import shiny
#' @import shinyWidgets
#' @import shinythemes
#' @import dataset
#' @import DT
#' @import tidyr
#' @import dplyr
#' @import magrittr

musicBox_server <- shinyServer(function(input, output, session) {
  for (file in list.files("server")) {
    source(file.path("server", file), local = TRUE)$value
  }
})
