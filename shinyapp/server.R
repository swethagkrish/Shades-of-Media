library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
   date_range_male <- reactive({
     male_dates <- male_lead %>%
       filter(release_date >= input$date[1]) %>%
       filter(release_date <= input$date[2])
   })
   
   date_range_female <- reactive({
     female_dates <- female_lead %>%
       filter(release_date >= input$date[1]) %>%
       filter(release_date <= input$date[2])
   })
  
   output$mygraph = renderPlot({
     ggplot() +
       geom_area(data = date_range_male(), aes(x = release_date, y = vote_average), 
                 color = "lightblue", size = 2, fill = "lightblue") +
       geom_area(data = date_range_female(), aes(x = release_date, y = vote_average), 
                 color = "lightpink", size = 2, fill = "lightpink") +
       ylim(0, 10) + 
       labs(title = "A Comparison of Movie Ratings", 
            subtitle = "Male versus Female Leads", 
            caption = "Source", x = "Release Date",
            y = "IMDB Rating") + theme(panel.grid.minor = element_blank())
   })
  
})
