

library(shiny)
library(ggplot2)


shinyUI(fluidPage(
  titlePanel("Gender Comparison: IMDB Movie Revenue VS. Time"),
  
  p("The revenue (in USD) that a movie has made based upon the findings within IMDB. 
    This plot charts the money a movie has made and compares those values based on female or male predominance in movies within the 1930s-2010s.You may select the year range for which you would want to compare.
    One would assume that a movie with higher ratings would make more money, but as we can see here, the movies that make the most money by far are with a strong male representation. 
    However, this does not exactly mean we are more inclined to deem the movie as successful. People may be rating these movies very similarly as shown in the previous chart but more money
    has been going to films with male predominance due to the sheer amount of movies with male representation in film, there are many more movies in general that have a male dominated cast.
    It is interesting to point out how in times of war, that decade it takes place in seems to take a spike in male dominated movies, this is possibly due to the increase of wartime media."),
  
  sidebarLayout(
   sidebarPanel(
      dateRangeInput("daterange", "Year Range", format = "yyyy",
                     min = "1931-01-01", max = "2015-12-31", 
                     start = "1931-01-01", end = "2015-12-31",
                     startview = "decade")),
    
    mainPanel("BLUE is male, PINK is Female",

            
      plotOutput("distPlot")
    )
  )
)
)
