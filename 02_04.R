# Replace the UI and server components of your app from the previous exercise
# with the UI and server components below, run the app, and describe the app’s
# functionality. Then reduce the duplication in the app by using a reactive
# expression.

# Answer: Given x and y, the app prints x * y, x * y + 5 and x * y + 10.

# UI
ui <- fluidPage(
  sliderInput("x", "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", "and y is", min = 1, max = 50, value = 5),
  "then, (x * y) is", textOutput("product"),
  "and, (x * y) + 5 is", textOutput("product_plus5"),
  "and (x * y) + 10 is", textOutput("product_plus10")
)

# Server
server <- function(input, output, session) {
  
  # Add reactive expression to compute product
  prd <- reactive({
    input$x * input$y
  })
  
  output$product <- renderText({ 
    product <- prd()
    product
  })
  output$product_plus5 <- renderText({ 
    product <- prd()
    product + 5
  })
  output$product_plus10 <- renderText({ 
    product <- prd()
    product + 10
  })
}

# Run the application
shinyApp(ui = ui, server = server)