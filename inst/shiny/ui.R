pageWithSidebar(
  headerPanel("HypeRIMU"),
  sidebarPanel(
    fileInput(inputId = "file",
              label = "Choose File"),
    actionButton(inputId = 'start_TCP',
                 label = 'Start TCP'),
    br(),
    uiOutput(outputId = "SensorNames_ui")
  ),
  mainPanel(
    plotlyOutput('plot')
  )
)

