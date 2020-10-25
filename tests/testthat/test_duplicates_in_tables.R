context("check the absence of duplicated rows in all main tables")

test_that("there are duplicated rows in the table", {
  for (table in c("musicians", "bands", "events")) {
    expect_equal(nrow(dbReadTable(getConnectionToDB(), table) %>% select(-id)),
                 nrow(distinct(
                   dbReadTable(getConnectionToDB(), table) %>% select(-id)
                 )))

  }

})
