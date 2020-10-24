# Shiny App Module which generates dynamic input for the PopUp window

#' Generating front-end with the dynamic Input
#'
#' Generating front-end with the dynamic Input for the table chosen by the User
#'
#' UI function of the module which generates dynamic Input based on the name and
#' type of the columns of the chosen table. Only character and integer columns are
#' taken
#'
#' @param id A \code{character} with unique ID

showInputUI <- function(id) {
  ns <- NS(id)
  tagList(tags$div(class = "placeholder"))
}


#' Generating front-end with the dynamic Input
#'
#' Generation front-end with the dynamic Input for the table chosen by the User
#'
#' Server function of module which generates dynamic Input based
#' on the chosen table.
#'
#' @param input
#' @param output
#' @param session
#' @param data reactive table

showInput <- function(input, output, session, data) {
  ns <- session$ns

  df <- data()

  lapply(1:ncol(df), function(i) {
    insertUI(".placeholder",
             ui = tagList(if (class(df[, i]) == 'character') {
               textInput(paste0("txtInput", i),
                         names(df)[i])

             } else if (class(df[, i]) == 'integer') {
               numericInput(
                 paste0("numInput", i),
                 names(df)[i],
                 value = NA,
                 min = 1,
                 step = 1
               )
             },
             br()))
  })
  return(0)
}
