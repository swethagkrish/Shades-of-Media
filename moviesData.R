library(dplyr)
data <- read.csv("movies.csv", stringsAsFactors = FALSE)
movies <- data %>% select(title,release_date, vote_average, vote_count,revenue, budget, imdb_id)

