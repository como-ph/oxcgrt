library(dplyr)

x <- get_json_time(from = "2020-07-18", to = "2020-07-25") %>%
  get_data_time()

test_that("output is a tibble", {
  expect_is(x, "tbl")
})


x <- get_json_actions(ccode = "AFG", on = "2020-07-16") %>%
  get_data_actions()

test_that("output is a list", {
  expect_is(x, "list")
})
