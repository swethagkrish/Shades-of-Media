library(dplyr)
library(ggplot2)
library(lubridate)
library(plotly)

main_data <- read.csv("mainData.csv", stringsAsFactors = FALSE)
one_lead <- main_data %>% 
  group_by(title) %>%
  filter(words == max(words)) %>%
  select(-vote_count, -revenue, -budget, -imdb_id, -script_id, -gross, -imdb_character_name, -age, -words) %>%
  ungroup()

start_date <- as.Date(min(one_lead$release_date))
end_date <- as.Date(max(one_lead$release_date))
start_date_words <- format(start_date, format = "%B %d, %Y")
end_date_words <- format(end_date, format = "%B %d, %Y")
num_movies <- nrow(one_lead)

# male
male_lead <- one_lead %>%
  filter(gender == "m") %>%
  select(release_date, vote_average)
male_lead$release_date <- as.Date(male_lead$release_date)
male_lead <- male_lead[order(as.Date(male_lead$release_date)), ]

start_date_male <- as.Date(min(male_lead$release_date))
end_date_male <- as.Date(max(male_lead$release_date))
start_date_male_words <- format(start_date_male, format = "%B %d, %Y")
end_date_male_words <- format(end_date_male, format = "%B %d, %Y")
num_movies_male <- nrow(male_lead)
highest_male_rating <- max(male_lead$vote_average)

# female
female_lead <- one_lead %>%
  filter(gender == "f") %>%
  select(release_date, vote_average)
female_lead$release_date <- as.Date(female_lead$release_date)

start_date_female <- as.Date(min(female_lead$release_date))
end_date_female <- as.Date(max(female_lead$release_date))
start_date_female_words <- format(start_date_female, format = "%B %d, %Y")
end_date_female_words <- format(end_date_female, format = "%B %d, %Y")
num_movies_female <- nrow(female_lead)
highest_female_rating <- max(female_lead$vote_average)
