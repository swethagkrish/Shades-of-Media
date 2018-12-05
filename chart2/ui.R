library(shiny)
library(plotly)
library(dplyr)

shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectizeInput('movie', "Search for a movie:", choices = NULL, multiple = FALSE, uiOutput("movieSearch"))
    ),
    mainPanel(
      plotlyOutput("charwords")
    )
  )

))
