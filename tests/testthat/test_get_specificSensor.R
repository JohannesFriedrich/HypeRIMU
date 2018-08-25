context("Test get_specificSensor()")

test_that("Check class and length of output", {
  testthat::skip_on_cran()

  ## === TESTS === ##

  file <- system.file("extdata", "short_y_impulse.csv", package="HypeRIMU")
  data <- execute_file(file, timestamp = TRUE)
  MPL_Linear_Acceleration <- get_specificSensor(data, "MPL_Linear_Acceleration")

  expect_equal(ncol(MPL_Linear_Acceleration), 4)
  expect_equal(colnames(MPL_Linear_Acceleration), c("Timestamp",
                                                    "MPL_Linear_Acceleration.x",
                                                    "MPL_Linear_Acceleration.y",
                                                    "MPL_Linear_Acceleration.z"))
  expect_equal(class(MPL_Linear_Acceleration), "data.frame")

})

test_that("Check errors", {
  testthat::skip_on_cran()

  file <- system.file("extdata", "short_y_impulse.csv", package="HypeRIMU")
  data <- execute_file(file, timestamp = TRUE)

  expect_error(get_specificSensor())
  expect_error(get_specificSensor(data = data))


})
