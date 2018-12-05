

library(shiny)
library(ggplot2)


shinyUI(fluidPage(
  titlePanel("Gender Comparison: IMDB Movie Revenue VS. Time"),
  
  sidebarLayout(
   sidebarPanel(
      dateRangeInput("daterange", "Year Range", format = "yyyy",
                     min = "1931-01-01", max = "2015-12-31", 
                     start = "1931-01-01", end = "2015-12-31",
                     startview = "decade")),
    
    mainPanel(
      plotOutput("distPlot")
    )
  )
)
)
