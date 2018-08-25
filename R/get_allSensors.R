#' Extract sepcific sensor from data
#'
#' @param data [data.frame] (**required**): [data.frame] from [execute_file] or [execute_TCP].
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
#' MPL_Linear_Acceleration <- get_allSensors(data)
#'
#'
#' @md
#' @export
#'

get_allSensors <- function(data){

  ##============================================================================##
  ##ERROR HANDLING
  ##============================================================================##

  if(missing(data))
    stop("[get_specificSensor()] Argument 'data' is missing", call. = FALSE)

  if(class(data) != "data.frame")
    stop("[get_specificSensor()] Argument data has to be a data.frame", call. = FALSE)

  ## extract all sensors available in the data

  available_colNames <- colnames(data)

  if(!any(is.na(available_colNames))) {

    if("Timestamp" %in% available_colNames){
      temp <- available_colNames[-1]
      available_colNames_unique <- unique(c("Timestamp", substr(temp, 1, nchar(temp)-2)))
    } else {
      available_colNames_unique <- unique(substr(available_colNames, 1, nchar(available_colNames)-2))
    }
  } else {

    available_colNames_unique <- NA

  }

  return(available_colNames_unique)

}
