library(dplyr)
library(ggplot2)
library(lubridate)
library(plotly)

main_data <- read.csv("../mainData.csv", stringsAsFactors = FALSE)
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

# plot using line
ggplot() + 
  geom_line(data = male_lead, aes(x = release_date, y = vote_average), color = "lightblue", size = 3.5) +
  geom_line(data = female_lead, aes(x = release_date, y = vote_average), color = "lightpink", size = 3.5) +
  labs(title = "A Comparison of Movie Ratings", 
       subtitle = "Male versus Female Leads", 
       caption = "Source", x = "Release Date",
       y = "IMDB Rating") + theme(panel.grid.minor = element_blank())

# plot using area  
ggplot() +
  geom_area(data = male_lead, aes(x = release_date, y = vote_average), 
            color = "lightblue", size = 2, fill = "lightblue") +
  geom_area(data = female_lead, aes(x = release_date, y = vote_average), 
            color = "lightpink", size = 2, fill = "lightpink") +
  ylim(0, 10) + 
  labs(title = "A Comparison of Movie Ratings", 
       subtitle = "Male versus Female Leads", 
       caption = "Source", x = "Release Date",
       y = "IMDB Rating") + theme(panel.grid.minor = element_blank())

