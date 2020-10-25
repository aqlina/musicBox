context("check if there are no NA and NULL values in the tables")

test_that("there are NA or NULL values inside the tables", {
  for (table in c("musicians", "bands", "events")) {
    expect_equal(all(!is.na(
      dbReadTable(getConnectionToDB(), table)
    )), TRUE)
  }

  for (table in c("musicians", "bands", "events")) {
    expect_equal(all(!is.null(
      dbReadTable(getConnectionToDB(), table)
    )), TRUE)
  }


})
