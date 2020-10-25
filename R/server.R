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
#' @import tidyr
#' @import dplyr
#' @importFrom stringr str_trim str_to_title
#' @importFrom RPostgres dbReadTable
#'
#' @param input shiny input
#' @param output shiny output
#' @param session environment that can be used to access information and functionality

musicBox_server <- function(input, output, session) {

  db_connection <- getConnectionToDB()
  # the first load of tables from DB
  musicians <- dbReadTable(db_connection, "musicians")  %>% select(-id)
  bands <- dbReadTable(db_connection, "bands") %>% select(-id)
  events <- dbReadTable(db_connection, "events") %>% select(-id)

  # create reactive tables reacting to new added value
  musiciansData <- reactiveVal(musicians)
  bandsData <- reactiveVal(bands)
  eventsData <- reactiveVal(events)

  # create popUp window to provide user with a possibility to add his value
  popupModal <- function(failed = FALSE, message = '') {
    modalDialog(
      title = "Write the values you want to add",

      if (failed) {
        tagList(div(tags$b(message, style = "color: red;"), ),
                br())
      },

      showInputUI('ModalUI'),

      footer = tagList(modalButton("Cancel"),
                       actionButton("modalOK", "OK")),
      easyClose = TRUE
    )
  }

  # show popUp window after user clicked 'Add Values'
  observeEvent(input$addValueButton, {
    callModule(showInput,
               'ModalUI',
               data = recordAdded)

    showModal(popupModal())
  })


  # react to the user's OK answer for PopUp window depending on the completeness of user's input
  addedValues <- reactiveValues()
  recordAdded <- reactiveVal()
  inputValues <- reactiveValues()

  observeEvent(input$modalOK, {
    inputValues <-
      lapply(checkInputForTable(recordAdded()), function(x) {
        input[[x]]
      })

    # if the provided input is correct:
    if (inputIsCorrect(inputValues, recordAdded())) {
      # prepare input
      addedValues <- lapply(inputValues,
                            function(x) {
                              if (class(x) == "character") {
                                x %>% str_trim %>% str_to_title
                              } else {
                                x
                              }
                            })

      tableName <- tolower(input$listTables)
      addValuesToDB(tableName, addedValues, db_connection)
      removeModal()

      # read again only the table which was changed:
      if (tableName == 'musicians') {
        musiciansData(dbReadTable(db_connection, tableName))
        recordAdded(musiciansData())
      } else if (tableName == 'bands') {
        bandsData(dbReadTable(db_connection, tableName))
        recordAdded(bandsData())
      } else if (tableName == 'events') {
        eventsData(dbReadTable(db_connection, tableName))
        recordAdded(eventsData())
      }

      # if the provided input is not correct, send a failure message:
    } else {
      callModule(showInput,
                 "ModalUI",
                 data = recordAdded)
      showModal(popupModal(
        failed = TRUE,
        message = inputIsCorrect(inputValues, recordAdded(), message=TRUE)
      ))
    }

  })

  # generate table according to the choice of user and added values
  output$tableDataOutput <-
    DT::renderDataTable({
      DT::datatable(recordAdded())
    })

  observeEvent(input$listTables, {
    switch(
      input$listTables,
      "Musicians" = recordAdded(musiciansData()),
      "Bands" = recordAdded(bandsData()),
      "Events" = recordAdded(eventsData())
    )
  })

  # second tab
  # create UI with choices based on selection
  observeEvent(input$BandOrMusician, {
    removeUI('div:has(> #listObjects)')

    # create appropriate choices based on selection
    if (input$BandOrMusician == 'Musician') {
      choices <-
        paste(musiciansData() %>% .$name,
              musiciansData() %>% .$surname,
              sep = ' ')
    } else if (input$BandOrMusician == 'Band') {
      choices <- bandsData() %>% .$name
    }

    insertUI('.radioButtons',
             ui = selectInput("listObjects",
                              label = NULL,
                              choices = choices))

  })


  # create tables with information based on 2 selections
  observeEvent({
    input$BandOrMusician
    input$listObjects
  }, {
    callModule(
      showInfo,
      'BandOrMusicianInfo',
      typeOfObject = input$BandOrMusician,
      valueOfObject = input$listObjects,
      db_connection
    )
  })
}
