# Module which generates stories about relationships between bands and musicians,
# musicians and musicians

#' Generating front-end with the stories
#'
#' Generating front-end with the stories for band/musician chosen by the User
#'
#' UI function of the module which generates stories for band or musician
#' depending on the User's choice. The text of stories depending on the number
#' of found band and musician relations.
#'
#' @import shiny
#' @import shinyWidgets
#' @import shinythemes
#' @import DT
#' @import tidyr
#' @import dplyr
#' @import magrittr
#' @import htmltools
#'
#' @param id A \code{character} with unique ID

showInfoUI <- function(id) {
  ns <- NS(id)

  tagList(textOutput(ns("storyBand")),
          br(),
          textOutput(ns("storyMusician")))
}


#' Generating front-end with the stories
#'
#' Generating front-end with the stories for band/musician chosen by the User
#'
#' Server function of the module which generates stories for band or musician
#' depending on the User's choice. The text of stories depending on the number
#' of found band and musician relations.
#'
#' @import shiny
#' @import shinyWidgets
#' @import shinythemes
#' @import DT
#' @import tidyr
#' @import dplyr
#' @import magrittr
#'
#' @param input shiny input
#' @param output shiny output
#' @param session environment that can be used to access information and functionality
#' @param typeOfObject A \code{character} with the User's choice (e.g, 'Musician', 'Band')
#' @param valueOfObject A \code{character} with the full name of musician or band name
#' @param db_connection A connection to Postgres database

showInfo <-
  function(input,
           output,
           session,
           typeOfObject,
           valueOfObject,
           db_connection) {
    ns <- session$ns

    InfoList <- reactiveValues()
    StoryList <- reactiveValues()

    # get data for chosen Musician/Band and prepare human-friendly story
    if (typeOfObject == 'Musician') {
      InfoList <- getInfoAboutMusician(valueOfObject, db_connection)
      StoryList <- prepareStoryAboutMusician(valueOfObject, InfoList)

    } else if (typeOfObject == 'Band') {
      InfoList <- getInfoAboutBand(valueOfObject, db_connection)
      StoryList <- prepareStoryAboutBand(valueOfObject, InfoList)
    }

    output$storyBand <- renderText({
      StoryList[[1]]
    })
    output$storyMusician <- renderText({
      StoryList[[2]]
    })

    return(StoryList)
  }
