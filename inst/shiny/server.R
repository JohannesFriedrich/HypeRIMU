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
          return(execute_TCP(as.numeric(input$port_number)))

        })
      }

      return(NULL)

    } else {

      names$input_name <- input_file

      return(execute_file(input_file$datapath))

    }

  }) ## end data <- reactive()

  output$SensorNames_ui <- renderUI({
    if (is.null(data())) {
      return() }

    if(ncol(data()) %% 3 == 1){
      timestampIndex <- which(strsplit(names(data()), " ") == "timestamp")
      sensorNames <- unique(unlist(lapply(strsplit(names(data())[-timestampIndex], split = ".", fixed = TRUE), "[[", 1)))
    } else {
      sensorNames <- unique(unlist(lapply(strsplit(names(data()), split = ".", fixed = TRUE), "[[", 1)))
    }

    selectInput("sensorName",
                "Sensors",
                choices = sensorNames
    )
  }) ## end renderUI()

  output$plot <- renderPlot({

    if(is.null(data())){
      return(NULL)
    }

    timestamp$timestamp <- ifelse(ncol(data()) %% 3 == 1, TRUE, FALSE)

    plot_data <- get_specificSensor(data(), sensorName = input$sensorName)
    plot_data_melt <- melt(plot_data, id.vars = "timestamp", variable.name = "Sensors")

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

    return(g)

  })## end renderPlot()

}) ## end  shinyServer

