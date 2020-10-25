# The script with the functions for routine calculations and queries for musicBox App needs

#' Getting connection to the Postgres DB
#'
#' Getting connection to the Postgres DB from environmental settings
#'
#' This function gets connections to the DB based on environmental variables
#' which contains information about the name of database (DB_NAME), user (DB_USER),
#' password (DB_PASSWORD), port (DB_PORT), host (DB_HOST) and schema (DB_SCHEMA).
#'
#'
#' @author Alina Tselinina <tselinina@gmail.com>
#'
#' @importFrom RPostgres dbConnect Postgres
#'
#' @return Connection to database

getConnectionToDB <- function(){

  Sys.setenv("DB_HOST" = "localhost")
  Sys.setenv("DB_USER" = "postgres")
  Sys.setenv("DB_PASSWORD" = "postgres")
  Sys.setenv("DB_NAME" = "musicianbox-db")
  Sys.setenv("DB_PORT" = "5432")
  Sys.setenv("DB_SCHEMA" = "public")

  db_connection <- dbConnect(
      Postgres(),
      host = Sys.getenv("DB_HOST"),
      user = Sys.getenv("DB_USER"),
      password = Sys.getenv("DB_PASSWORD"),
      dbname = Sys.getenv("DB_NAME"),
      port = Sys.getenv("DB_PORT"),
      options = paste("-c search_path=", Sys.getenv("DB_SCHEMA"), sep = "")
    )

  return(db_connection)
}

#' Add User's input to Postgres database
#'
#' Add User's input to database table imputing the missing id column with the next possible values
#'
#' This function add the input provided by the User in the App. The function assumes that primary key
#' of the each table in database is named 'id' and cannot be added by the User. The 'id' column is
#' being added inside the function after the next possible value of 'id' is taken from the database.
#'
#' @param tableName A \code{character} with the name of table to which the values will be inputted
#' @param newValuesList A \code{list} of values to add; the length of the list must be the same as number of columns
#' of the table minus 1 (except 'id' column)
#' @param dbConnection A connection to the Postgres database
#'
#' @author Alina Tselinina <tselinina@gmail.com>
#' @importFrom RPostgres dbWriteTable dbGetQuery
#' @importFrom tibble as_tibble
#'
#' @example
#' \dontrun{
#' addValuesToDB("musicians", list('name': 'Whitney', 'surname': 'Houston'), db_connection)
#' }
#' @return nothing
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
#' @author Alina Tselinina <tselinina@gmail.com>
#' @importFrom dplyr case_when
#'
#' @example
#' checkInputForTable(musicians)
#' checkInputForTable(bands)
#' checkInputForTable(events)
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
#' @param data A reactive \code{data.frame} with all current values
#' @param message \code{TRUE/FALSE} value to choose the function output (\code{TRUE} for getting message
#' with instruction to correct the input; \code{FALSE} for getting \code{TRUE/FALSE} status of
#' input check); \code{FALSE} by default
#'
#' @author Alina Tselinina <tselinina@gmail.com>
#' @importFrom magrittr %>%
#' @importFrom tibble as_tibble_row
#'
#' @example
#' inputIsCorrect(list(name="    ", surname="Smith"), musicians %>% select(-id))
#' inputIsCorrect(list(name="MusicFest", musician_id=1.5, band_id=9),
#' events %>% select(-id), message=TRUE)
#'
#' @return Returns \code{TRUE} if all input is correct, otherwise, returns \code{FALSE}.
#' If \code{messages=TRUE} the function returns the message to the User with appropriate instruction.
#'
inputIsCorrect <- function(listOfInput, data, message = FALSE) {
  messages <- c(
    'Please fill all the gaps.',
    'Please put only integer number into musician_id and band_id.',
    'The values you want to add are already in this table.'
  )

  # check for missing values
  firstCheck <- lapply(listOfInput,
                       function(x) {!is.na(x) & str_trim(x) != ''}) %>% unlist %>% all
  # check for integer numeric input
  secondCheck <-  lapply(listOfInput,
                         function(x) {if (is.numeric(x)) {is.integer(x)} }) %>% unlist %>% all

  # check if the added record is a new value for the table
  data <- rbind(data, as_tibble_row(listOfInput))
  thirdCheck <- nrow(data) == nrow(distinct(data))

  if (message) {
    return(paste(messages[c(!firstCheck,!secondCheck, !thirdCheck)], collapse = ' '))
  } else {
    return(all(c(firstCheck, secondCheck, thirdCheck)))
  }
}

