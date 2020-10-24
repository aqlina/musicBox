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
    valueOfObject = input$listObjects
  )
})