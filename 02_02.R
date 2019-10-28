# Suppose your friend wants to design an app that allows the user to set a
# number (x) between 1 and 50, and displays the result of multiplying this
# number by 5. This is their first attempt:
  
# But unfortunately it has an error:
# Can you help them find and correct the error?  

library(shiny)

# UI
ui <- fluidPage(
  sliderInput("x", "If x is", min = 1, max = 50, value = 30),
  textOutput("result")
)

# Server
server <- function(input, output, session) {
  output$result <- renderText({
    paste0("then, x multiplied by 5 is ", input$x * 5)
    #paste0("then, x multiplied by 5 is ", x * 5)
    # Need to use input$x rather than x
  })
}

# Run the application
shinyApp(ui = ui, server = server)