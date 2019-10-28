# Re-create the Shiny app from the plots section, this time setting height
# to 300px and width to 700px.

library(shiny)

# UI
ui <- fluidPage(
  plotOutput("plot", width = "700px", height = "300px")
)

# Server
server <- function(input, output, session) {
  output$plot <- renderPlot(plot(1:5))
}

# Run the app
shinyApp(ui = ui, server = server)