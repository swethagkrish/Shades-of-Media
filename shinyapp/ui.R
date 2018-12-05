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
             mainPanel(plotlyOutput("plot", height  = 600, width = 850), textOutput("summary")),
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
            titlePanel(h1(strong("IMDB Movie Ratings Over Time"))),
            
            p(em("IMDB ratings are based upon the general population's vote.  This visualization compares
                 the median IMDB movie rating for movies with a female lead versus movies with a male lead
                 for each decade.  You may select which decade(s) to view and compare.")),
            
            sidebarLayout(
              sidebarPanel(
                checkboxGroupInput("checked_decade", label = h3("Decades:"), 
                                   choices = list("1930s" = "1930s", "1940s" = "1940s", "1950s" = "1950s", 
                                                  "1960s" = "1960s", "1970s" = "1970s", "1980s" = "1980s", 
                                                  "1990s" = "1990s", "2000s" = "2000s", "2010s" = "2010s"),
                                   selected = c("1930s", "1940s", "1950s", "1960s", "1970s", "1980s", 
                                                "1990s", "2000s", "2010s")),
                hr(),
                fluidRow(column(3, verbatimTextOutput("checked_decade")))
              ), 
              
              mainPanel(strong("Bar Graph"), 
                        p(em("There are a total of ", num_movies_female, "movies with a female
                             lead and ",  num_movies_male, "movies with a male lead. We have movies ranging from ", start_date_words,"to ", end_date_words)),
                        plotlyOutput("mybargraph")
                        )
            )
),
tabPanel("chart4",
                   
         titlePanel("Revenue vs. Gender of the Lead"),
         
         sidebarLayout(
           sliderInput("RevYear", h2("Select a Year"),
                       min = 1931, max = 2015, value = 1971, sep = "",
                       step = 1, animate = animationOptions(interval = 5000, loop = FALSE)
           ), 
           mainPanel(plotlyOutput("boxPlot"))
         )                 
  ),
tabPanel("Conclusion",
         p("INSEArT CONCLUSION HERE"))
))
shinyUI(my_ui) 