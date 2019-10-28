# Carefully read the documentation for sliderInput() to figure out how to
# create a date slider, as shown below.

library(shiny)

# UI
ui <- fluidPage(
  sliderInput("dateslider", "When should we deliver?",
              value = as.Date("2019-08-10"),
              min = as.Date("2019-08-09"),
              max = as.Date("2019-08-16"))
)

# Server
server <- function(input, output, session) {
  
}

# Run the app
shinyApp(ui = ui, server = server)