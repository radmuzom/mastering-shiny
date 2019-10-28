# The following app is very similar to one you’ve seen earlier in the chapter:
# you select a dataset from a package (this time we’re using the ggplot2
# package) and the app prints out a summary and plot of the data.
# It also follows good practice and makes use of reactive expressions to avoid
# redundancy of code. However there are three bugs in the code provided below.
# Can you find and fix them?

library(ggplot2)
library(shiny)

datasets <- data(package = "ggplot2")$results[, "Item"]

# UI
ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  #tableOutput("plot") # This should be plotOutput and not tableOutput
  plotOutput("plot")
)

# # Server
server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:ggplot2")
  })
  #output$summmry <- renderPrint({ # This should be summary
  output$summary <- renderPrint({
    summary(dataset())
  })
  output$plot <- renderPlot({
    #plot(dataset) # This should uses parantheses to call the reactive
    plot(dataset())
  })
}

# Run the application
shinyApp(ui = ui, server = server)