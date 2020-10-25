#' UI function for MusicBox Shiny App
#'
#' UI function for MusicBox Shiny App
#'
#' UI function generates the front-end for MusicBox Shiny App. The function sources
#' two small UI R scripts, one per each tab of the App
#'
#' @author "Alina Tselinina <tselinina@gmail.com>"
#'
#' @import shiny
#' @import shinyWidgets
#' @importFrom DT dataTableOutput

musicBox_ui <- function() {
  fluidPage(mainPanel(tabsetPanel(
    tabPanel("Add your values",
             tagList(
               # ask the user about table he want to see
               sidebarPanel(selectInput(
                 "listTables",
                 "Choose the table of interest:",
                 c("Musicians", "Bands", "Events")
               )),


               # show table based on user's choice
               mainPanel(tagList(
                 DT::dataTableOutput("tableDataOutput"),
                 br(),
                 actionButton("addValueButton", "Add Values")
               ))
             )),


    tabPanel("Find out More",
             # ask the user what to show details about
             fluidPage(
               sidebarPanel(tags$div(
                 class = 'radioButtons',
                 radioButtons(
                   'BandOrMusician',
                   'What do you want to find out more about?',
                   choices = c("Musician", "Band"),
                   selected = NA
                 )
               ))
               ,

               # show two stories about bands and musicians cooperated with the band/musician of choice
               mainPanel(showInfoUI('BandOrMusicianInfo'))
             ))
  )))
}
