#' UI function for MusicBox Shiny App
#'
#' UI function for MusicBox Shiny App
#'
#' UI function generating front-end for MusicBox Shiny App. The function sources
#' two small UI R scripts per each tab of the App
#'
#' @author "Alina Tselinina <tselinina@gmail.com>"
#'
#' @import shiny
#' @import shinyWidgets
#' @import shinythemes
#' @import dataset
#' @import DT

musicBox_ui <- function() {
  fluidPage(mainPanel(tabsetPanel(
    tabPanel("Add your values",
             source('ui/addYourValuesUI.R', local = TRUE)$value),
    tabPanel("Find out More",
             source('ui/findOutMoreUI.R', local = TRUE)$value)
  )))
}
