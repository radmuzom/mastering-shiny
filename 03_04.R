# Create a slider input to select values between 0 and 100 where the interval
# between each selectable value on the slider is 5. Then, add animation to the
# input widget so when the user presses play the input widget scrolls through
# automatically.

library(shiny)

# UI
ui <- fluidPage(
  sliderInput("stepslider", "Steps and Animate",
              value = 0, min = 0, max = 100,
              step = 5, animate = TRUE)
)

# Server
server <- function(input, output, session) {
  
}

# Run the app
shinyApp(ui = ui, server = server)