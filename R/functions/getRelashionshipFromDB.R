#' Send queries to Postgres database to get relations
#'
#' Send queries to Postgres database to get relations between bands and musicians
#'
#' This function sends the queries to database to get band-bands and band-musician
#' relations
#'
#' @param name A \code{character} which is the name of band
#' @param dbConnection A connection to Postgres database
#'
#' @author "Alina Tselinina <tselinina@gmail.com>"
#'
#' @importFROM magrittr %>%
#' @importFROM RPostgres dbGetQuery
#' @importFROM tidyr separate mutate_at
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
#' @author "Alina Tselinina <tselinina@gmail.com>"
#'
#' @importFROM magrittr %>%
#' @importFROM RPostgres dbGetQuery
#' @importFROM tidyr separate mutate_at
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
