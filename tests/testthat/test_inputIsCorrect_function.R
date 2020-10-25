context("check the correctness of inputIsCorrect function")

test_that("function inputIsCorrect() returns wrong messages", {

  # check if the string with only spaces will cause a message
  expect_equal(inputIsCorrect(list(name = "    ", surname = "Smith"), musicians %>% select(-id)), FALSE)
  expect_equal(
    inputIsCorrect(
      list(name = "John", surname = "Lenon"),
      musicians %>% select(-id),
      message = TRUE
    ),
    "The values you want to add are already in this table."
  )

  # check if missing input from the User will cause a message
  expect_equal(
    inputIsCorrect(
      list(name = "John", surname = NA),
      musicians %>% select(-id),
      message = TRUE
    ),
    "Please fill all the gaps."
  )

  # check if double values in id columns will cause a message
  expect_equal(
    inputIsCorrect(
      list(
        name = "MusicFest",
        musician_id = 1.5,
        band_id = 9
      ),
      events %>% select(-id),
      message = TRUE
    ),
    "Please put only integer number into musician_id and band_id."
  )

  # check if NA and double type of input will cause a message with two instructions
  expect_equal(
    inputIsCorrect(
      list(
        name = "MusicFest",
        musician_id = 1.5,
        band_id = NA
      ),
      events %>% select(-id),
      message = TRUE
    ),
    "Please fill all the gaps. Please put only integer number into musician_id and band_id."
  )
})
