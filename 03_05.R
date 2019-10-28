# Using the following numeric input box the user can enter any value between
# 0 and 1000. What is the purpose of the step argument in this widget?

# Answer: The step argument does not restrict the input by the user. It is only
# used when stepping between min and max.

library(shiny)

# UI
ui <- fluidPage(
  numericInput("number", "Select a value", value = 150,
               min = 0, max = 1000, step = 50)
)

# Server
server <- function(input, output, session) {
  
}

# Run the app
shinyApp(ui = ui, server = server)