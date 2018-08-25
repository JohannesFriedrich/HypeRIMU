#' Performs data acquisition from data received from JSON
#'
#' @param port [numeric] (**required**): Number of the port
#' @param timestamp [logical] (**with default**): Is a timestamp available in the data?
#' @param timeout [integer] (**optional**): the timeout (in seconds) to be used for this connection.
#'
#' @examples
#' \dontrun{
#' ##==========================================
#' ## Example 1: read data from JSON connecntion
#' ##==========================================
#'
#' data <- execute_JSON(port = 5555, timestamp = T)
#' ## start HyperIMU app
#'
#' }
#' @md
#' @export

execute_JSON <- function(port,
                        timestamp = FALSE,
                        timeout = 10) {

  ##============================================================================##
  ##ERROR HANDLING
  ##============================================================================##

  if(missing(port))
    stop("[execute_JSON()] Please provide a port", call. = FALSE)

  if(class(port) != "numeric")
    stop("[execute_JSON()] Argument port has to be of type numeric", call. = FALSE)

  if(class(timestamp) != "logical")
    stop("[execute_JSON()] Argument timestamp has to be of type logical",  call. = FALSE)

  ## open JSON connection

  data <- NULL

  cat("[execute_JSON()] >> Waiting for connection ...")
  con <- socketConnection("localhost", port = port, server = T, timeout = timeout, open = "rb")

  cat(paste0(" \n[execute_JSON()] >> Listening on port ", port))
  # line <- readBin(con, what = "raw", 1000)
  line <- readLines(con, n = 1)
  # text <- jsonlite::fromJSON(rawToChar(line))
  # document <- fromJSON(txt=line)

  print(line)
  # data <- cbind(data, line)
  close(con)
  cat("\n[execute_JSON()] >> Close connection")

  ## transform data
  sensor_data_all <- t(apply(X = data, MARGIN = 1, FUN = function(x){
    as.numeric(unlist(strsplit(x, ",")))
  })) %>%
    as.data.frame()

  if(!timestamp && (ncol(sensor_data_all) %% 3 == 1)){
    cat("\n[execute_JSON()]: ")
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
    cat("\n[execute_JSON()]:")
    cat("No timestamp detected, but argument 'timestep = TRUE`. Set to 'FALSE'.\n")
    timestep <-  FALSE
  }

  return(sensor_data_all)
}