#' Send queries to Postgres database to get relations
#'
#' Send queries to Postgres database to get relations between bands and musicians
#'
#' This function sends the queries to Postgres database to get band-bands and
#' and-musicians relations
#'
#' @param name A \code{character} which is the name of band
#' @param dbConnection A connection to Postgres database
#'
#' @author Alina Tselinina <tselinina@gmail.com>
#'
#' @importFrom magrittr %>%
#' @importFrom RPostgres dbGetQuery
#' @importFrom tidyr separate
#' @importFrom dplyr mutate_at
#'
#' @return A \code{list} of two \code{data.frame} with the relations; the first
#' \code{data.frame} consists of one column 'band' and describes the band-bands
#' relation; the second \code{data.frame} consists of two 'name' and 'surname'
#' columns and describe band-musicians relation;
#'
getInfoAboutBand <- function(name, dbConnection) {

  query <- paste0(
    "SELECT DISTINCT(ev2.band)
     FROM prepared_events AS ev1
     JOIN prepared_events AS ev2
       ON ev1.event_name = ev2.event_name
     WHERE ev1.band = '", name,"'
       AND ev1.band <> ev2.band;")

  bandsForBand <- dbGetQuery(dbConnection, query)

  query <- paste0(
    "SELECT DISTINCT(ev2.musician_name, ev2.musician_surname)
       FROM prepared_events AS ev1
       JOIN prepared_events AS ev2
         ON ev1.event_name = ev2.event_name
       WHERE ev1.musician_id <> ev2.musician_id
         AND ev1.band = ev2.band
         AND ev1.band = '", name, "'")

  musiciansForBand <- dbGetQuery(dbConnection, query)
  musiciansForBand <- musiciansForBand %>%
    separate(., "row", into = c('name', 'surname'), sep = ',') %>%
    mutate_at(vars('name', 'surname'), funs(sub('\\(|\\)', '', .)))

  return(list(bandsForBand, musiciansForBand))
}


#' Send queries to Postgres database to get relations
#'
#' Send queries to Postgres database to get relations between bands and musicians
#'
#' This function sends the queries to database to get musician-bands and
#' musician-musicians relations
#'
#' @param name A \code{character} which is the full name of musician
#' @param dbConnection A connection to Postgres database
#'
#' @author Alina Tselinina <tselinina@gmail.com>
#'
#' @importFrom magrittr %>%
#' @importFrom RPostgres dbGetQuery
#' @importFrom tidyr separate
#' @importFrom dplyr mutate_at
#' @importFrom stringr str_split
#'
#' @return A \code{list} of two \code{data.frame} with the relations; the first
#' \code{data.frame} consists of one column 'band' and describes the musician-bands
#' relation; the second \code{data.frame} consists of two 'name' and 'surname'
#' columns and describe musician-musicians relation;
#'
getInfoAboutMusician <- function(name, dbConnection) {

  surname <- str_split(name, ' ')[[1]][2]
  name <- str_split(name, ' ')[[1]][1]

  # find all bands the musician played in
  query <- paste0(
    "SELECT DISTINCT(band)
     FROM prepared_events
     WHERE musician_name = '", name, "'",
    "AND musician_surname ='", surname,"'")

  bandsForMusician <- dbGetQuery(dbConnection, query)

  # find all musicians chosen musician played with
  query <-
    paste0(
      "SELECT DISTINCT(ev2.musician_name, ev2.musician_surname)
       FROM prepared_events AS ev1
       JOIN prepared_events AS ev2
         ON ev1.event_name = ev2.event_name
      WHERE ev1.musician_id <> ev2.musician_id
        AND ev1.band = ev2.band
        AND ev1.musician_name ='", name, "'",
      "AND ev1.musician_surname = '", surname, "'")

  musicianForMusician <- dbGetQuery(dbConnection, query)
  musicianForMusician <- musicianForMusician %>%
    separate(., "row", into = c('name', 'surname'), sep=',') %>%
    mutate_at(vars('name', 'surname'), funs(sub('\\(|\\)', '', .)))

  return(list(bandsForMusician, musicianForMusician))
}

#' Generate human-friendly story for Musician
#'
#' Generate human-friendly story for Musician based on the tables
#'
#' This function generates a story based on the list of two data frames. One
#' data frame contains the band names which the musician played in. The second
#' table contains the name and surname of musicians who played with the musician.
#' The story is being generated depending on the number of rows.
#'
#' @param name A \code{character} which is the full name of musician
#' @param tableList A \code{list} with two data frames; the first \code{data.frame} consists
#' of one \code{character} column called 'band'; the second \code{data.frame} consists of
#' two character columns: 'name' and 'surname'
#'
#' @author Alina Tselinina <tselinina@gmail.com>
#' @importFrom dplyr case_when
#' @importFrom stringi stri_replace_last_fixed
#' @importFrom magrittr %>%
#'
#' @example
#' prepareStoryAboutMusician('John Lenon',
#' list(data.frame(list('band'='The Rolling Stone')),
#' data.frame(list('name'='Paul', 'surname'='McCartney'))))
#'
#' @return A \code{list} of two \code{character} with the stories; the first story
#' describes the musician-bands relations; the second - musician-musicians relations
#'
prepareStoryAboutMusician <- function(name, tableList) {

    # story about all the bands the musician played in (musician - bands relations)
    MBstory <-  case_when(
      nrow(tableList[[1]]) == 0 ~ paste0(name, " haven't played in any bands yet :( "),
      nrow(tableList[[1]]) == 1 ~ paste0(name, " was playing in ", paste(tableList[[1]]$band, collapse = ""), "."),
      TRUE ~ paste0("Experienced musician ", name, " played in many bands such as '",
                    paste(tableList[[1]]$band, collapse = "', '"), "'.") %>%
             stri_replace_last_fixed(., ',', ' and')
                )

    # story about all musicians the musician played with (musician - musicians relations)
    MMstory <-  case_when(
      nrow(tableList[[1]]) == 0 ~ paste0(name, " played alone."),
      nrow(tableList[[1]]) == 1 ~ paste0(name, " was playing with ",
                                         paste(tableList[[2]]$name, tableList[[2]]$surname, collapse = ' '), '.'),
      TRUE ~ paste0(name, " sang with many famous musicians such as ",
                    paste(paste0(tableList[[2]]$name, ' ', tableList[[2]]$surname), collapse = ', '), '!') %>%
             stri_replace_last_fixed(., ',', ' and')
                )

    return(list(MBstory, MMstory))
  }


#' Generate human-friendly story for Band
#'
#' Generate human-friendly story for Band based on the tables
#'
#' This function generates a story based on the list of two data frames. One
#' data frame contains the band names which the band played with. The second
#' table contains the name and surname of musicians who played in the band.
#' The story is being generated depending on the number of rows.
#'
#' @param name A \code{character} which is the name of band
#' @param tableList A \code{list} with two data frames; the first \code{data.frame} consists
#' of one \code{character} column called 'band'; the second \code{data.frame} consists of
#' two character columns: 'name' and 'surname'
#'
#' @author Alina Tselinina <tselinina@gmail.com>
#' @importFrom dplyr case_when
#' @importFrom stringi stri_replace_last_fixed
#' @importFrom magrittr %>%
#'
#' @example
#' prepareStoryAboutBand('The Beatles',
#' list(data.frame(list('band'='The Rolling Stone')),
#' data.frame(list('name'='Paul', 'surname'='McCartney'))))
#'
#' @return A \code{list} of two \code{character} with the stories; the first story
#' describes the band-bands relations; the second - band-musicians relations
#'
prepareStoryAboutBand <- function(name, tableList) {

  # story about all bands played with a chosen band (band - bands relations)
  BBstory <-  case_when(
    nrow(tableList[[1]]) == 0 ~ paste0(name, " haven't played with another bands."),
    nrow(tableList[[1]]) == 1 ~ paste0("'", name, "' was on the same stage with '",
                                       paste(tableList[[1]]$band, collapse = ''),
                                       "' band."),
    TRUE ~ paste0("Popular band '", name, "' played with lots of other bands like '",
                  paste(tableList[[1]]$band, collapse = "', '"), "'.") %>%
           stri_replace_last_fixed(., ',', ' and')
              )

  # story all musicians played in a chosen band (band - musicians relations)
  BMstory <-  case_when(
    nrow(tableList[[2]]) == 0 ~ paste0("No one haven't played in the '", name, "' yet."),
    nrow(tableList[[2]]) == 1 ~ paste0("Famous singer ",
                                       paste(tableList[[2]]$name, tableList[[2]]$surname, collapse = ' '),
                                       " was in the '", name, "'."),
    TRUE ~ paste0("Many musicians such as ",
                  paste(paste0(tableList[[2]]$name, ' ', tableList[[2]]$surname), collapse = ', '),
                  " were part of '", name, "' band!") %>%
           stri_replace_last_fixed(., ',', ' and')
              )

  return(list(BBstory, BMstory))
}
