# When space is at a premium, it’s useful to label text boxes using a
# placeholder that appears inside the text entry area.
# How do you call textInput() to generate the UI below?

library(shiny)

# UI
ui <- fluidPage(
  textInput("name", "", placeholder = "Your name")
)

# Server
server <- function(input, output, session) {
  
}

# Run the app
shinyApp(ui = ui, server = server)