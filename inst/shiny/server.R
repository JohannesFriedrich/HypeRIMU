## Server.R

# allow upload until 200 MB
options(shiny.maxRequestSize = 200*1024^2)

shinyServer(function(input, output, session){

  theme_update(axis.text = element_text(size = 16),
                 axis.title = element_text(size = 16, face = "bold"),
                 axis.text.x = element_text(angle = 45, hjust = 1),
                 legend.text = element_text(size = 14),
                 legend.title = element_text(size = 14, face = "bold"),
                 legend.position = "bottom")


  names <- reactiveValues(input_name = NULL)
  timestamp <- reactiveValues(timestamp = NULL)

  data <- reactive({

    input_file <- input$file
    input_TCP <- input$start_TCP

    if (is.null(input_file)){
      if(is.null(input_TCP)){

        return(NULL)
      } else {
        observeEvent(input_TCP, {
          TCP_results <- execute_TCP(as.numeric(input$port_number), timestamp = FALSE)

          return(TCP_results)

        })
      }

      return(NULL)

    } else {

      names$input_name <- input_file

      return(execute_file(input_file$datapath))

    }

  }) ## end data <- reactive()

  output$SensorNames_ui <- renderUI({
    if (is.null(data()) || is.na(data())) {
      return()
      }

    if(ncol(data()) %% 3 == 1){
      timestampIndex <- which(str_split(names(data()), " ") == "timestamp")
      sensorNames <- unique(unlist(lapply(strsplit(names(data())[-timestampIndex], split =  ".", fixed = TRUE), "[[", 1)))
    } else {
      sensorNames <- unique(unlist(lapply(strsplit(names(data()), split = ".", fixed = TRUE), "[[", 1)))
    }

    selectInput("sensorName",
                "Sensors",
                choices = sensorNames
    )
  }) ## end renderUI()

  output$plot <- renderPlotly({

    if(is.null(data()) || is.na(data()) || is.null(input$sensorName)){
      return(NULL)
    }

    timestamp$timestamp <- ifelse(ncol(data()) %% 3 == 1, TRUE, FALSE)

    plot_data <- HypeRIMU::get_specificSensor(data(), sensorName = input$sensorName)
    plot_data_melt <- tidyr::gather(plot_data, Sensors, value, -timestamp)

    if(timestamp$timestamp){

      if(inherits(plot_data$timestamp, "POSIXct")){

        scale_x_datetime <- scale_x_datetime(labels = date_format("%H:%M:%S", tz = Sys.timezone()))

      } else {

        scale_x_datetime <- NULL

      }
    }

    ## PLOT
    g <- ggplot(plot_data_melt, aes(x = timestamp, y = value, color = Sensors)) +
      geom_line() +
      scale_x_datetime

    return(plotly::ggplotly(g))

  })## end renderPlot()

}) ## end  shinyServer

