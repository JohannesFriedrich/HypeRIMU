#' Performs data acquisition from local file
#'
#' @param filepath [character] (**required**): path and file to be imported.
#' @param timestamp [logical]: Is a timestamp available in the data?
#' @examples
#' ##=====================================
#' ## Example 1: read data from local file
#' ##=====================================
#'
#' file <- system.file("extdata", "HIMU-2017-07-25_11-26-18.csv", package="HypeRIMU")
#'
#' data <- execute_file(file, timestamp = TRUE)
#'
#' @md
#' @export

execute_file <- function(filepath, timestamp = FALSE) {

  sensor_data_all <- read.csv(file = filepath,
                              skip = 3)

  # convert from UNIX time

  ##check if timestamp = FALSE, but data suggest to have one:
  if(!timestamp && (ncol(sensor_data_all) %% 3 == 1)){
    cat("\n[execute_file()]: ")
    cat("Timestamp detected. Used first coloumn as timestamp.\n")
    timestep <- TRUE
    # convert from UNIX time
    sensor_data_all[,1] <- as.POSIXct(sensor_data_all[,1]/1000, origin = "1970-01-01")
  }

  if(timestamp && (ncol(sensor_data_all) %% 3 == 1)){
    # convert from UNIX time
    sensor_data_all[,1] <- as.POSIXct(sensor_data_all[,1]/1000, origin = "1970-01-01")
  }
  if(timestamp && (ncol(sensor_data_all) %% 3 != 1)){
    cat("\n[execute_file()]: ")
    cat("No timestamp detected, but argument 'timestep = TRUE`. Set to 'FALSE'.\n")
    timestep <- FALSE
  }


  return(sensor_data_all)
}
