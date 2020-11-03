## Get time json for first week of October 2020
x <- get_json_time(from = as.Date("2020-10-01"), to = as.Date("2020-10-07"))

test_that("json url is correct", {
  expect_true(stringr::str_detect(x, pattern = "2020-10-01"))
  expect_true(stringr::str_detect(x, pattern = "2020-10-07"))
})


## Get actions json
x <- get_json_actions(ccode = "PHL",
                      from = as.Date("2020-10-01"),
                      to = as.Date("2020-10-07"))

test_that("json url is correct", {
  expect_true(length(x) == 7)
})
