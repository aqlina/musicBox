context("check if there is a view 'prepared_events' and its columns")

test_that("there is wrong view 'prepared_events' or no view was made", {

  expect_identical(
    sapply(dbReadTable(
      getConnectionToDB(), "prepared_events"
    ), class),
    c(
      "event_name" = "character",
      "musician_id" = "integer",
      "musician_name" = "character",
      "musician_surname" = "character",
      "band" = "character"
    )
  )
})
