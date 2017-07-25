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

  if(!sensorNames %in% available_sensorNames){
    stop(paste0("[execute_TCP()] Sensor name not supported. Supported sensor names are: ", paste(available_sensorNames, collapse = ", ")))

  }

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
