#' Performs data acquisition from data received from JSON
#'
#' @param port [numeric] (**required**): Number of the port
#' @param timeout [integer] (**optional**): the timeout (in seconds) to be used for this connection.
#' @param return_JSON [logical] (**optional**): return JSON object? Default: FALSE (data.frame returned)
#'
#' @examples
#' \dontrun{
#' ##==========================================
#' ## Example 1: read data from JSON connecntion
#' ##==========================================
#'
#' data <- execute_JSON(port = 5555)
#' ## start HyperIMU app
#'
#' }
#' @md
#' @export

execute_JSON <- function(port,
                        timeout = 10,
                        return_JSON = FALSE) {

  ##============================================================================##
  ##ERROR HANDLING
  ##============================================================================##

  if(missing(port))
    stop("[execute_JSON()] Please provide a port", call. = FALSE)

  if(class(port) != "numeric")
    stop("[execute_JSON()] Argument port has to be of type numeric", call. = FALSE)

  if(class(return_JSON) != "logical")
    stop("[execute_JSON()] Argument return_JSON has to be of type logical",  call. = FALSE)

  ## open JSON connection

  cat("[execute_JSON()] >> Waiting for connection ...")
  con <- socketConnection("localhost", port = port, server = T, timeout = timeout, open = "rb")

  cat(paste0(" \n[execute_JSON()] >> Listening on port ", port))

  suppressWarnings({
    line <- readLines(con)
    close(con)
  })
  cat("\n[execute_JSON()] >> Close connection")

  ## transform data

  ## add ~ between }{ to separate them more easily
  temp_data <- gsub(pattern = "}{", replacement = "}~{", x = line, fixed = "true")
  temp_data <- strsplit(temp_data, split = "~")[[1]]

  sensor_data_all_list <- lapply(temp_data, FUN = function(x){
    jsonlite::fromJSON(x)
  })

  if(return_JSON) return(sensor_data_all)

  sensor_data_all <- as.data.frame(do.call(rbind, sensor_data_all_list))

  return(sensor_data_all)
}
