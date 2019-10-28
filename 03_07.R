#Add an additional plot to the right of the existing plot, and size it so
# that each plot takes up half the width of the app.

library(shiny)

# UI
ui <- fluidPage(
  column(6, plotOutput("plot1")),
  column(6, plotOutput("plot2"))
)

# Server
server <- function(input, output, session) {
  output$plot1 <- renderPlot(plot(1:5))
  output$plot2 <- renderPlot(plot(6:10))
}

# Run the app
shinyApp(ui = ui, server = server)