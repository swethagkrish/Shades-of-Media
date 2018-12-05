library(dplyr)
library(ggplot2)
library(lubridate)
library(plotly)
library(stringr)

main_data <- read.csv("../mainData.csv", stringsAsFactors = FALSE)
one_lead <- main_data %>% 
  group_by(title) %>%
  filter(words == max(words)) %>%
  select(-vote_count, -revenue, -budget, -imdb_id, -script_id, -gross, -imdb_character_name, -age, -words, -X) %>%
  ungroup() 

start_date <- as.Date(min(one_lead$release_date))
end_date <- as.Date(max(one_lead$release_date))
start_date_words <- format(start_date, format = "%B %d, %Y")
end_date_words <- format(end_date, format = "%B %d, %Y")
num_movies_male <- nrow(filter(one_lead, gender == "m"))
num_movies_female <- nrow(filter(one_lead, gender == "f"))


# 1930s
s1930 <- one_lead %>%
  filter(year >= 1930) %>%
  filter(year <= 1939) %>%
  group_by(gender) %>%
  mutate(avg = median(vote_average)) %>%
  ungroup() %>%
  mutate(decade = "1930s") %>%
  select(decade, avg, gender)
s1930 <- unique(s1930)
s1930$avg <- round(s1930$avg, digits = 1)

# 1940s
s1940 <- one_lead %>%
  filter(year >= 1940) %>%
  filter(year <= 1949) %>%
  group_by(gender) %>%
  mutate(avg = median(vote_average)) %>%
  ungroup() %>%
  mutate(decade = "1940s") %>%
  select(decade, avg, gender)
s1940 <- unique(s1940)
s1940$avg <- round(s1940$avg, digits = 1)

# 1950s
s1950 <- one_lead %>%
  filter(year >= 1950) %>%
  filter(year <= 1959) %>%
  group_by(gender) %>%
  mutate(avg = median(vote_average)) %>%
  ungroup() %>%
  mutate(decade = "1950s") %>%
  select(decade, avg, gender)
s1950 <- unique(s1950)
s1950$avg <- round(s1950$avg, digits = 1)

# 1960s
s1960 <- one_lead %>%
  filter(year >= 1960) %>%
  filter(year <= 1969) %>%
  group_by(gender) %>%
  mutate(avg = median(vote_average)) %>%
  ungroup() %>%
  mutate(decade = "1960s") %>%
  select(decade, avg, gender)
s1960 <- unique(s1960)
s1960$avg <- round(s1960$avg, digits = 1)

# 1970s
s1970 <- one_lead %>%
  filter(year >= 1970) %>%
  filter(year <= 1979) %>%
  group_by(gender) %>%
  mutate(avg = median(vote_average)) %>%
  ungroup() %>%
  mutate(decade = "1970s") %>%
  select(decade, avg, gender)
s1970 <- unique(s1970)
s1970$avg <- round(s1970$avg, digits = 1)

# 1980s
s1980 <- one_lead %>%
  filter(year >= 1980) %>%
  filter(year <= 1989) %>%
  group_by(gender) %>%
  mutate(avg = median(vote_average)) %>%
  ungroup() %>%
  mutate(decade = "1980s") %>%
  select(decade, avg, gender)
s1980 <- unique(s1980)
s1980$avg <- round(s1980$avg, digits = 1)

# 1990s
s1990 <- one_lead %>%
  filter(year >= 1990) %>%
  filter(year <= 1999) %>%
  group_by(gender) %>%
  mutate(avg = median(vote_average)) %>%
  ungroup() %>%
  mutate(decade = "1990s") %>%
  select(decade, avg, gender)
s1990 <- unique(s1990)
s1990$avg <- round(s1990$avg, digits = 1)

# 2000s
s2000 <- one_lead %>%
  filter(year >= 2000) %>%
  filter(year <= 2009) %>%
  group_by(gender) %>%
  mutate(avg = median(vote_average)) %>%
  ungroup() %>%
  mutate(decade = "2000s") %>%
  select(decade, avg, gender)
s2000 <- unique(s2000)
s2000$avg <- round(s2000$avg, digits = 1)

# 2010s
s2010 <- one_lead %>%
  filter(year >= 2010) %>%
  filter(year <= 2019) %>%
  group_by(gender) %>%
  mutate(avg = median(vote_average)) %>%
  ungroup() %>%
  mutate(decade = "2010s") %>%
  select(decade, avg, gender)
s2010 <- unique(s2010)
s2010$avg <- round(s2010$avg, digits = 1)

decades <- bind_rows(s1930, s1940, s1950, s1960, s1970, s1980, s1990, s2000, s2010)
decades_grouped <- filter(decades, decades$decade == "1970s")


