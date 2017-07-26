context("Test execute_file()")

test_that("Check class and length of output", {
  testthat::skip_on_cran()

  file <- system.file("extdata", "short_y_impulse.csv", package="HypeRIMU")
  data <- execute_file(file, timestamp = TRUE)

  ## === TESTS === ##

  expect_is(data, "data.frame")
  expect_equal(ncol(data) %% 3, 1)

})

test_that("Check errors", {
  testthat::skip_on_cran()

  file <- system.file("extdata", "short_y_impulse.csv", package="HypeRIMU")

  expect_error(execute_file(1),
               regexp = "[execute_file()] Argument 'file' has to be of type character",
               fixed = TRUE)

  expect_error(execute_file(file, 1),
               regexp = "[execute_file()] Argument 'timestamp' has to be of type logical",
               fixed = TRUE)

  expect_error(execute_file(),
               regexp = "[execute_file()] Argument 'file' is missing",
               fixed = TRUE)
})
