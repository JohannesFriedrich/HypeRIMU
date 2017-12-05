pageWithSidebar(
  headerPanel("HypeRIMU"),
  sidebarPanel(
    fileInput(inputId = "file",
              label = "Choose File"),
    # actionButton(inputId = 'start_TCP',
    #              label = 'Start TCP'),
    # numericInput(inputId = "port_number",
    #              label = "Port number",
    #              value = 5555),
    br(),
    uiOutput(outputId = "SensorNames_ui")
  ),
  mainPanel(
    plotOutput('plot')
  )
)

