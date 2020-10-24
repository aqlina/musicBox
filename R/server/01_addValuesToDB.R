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
  if (inputIsCorrect(inputValues)) {
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
      message = inputIsCorrect(inputValues, message =
                                 TRUE)
    ))
  }
  
})

# generate table according to the choice of user and added values
output$tableDataOutput <-
  DT::renderDataTable({
    datatable(recordAdded())
  })

observeEvent(input$listTables, {
  switch(
    input$listTables,
    "Musicians" = recordAdded(musiciansData()),
    "Bands" = recordAdded(bandsData()),
    "Events" = recordAdded(eventsData())
  )
})