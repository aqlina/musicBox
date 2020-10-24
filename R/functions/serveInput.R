#' Add User's input to Postgres database
#'
#' Add User's input to database table imputing the missing id column with the next possible values
#'
#' This function add the input provided by the User in the App. The function assumes that primary key
#' of the each table in database is named 'id' and cannot be added by the User. The 'id' column is
#' being added inside the function after the next possible value of 'id' is taken from the database.
#'
#' @param tableName A \code{character} with the name of table to which the values will be inputted
#' @param newValueList A \code{list} of values to add; the length of the list must be the same as number of columns
#' of the table minus 1 (except 'id' column)
#' @param dbConnection A connection to the Postgres database
#'
#' @author "Alina Tselinina <tselinina@gmail.com>"
#' @importFROM RPostgres dbWriteTable dbGetQuery
#' @importFROM tibble as_tibble_row
#'
#' @examples
#' addValuesToDB("musicians", list('name': 'Whitney', 'surname': 'Houston'), db_connection)
#'
addValuesToDB <- function(tableName, newValuesList, dbConnection) {
  # find next free id number in DB
  nextId <- dbGetQuery(dbConnection, paste0('SELECT MAX(id) FROM ', tableName))$max
  
  newValuesList$id <- nextId + 1
  
  # write db statement for inserting new values
  dbWriteTable(
    dbConnection,
    tableName,
    as_tibble_row(newValuesList),
    append = TRUE,
    row.names = FALSE
  )
  
}

#' Create list of input names
#'
#' Create list of UI input names for the table chosen by the User
#'
#' This function has been designed to help in creating dynamic UI input based on
#' the types of data frame columns. Only integer and character columns
#' are being considered.
#'
#' @param df A \code{data.frame} for which the input will be generated
#' @author "Alina Tselinina <tselinina@gmail.com>"
#' @importFrom dplyr case_when
#'
#' @examples
#' checkInputForTable(iris)
#'
#' @return A \code{list} with input names used by UI
#'
checkInputForTable <- function(df) {
  
  ListOfIds <- list()
  
  for (i in 1:ncol(df)) {
    ListOfIds[[names(df)[i]]] <- case_when(
      class(df[, i]) == 'character' ~ paste0("txtInput", i),
      class(df[, i]) == 'integer' ~ paste0("numInput", i)
    )
  }
  return(ListOfIds)
}


#' Check User's input
#'
#' Check the correctness of the input provided by the User
#'
#' This function checks if the numeric and character input is not empty
#' as well as checks numeric values for being integers.
#'
#' @param listOfInput A \code{list} containing inputted values to check
#' @param message \code{TRUE/FALSE} value to choose the function output (\code{TRUE} for getting message
#' with instruction to correct the input; \code{FALSE} for getting \code{TRUE/FALSE} status of
#' input check); \code{FALSE} by default
#'
#' @author "Alina Tselinina <tselinina@gmail.com>"
#' @importFrom magrittr %>%
#'
#' @examples
#' inputIsCorrect(list("    ", 1.5, 2))
#' inputIsCorrect(list("    ", 1.5, 2), TRUE)
#' inputIsCorrect(list("Hangout Music Festival", 1L, 3L))
#' @return Returns \code{TRUE} if all input is correct, otherwise, returns \code{FALSE}.
#' If \code{messages=TRUE} the function returns the message to the User with appropriate instruction.
#'
inputIsCorrect <- function(listOfInput, message = FALSE) {
  messages <- c(
    'Please fill all the gaps.',
    'Please put only integer number into musician_id and band_id.'
  )
  
  # check for missing values
  firstCheck <- lapply(listOfInput,
                       function(x) {!is.na(x) & str_trim(x) != ''}) %>% unlist %>% all
  # check for integer numeric input
  secondCheck <-  lapply(listOfInput,
                         function(x) {if (is.numeric(x)) {is.integer(x)} }) %>% unlist %>% all
  
  if (message) {
    return(paste(messages[c(!firstCheck,!secondCheck)], collapse = ' '))
  } else {
    return(all(c(firstCheck, secondCheck)))
  }
}

