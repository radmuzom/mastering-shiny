# Browse the themes available in the shinythemes package, pick an
# attractive theme, and apply it the Central Limit Theorem app.

# UI
ui <- fluidPage(
  theme = shinythemes::shinytheme(theme = "cosmo"),
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