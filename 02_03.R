# Suppose your friend wants to design an app that allows the user to set a
# number (x) between 1 and 50, and displays the result of multiplying this
# number by 5. This is their first attempt:

# But unfortunately it has an error:
# Can you help them find and correct the error?  

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