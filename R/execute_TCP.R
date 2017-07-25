#' Performs data acquisition from local file
#'
#' @param port [numeric] (**required**): Number of the port
#' @param timestamp [logical]: Is a timestamp available in the data?
#' @param sensorNames [character] (**optional**): Name of the exported sensors
#'
#' @examples
#' \dontrun{
#'
#' data <- execute_TCP(port = 5555, timestamp = T)
#' ## start HyperIMU app
#'
#' }
#' @md
#' @export

execute_TCP <- function(port, timestamp = FALSE, sensorNames = NULL) {

  data <- NULL

  con <- socketConnection("localhost", port = port, server = T)
    line <- readLines(con)
    data <- cbind(data, line)
  close(con)

  ## transform data
  sensor_data_all <- t(apply(X = data, MARGIN = 1, FUN = function(x){
    as.numeric(unlist(strsplit(x, ",")))
  }))

  sensor_data_all <- as.data.frame(sensor_data_all)

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
    timestep <-  FALSE
  }

  if(!is.null(sensorNames) && timestamp){
    colnames(sensor_data_all) <- c("timestamp", paste0(rep(sensorNames,each=3), c(".x", ".y", ".z")))
  }

  return(sensor_data_all)
}
