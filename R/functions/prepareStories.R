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
#' @author "Alina Tselinina <tselinina@gmail.com>"
#' @importFrom dplyr case_when
#' @importFrom stringi stri_replace_last_fixed
#' @importFROM magrittr %>%
#'
#' @examples
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
      nrow(tableList[[1]]) == 1 ~ paste0(name, " was playing in ", paste(tableList[[1]]$band, collapse = "")),
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
#' @author "Alina Tselinina <tselinina@gmail.com>"
#' @importFrom dplyr case_when
#' @importFrom stringi stri_replace_last_fixed
#' @importFROM magrittr %>%
#'
#' @examples
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
                                       "' band"),
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
