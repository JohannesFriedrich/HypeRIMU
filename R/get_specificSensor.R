#' Extract sepcific sensor from data
#'
#' @param data [data.frame] (**required**): [data.frame] from [execute_file] or [execute_TCP].
#' @param sensorName [character] (**required**): Which sensor should be extracted?
#'
#' Note: Case sensitive
#'
#' @examples
#' ##=====================================
#' ## Example 1: extract sepcific sensor
#' ##=====================================
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

  ##============================================================================##
  ##ERROR HANDLING
  ##============================================================================##

  if(missing(data))
    stop("[get_specificSensor()] Argument 'data' is missing", call. = FALSE)

  if(missing(sensorName))
    stop("[get_specificSensor()] Argument 'sensorName' is missing", call. = FALSE)

  if(class(data) != "data.frame")
    stop("[get_specificSensor()] Argument data has to be a data.frame", call. = FALSE)


  ## read available colnames

  available_colNames <- colnames(data)

  ## check if "timestamp" is in sensor names (E.g. file)
  ## and change to "Timestamp" to unify

  if("timestamp" %in% available_colNames) {
    timestamp_index <- which("timestamp" %in% available_colNames)

    available_colNames[timestamp_index] <- "Timestamp"

    colnames(data) <- available_colNames

  }

   if("Timestamp" %in% available_colNames){
    timestamp_index <- which("timestamp" %in% available_colNames)
    temp <- available_colNames[-timestamp_index]
    available_colNames_unique <- unique(c("Timestamp", substr(temp, 1, nchar(temp)-2)))
  } else {
    available_colNames_unique <- unique(substr(available_colNames, 1, nchar(available_colNames)-2))
  }

  ## get index for sensor
  sensorIndex <- grepl(pattern = sensorName, x = available_colNames)

  if("Timestamp" %in% available_colNames){
    timestepIndex <- grepl(pattern = "Timestamp", x = available_colNames) ##Should be 1, but you never know
    return(data[, (sensorIndex | timestepIndex)])
  } else {
    return(data[,sensorIndex])
  }

}
