#' Seperate sepcific Sensor from data
#'
#' @param data [data.frame] (**required**): [data.frame] from [execute_file] or [execute_TCP].
#' @param sensorName [character] (**required**): Which sensor should be extracted?
#'     Allowed sensor names: MPL_Gyroscope, MPL_Accelerometer, MPL_Magnetic_Field, MPL_Orientation,
#' MPL_Rotation_Vector, MPL_Game_Rotation, MPL_Linear_Acceleration, MPL_Gravity, MPL_Significant_Motion,
#' MPL_Step_Detector, MPL_Step_Coutner, MPL_Geomagnetic_Rotation, CM36686_Proximity_Sensor, CM36686_Light_Sensor,
#' Screen_Orientation_Sensor
#'
#' Note: Case sensitive
#'
#' @examples
#'
#' file <- system.file("extdata", "short_y_impulse.csv", package="HypeRIMU")
#'
#' data <- execute_file(file, timestamp = TRUE)
#'
#' MPL_Linear_Acceleration <- get_specificSensor(data, "MPL_Linear_Acceleration")
#'
#'
#' @md
#' @export
#'

get_specificSensor <- function(data, sensorName){

  ## Checks

  if(is(data)[1] != "data.frame"){
    stop("[get_specificSensor()] Argument data has to be a data.frame")

  }

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

  if(!sensorName %in% available_sensorNames){
    stop(paste0("[get_specificSensor()] Sensor not supported. Supported sensors are: ", paste(available_sensorNames, collapse = ", ")))

  }

  ## read available colnames

  available_colNames <- colnames(data)

  if("timestamp" %in% available_colNames){
    temp <- available_colNames[-1]
    available_colNames_unique <- unique(c("timestamp", substr(temp, 1, nchar(temp)-2)))
  } else {
    available_colNames_unique <- unique(substr(available_colNames, 1, nchar(available_colNames)-2))
  }

  ## get index for sensor
  sensorIndex <- grepl(pattern = sensorName, x = available_colNames)

  if(sum(sensorIndex) == 0){
    stop(paste0("[get_specificSensor()] Sensor not found in data set. Supported sensors are: ", paste(available_colNames_unique, collapse = ", ")))

  }

  if("timestamp" %in% available_colNames){
    timestepIndex <- grepl(pattern = "timestamp", x = available_colNames) ##Should be 1, but you never know
    return(data[, (sensorIndex | timestepIndex)])
  } else {
    return(data[,sensorIndex])
  }

}
