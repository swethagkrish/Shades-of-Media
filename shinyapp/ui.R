library(shiny)
source("../ratings_data.R")

shinyUI(fluidPage(
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
    
    mainPanel("Graph",
              p(em("This graph contains", num_movies, "movies from", "different years.  It ranges from
                   ", start_date_words, "to ", end_date_words, ".  If you hover over a point, it will tell you the rating.")),
              plotOutput("mygraph"))
  )
  
))
