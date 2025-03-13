library(readr)
library(dplyr)
library(tidyverse)
library(ggplot2)

# Load the dataset
graduate_survey <- read_csv("graduate_survey.csv")

# Question 1
# a) Selecting relevant columns
graduate_survey <- graduate_survey %>%
  select(Campus, StudyField, Branch, Role, EduLevel, ProgLang, Databases, Platform, WebFramework, Industry, AISearch, `AIToolCurrently Using`, Employment)

# b) Handling missing values
clean_df <- graduate_survey %>%
  na.omit()

# c) Standardizing categorical columns
clean_df <- clean_df %>%
  mutate(Campus = case_when(
    Campus %in% c("Durban Campus", "Umhlanga Campus") ~ "Durban Campus",
    Campus %in% c("Mbombela Campus", "Nelspruit Campus") ~ "Mbombela Campus",
    Campus %in% c("Nelson Mandela Bay Campus", "Port Elizabeth Campus") ~ "Nelson Mandela Bay Campus",
    TRUE ~ Campus
  ))

# d) Sub-setting data to top 3-5 most responded campuses
campus_counts <- table(clean_df$Campus)
sorted_counts <- sort(campus_counts, decreasing = TRUE)
top_campuses <- names(head(sorted_counts, 5))
df_top_campuses <- clean_df %>% filter(Campus %in% top_campuses)

# Save the cleaned data for use in the Shiny app
saveRDS(df_top_campuses, "df_top_campuses.rds")
