library(shiny)
library(ggplot2)
library(plotly)


shinyUI(fluidPage(
  titlePanel("Revenue vs. Gender of the Lead"),
  
  sidebarLayout(
    sliderInput("RevYear", h2("Select a Year"),
                min = 1931, max = 2015, value = 1971, sep = "",
                step = 1, animate = animationOptions(interval = 5000, loop = FALSE)
    ), 
    mainPanel(plotlyOutput("boxPlot"))
  )
))
