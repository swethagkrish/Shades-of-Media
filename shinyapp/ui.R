library(shiny)
source("../ratings_data.R")

shinyUI(fluidPage(
  titlePanel(h1(strong("IMDB Movie Ratings Over Time"))),
  
  p(em("IMDB ratings are based upon the general population's vote.  This visualization compares
       the average IMDB movie rating for movies with a female lead versus movies with a male lead
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
    
    mainPanel("Bar Graph", 
              p(em("There are a total of ", num_movies_female, "movies with a female
                   lead and ",  num_movies_male, "movies with a male lead. We have movies ranging from ", start_date_words,"to ", end_date_words)),
              plotOutput("mybargraph")
  )
))
)
