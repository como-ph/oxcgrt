x <- calculate_subindex(indicator_code = indicatorData$indicator[1],
                        value = indicatorData$value[1],
                        flag_value = indicatorData$flag_value[1])

test_that("output is numeric", {
  expect_is(x, "numeric")
})


x <- calculate_subindices(df = indicatorData,
                          indicator_code = "indicator",
                          value = "value",
                          flag_value = "flag_value",
                          add = TRUE)

test_that("output is a tibble", {
  expect_is(x, "tbl")
})

test_that("output tibble has the appropriate rows", {
  expect_equal(ncol(x), ncol(indicatorData) + 1)
})


x <- calculate_subindices(df = indicatorData,
                          indicator_code = "indicator",
                          value = "value",
                          flag_value = "flag_value",
                          add = FALSE)

test_that("output is a tibble", {
  expect_is(x, "tbl")
})

test_that("output tibble has the appropriate rows", {
  expect_equal(ncol(x), 4)
})


## Calculate OxCGRT index
y <- calculate_index(df = x,
                     codes = c(paste("C", 1:8, sep = ""),
                               paste("E", 1:2, sep = ""),
                               paste("H", 1:3, sep = ""), "H6"),
                     tolerance = 1)

test_that("output is numeric", {
  expect_is(y, "numeric")
})

## Calculate OxCGRT government response index
test_that("output is numeric and correct", {
  expect_is(calculate_gov_response(df = x), "numeric")
  expect_equal(calculate_gov_response(df = x), y)
})


## Calculate OxCGRT containment and health index
test_that("output is numeric", {
  expect_is(calculate_containment_health(df = x), "numeric")
})


## Calculate OxCGRT stringency index
test_that("output is numeric", {
  expect_is(calculate_stringency(df = x), "numeric")
})


## Calculate OxCGRT economic support index
test_that("output is numeric", {
  expect_is(calculate_economic_support(df = x), "numeric")
})


## Calculate all OxCGRT indices
y <- calculate_indices(df = x)

test_that("output is correct", {
  expect_is(y, "tbl")
  expect_equal(y$values[1], calculate_gov_response(df = x))
  expect_equal(y$values[2], calculate_containment_health(df = x))
  expect_equal(y$values[3], calculate_stringency(df = x))
  expect_equal(y$values[4], calculate_economic_support(df = x))
})


