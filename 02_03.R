# Extend the app from the previous exercise to allow the user to set the value
# of the multiplier, y, so that the app yields the value of x * y

library(shiny)

# UI
ui <- fluidPage(
  sliderInput("x", "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", "and y is", min = 1, max = 50, value = 5),
  textOutput("result")
)

# Server
server <- function(input, output, session) {
  output$result <- renderText({
    paste0("then, x multiplied by 5 is ", input$x * input$y)
  })
}

# Run the application
shinyApp(ui = ui, server = server)