# Draw the reactive graph for the following server functions:

server1 <- function(input, output, session) {
  c <- reactive(input$a + input$b)
  e <- reactive(c() + input$d)
  output$f <- renderText(e())
}

# a ->
# b ->
#     c ->
#     d -> e -> f

server2 <- function(input, output, session) {
  x <- reactive(input$x1 + input$x2 + input$x3)
  y <- reactive(input$y1 + input$y2)
  output$z <- renderText(x() / y())
}

# x1 ->
# x2 ->
# x3 ->
#      x ->
# y1 ->
# y2 ->
#      y -> z

server3 <- function(input, output, session) {
  d <- reactive(c() ^ input$d)
  a <- reactive(input$a * 10)
  c <- reactive(b() / input$c) 
  b <- reactive(a() + input$b)
}

# input$a -> a ->
# input$b ->     b ->
# input$c ->         c ->
# input$d ->             d