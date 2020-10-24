# prepare human-friendly story about musician based on table
prepareStoryAboutMusician <-
  function(name, tableList, dbConnection) {
    
    # story about all the bands the musician played in
    MBstory <-  case_when(
      nrow(tableList[[1]]) == 0 ~ paste0(name, " haven't played in any bands yet :( "),
      nrow(tableList[[1]]) == 1 ~ paste0(name, " was playing in ", paste(tableList[[1]]$band, collapse = "")),
      TRUE ~ paste0("Experienced musician ", name, " played in many bands such as '",
                    paste(tableList[[1]]$band, collapse = "', '"), "'.") %>% 
             stri_replace_last_fixed(., ',', ' and')
                )
    
    # story about all musicians the musician played with
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

# prepare human-friendly story about chosen band based
prepareStoryAboutBand <- function(name, tableList, dbConnection) {
  
  # story about all bands played with a chosen band
  BBstory <-  case_when(
    nrow(tableList[[1]]) == 0 ~ paste0(name, " haven't played with another bands."),
    nrow(tableList[[1]]) == 1 ~ paste0("'", name, "' was on the same stage with '",
                                       paste(tableList[[1]]$band, collapse = ''),
                                       "' band"),
    TRUE ~ paste0("Popular band '", name, "' played with lots of other bands like '",
                  paste(tableList[[1]]$band, collapse = "', '"), "'.") %>% 
           stri_replace_last_fixed(., ',', ' and')
              )
  
  # story all musicians played in a chosen band
  BMstory <-  case_when(
    nrow(tableList[[2]]) == 0 ~ paste0("No one haven't played in the '", name, "' yet."),
    nrow(tableList[[2]]) == 1 ~ paste0("Famous singer ", 
                                       paste(tableList[[2]]$name, tableList[[2]]$surname, collapse = ' '),
                                       "was in the '", name, "'."),
    TRUE ~ paste0("Many musicians such as ", 
                  paste(paste0(tableList[[2]]$name, ' ', tableList[[2]]$surname), collapse = ', '),
                  " were part of '", name, "' band!") %>% 
           stri_replace_last_fixed(., ',', ' and')
              )
  
  return(list(BBstory, BMstory))
}