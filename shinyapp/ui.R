library(R.utils)
library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)

my_ui <- fluidPage(theme = shinytheme("cyborg"), 
                  titlePanel("Gender Representation in Movies"), 
                  h4("INFORMATION ABOUT DATA AND OUR PROJECT"), 
                  br(), 
                  sidebarPanel(
                        sliderInput("Year", h2("Select a Year"),
      min = 1971, max = 2015, value = 1971, sep = "",
      step = 1, animate = animationOptions(interval = 5000, loop = FALSE)
    ),
    radioButtons(
      "Rankings", h2("Select to Rank by IMDB Rating or Revenue"),
      c("IMDB", "Revenue")
    ), h3("Due to the high volume of data for certain years, we have decided to select only 15 films.  
          Select the IMDB button to rank films by IMDB ratings or Select Revenue to rank by the movie's 
          gross.Select a year with the slider or click on the play 
          button to see a time lapse of gender representation through the years."),
          h3("Note: Visualization starts at 1971 instead of 1931, due to lack of data between 1931-1971")), 
          br(), 
          sidebarLayout(
    sidebarPanel(
      selectizeInput('movie', "Search for a movie:", choices = NULL, multiple = FALSE, uiOutput("movieSearch"))
    ),
    mainPanel(
      plotlyOutput("charwords")
    )
  ), 
                   
  )
shinyUI(my_ui)
