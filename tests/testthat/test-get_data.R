library(magrittr)
json_time <- get_json_time(from = "2020-07-18", to = "2020-07-25")
json_action <- get_json_actions(ccode = "Philippines",
                                from = "2020-07-18",
                                to = "2020-07-25")

x <- json_time %>% get_data()

test_that("output is a tibble", {
  expect_is(x, "tbl")
})

x <- json_time %>% get_data_time()

test_that("output is a tibble", {
  expect_is(x, "tbl")
})

x <- json_action %>% get_data()

test_that("warnings are released", {
  expect_warning(json_action %>% get_data())
})

test_that("output is a list", {
  expect_is(x, "list")
})

x <- json_action %>% get_data_action()

test_that("warnings are released", {
  expect_warning(json_action %>% get_data_action())
})

test_that("output is a tibble", {
  expect_is(x, "tbl")
})

x <- json_action %>% get_data_actions()

test_that("output is a tibble", {
  expect_is(x, "tbl")
})

x <- get_json_actions(ccode = "AFG", from = NULL, to = "2020-07-16") %>%
  get_data()

test_that("output is a list", {
  expect_is(x, "list")
})
