# Modify the Central Limit Theorem app so that the sidebar is on the right
# instead of the left.

# UI
ui <- fluidPage(
  headerPanel("Central limit theorem"),
  sidebarLayout(
    sidebarPanel(
      numericInput("m", "Number of samples:", 2, min = 1, max = 100)
    ),
    mainPanel(
      plotOutput("hist")
    ),
    position = "right"
  )
)

# Server
server <- function(input, output, server) {
  output$hist <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20)
  })
}

# Run the app
shinyApp(ui = ui, server = server)