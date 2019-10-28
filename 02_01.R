# Create an app that greets the user by name.

library(shiny)

# UI
ui <- fluidPage(
  textInput("in_name", "What is your name?"),
  textOutput("out_greeting")
)

# Server
server <- function(input, output, session) {
  output$out_greeting <- renderText({
    paste0("Hello, ", input$in_name)
  })
}

# Run the application
shinyApp(ui = ui, server = server)