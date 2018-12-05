library(R.utils)
library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
library(shinythemes)

source("../ratings_data.R")

my_ui <- fluidPage(theme = shinytheme("superhero"), 
tabsetPanel(
  tabPanel("Home",
                titlePanel("Gender Representation in Movies"), 
                h4("INFORMATION ABOUT DATA AND OUR PROJECT")
  ),
  tabPanel("Chart1",
           sidebarLayout(
             sidebarPanel(
               selectizeInput('movie', "Search for a movie:", choices = NULL, multiple = FALSE, uiOutput("movieSearch"))
             ),
             mainPanel(
               plotlyOutput("charwords")
             )
           ), br()
      ),
    tabPanel("Chart2",
             mainPanel(plotlyOutput("plot", height  = 500, width = 750), textOutput("summary")),
             br(), 
             sidebarPanel(
               sliderInput("Year", h2("Select a Year"),
                           min = 1971, max = 2015, value = 1971, sep = "",
                           step = 1, animate = animationOptions(interval = 1000, loop = FALSE)
               ),
               radioButtons(
                 "Rankings", h2("Select to Rank by IMDB Rating or Revenue"),
                 c("IMDB", "Revenue")
               ), h3("Due to the high volume of data for certain years, we have decided to select only 15 films.  
          Select the IMDB button to rank films by IMDB ratings or Select Revenue to rank by the movie's 
                     gross.Select a year with the slider or click on the play 
                     button to see a time lapse of gender representation through the years."),
               h3("Note: Visualization starts at 1971 instead of 1931, due to lack of data between 1931-1971")), 
             br()
             
    ),
   tabPanel("Chart3",
            titlePanel(h1(strong("IMDB Movie Ratings Over Time")), 
             h2(strong("comparing ratings of movies with a male lead 
                       versus the ratings of movies with a female lead"))),
  
  p(em("IMDB ratings are based upon the general population's vote.  This visualization provides 
       a comparison of people's ratings of movies with a strong male lead versus those with a female
       protagonist.")),
  
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("date", "Date Range:", start = start_date, end = end_date)
    ), 
    
    mainPanel(
      tabsetPanel(
        tabPanel("Comparison",
                 p(em("This graph contains", num_movies, "movies from", "different years.  It ranges from
                      ", start_date_words, "to ", end_date_words, ".  It compares the ratings for both
                      movies with male and female leads on the same graph.")),
                 plotOutput("mygraph")),
        
        tabPanel("Male",
                 p(em("This graph contains", num_movies_male, "movies from", "different years.  It ranges from
                      ", start_date_male_words, "to ", end_date_male_words, ".")),
                 plotOutput("mygraphmale")),
        
        tabPanel("Female",
                 p(em("This graph contains", num_movies_female, "movies from", "different years.  It ranges from
                      ", start_date_female_words, "to ", end_date_female_words, ".")),

                 plotOutput("mygraphfemale"))
      )
  )
  
), br()
),
tabPanel("chart4",
                   
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
  )))
shinyUI(my_ui) 