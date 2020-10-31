context("check names and types of the columns read from DB")

test_that("tables musicians, bands and events have wrong name and/or types of columns",
          {
            expect_identical(
              sapply(dbReadTable(getConnectionToDB(), "musicians"), class),
              c(
                "id" = "integer",
                "name" = "character",
                "surname" = "character"
              )
            )
            expect_identical(sapply(dbReadTable(getConnectionToDB(), "bands"), class),
                             c("id" = "integer", "name" = "character"))

            expect_identical(
              sapply(dbReadTable(getConnectionToDB(), "events"), class),
              c(
                "id" = "integer",
                "name" = "character",
                "musician_id" = "integer",
                "band_id" = "integer"
              )
            )

          })
