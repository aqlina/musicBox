

# ask the user what to show details about
fluidPage(sidebarPanel(tags$div(
  class = 'radioButtons',
  radioButtons(
    'BandOrMusician',
    'What do you want to find out more about?',
    choices = c("Musician", "Band"),
    selected = NA
  )
))
,

# show two tables about bands and musicians cooperated with the band/musician of choice
mainPanel(showInfoUI('BandOrMusicianInfo')))
