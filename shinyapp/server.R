library(shiny)
library(ggplot2)
library(plotly)
source("../ratings_data.R")

shinyServer(function(input, output) {
  
  num_decades <- reactive({length(input$checked_decade)})
  
  output$mybargraph = renderPlot({
    if (num_decades() == 9) {
      specific_decades <- decades 
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 8) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2] | 
                 decade == input$checked_decade[3] | 
                 decade == input$checked_decade[4] | 
                 decade == input$checked_decade[5] | 
                 decade == input$checked_decade[6] | 
                 decade == input$checked_decade[7] | 
                 decade == input$checked_decade[8])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 7) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2] | 
                 decade == input$checked_decade[3] | 
                 decade == input$checked_decade[4] | 
                 decade == input$checked_decade[5] | 
                 decade == input$checked_decade[6] | 
                 decade == input$checked_decade[7])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 6) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2] | 
                 decade == input$checked_decade[3] | 
                 decade == input$checked_decade[4] | 
                 decade == input$checked_decade[5] | 
                 decade == input$checked_decade[6])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 5) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2] | 
                 decade == input$checked_decade[3] | 
                 decade == input$checked_decade[4] | 
                 decade == input$checked_decade[5])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 4) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2] | 
                 decade == input$checked_decade[3] | 
                 decade == input$checked_decade[4])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 3) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2] | 
                 decade == input$checked_decade[3])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 2) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 1) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    }
  })  
})
