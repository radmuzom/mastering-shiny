# If you have a moderately long list, it’s useful to create sub-headings that
# break the list up into pieces. Read the documentation for selectInput()
# to figure out how.

library(shiny)

# UI
ui <- fluidPage(
  selectInput("animals", "Animals",
              choices = list(`Canidae` = list("dog", "wolf"),
                             `Felidae` = list("cat", "tiger")))
)

# Server
server <- function(input, output, session) {
  
}

# Run the app
shinyApp(ui = ui, server = server)