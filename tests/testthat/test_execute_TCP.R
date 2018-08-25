context("Test execute_TCP()")

test_that("Check errors", {
  testthat::skip_on_cran()

  ## === TESTS === ##

  expect_error(execute_TCP("1"),
               regexp = "[execute_TCP()] Argument port has to be of type numeric",
               fixed = TRUE)

  expect_error(execute_TCP(5555, 1),
               regexp = "[execute_TCP()] Argument timestamp has to be of type logical",
               fixed = TRUE)

  expect_error(execute_TCP(5555, timestamp = T))
})
