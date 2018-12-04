

library(shiny)
library(ggplot2)


shinyUI(fluidPage(
  titlePanel("IMDB Movie Revenue Based on Gender"),
  
#  sidebarLayout(
#   sidebarPanel(
#      
#      selectInput("bins",
#                  "Date Range: ",
#                  c("a","b"))
#    ),
    
    mainPanel(
      plotOutput("distPlot")
    )
  )
)
