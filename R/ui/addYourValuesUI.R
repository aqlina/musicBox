
# ask the user about table he want to see
fluidPage(sidebarPanel(selectInput(
  "listTables",
  "Choose the table of interest:",
  c("Musicians", "Bands", "Events")
)),


# show table based on user's choice
mainPanel(
  DT::dataTableOutput("tableDataOutput"),
  br(),
  actionButton("addValueButton", "Add Values")
))
