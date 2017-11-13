#' Performs data acquisition from data received from TCP
#'
#' @param port [numeric] (**required**): Number of the port
#' @param timestamp [logical] (**with default**): Is a timestamp available in the data?
#' @param sensorNames [character] (**optional**): Name of the exported sensors
#' @param timout [integer] (**optional**): the timeout (in seconds) to be used for this connection.
#'
#' @examples
#' \dontrun{
#' ##==========================================
#' ## Example 1: read data from TCP connecntion
#' ##==========================================
#'
#' data <- execute_TCP(port = 5555, timestamp = T)
#' ## start HyperIMU app
#'
#' }
#' @md
#' @export

execute_TCP <- function(port,
                        timestamp = FALSE,
                        sensorNames = NULL,
                        timeout = 10) {

  ##============================================================================##
  ##ERROR HANDLING
  ##============================================================================##

  if(missing(port))
    stop("[execute_TCP()] Please provide a port", call. = FALSE)

  if(class(port) != "numeric")
    stop("[execute_TCP()] Argument port has to be of type numeric", call. = FALSE)

  if(class(timestamp) != "logical")
    stop("[execute_TCP()] Argument timestamp has to be of type logical",  call. = FALSE)

  if(!is.null(sensorNames) && class(sensorNames) != "character")
    stop("[execute_TCP()] Argument sensorNames has to be of type character",  call. = FALSE)

  available_sensorNames <- c("MPL_Gyroscope",
                             "MPL_Accelerometer",
                             "MPL_Magnetic_Field",
                             "MPL_Orientation",
                             "MPL_Rotation_Vector",
                             "MPL_Game_Rotation",
                             "MPL_Linear_Acceleration",
                             "MPL_Gravity",
                             "MPL_Significant_Motion",
                             "MPL_Step_Detector",
                             "MPL_Step_Coutner",
                             "MPL_Geomagnetic_Rotation",
                             "CM36686_Proximity_Sensor",
                             "CM36686_Light_Sensor",
                             "Screen_Orientation_Sensor")

  if(!is.null(sensorNames) && !sensorNames %in% available_sensorNames){
    stop(paste0("[execute_TCP()]: Sensor name not supported. Supported sensor names are: ", paste(available_sensorNames, collapse = ", "),  call. = FALSE))

  }

  ## open TCP connection

  data <- NULL

  cat("[execute_TCP()] >> Waiting for connection ...")
  con <- socketConnection("localhost", port = port, server = T, timeout = timeout)

  cat(paste0(" \n[execute_TCP()] >> Listening on port ", port))
  line <- readLines(con)
  data <- cbind(data, line)
  close(con)
  cat("\n[execute_TCP()] >> Close connection")

  ## transform data
  sensor_data_all <- t(apply(X = data, MARGIN = 1, FUN = function(x){
    as.numeric(unlist(strsplit(x, ",")))
  }))

  sensor_data_all <- as.data.frame(sensor_data_all)

  if(!timestamp && (ncol(sensor_data_all) %% 3 == 1)){
    cat("\n[execute_TCP()]: ")
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
    cat("\n[execute_file()]:")
    cat("No timestamp detected, but argument 'timestep = TRUE`. Set to 'FALSE'.\n")
    timestep <-  FALSE
  }

  if(!is.null(sensorNames) && timestamp){
    colnames(sensor_data_all) <- c("timestamp", paste0(rep(sensorNames, each=3), c(".x", ".y", ".z")))
  }

  return(sensor_data_all)
}
