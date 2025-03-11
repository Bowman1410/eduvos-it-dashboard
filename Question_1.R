library(readr)
library(dplyr)
library(tidyverse)
library(ggplot2)

graduate_survey <- read_csv("C:/Users/User/Documents/ITRDA/graduate_survey.csv")
View(graduate_survey)

# Question 1
#a- Selecting relevant columns
graduate_survey <- graduate_survey %>%
  select(Campus, StudyField, Branch, Role, EduLevel, ProgLang, Databases, Platform, WebFramework, Industry, AISearch, 'AIToolCurrently Using', Employment)

#b- Missing values
clean_df <- graduate_survey %>%
  na.omit()

#c- Standardizing cat columns
unique_values <- unique(clean_df$Campus)

clean_df <- clean_df %>%
  mutate(Campus = case_when(
    Campus %in% c("Durban Campus", "Umhlanga Campus") ~ "Durban Campus",
    Campus %in% c("Mbombela Campus", "Nelspruit Campus") ~ "Mbombela Campus",
    Campus %in% c("Nelson Mandela Bay Campus", "Port Elizabeth Campus") ~ "Nelson Mandela Bay Campus",
    TRUE ~ Campus
  ))

#d- Sub-setting data to top 3-5 most responded campuses
campus_counts <- table(clean_df$Campus)
sorted_counts <- sort(campus_counts, decreasing = TRUE)
top_campuses <- names(head(sorted_counts, 5))
df_top_campuses <- clean_df[clean_df$Campus %in% top_campuses, ]
head(df_top_campuses)

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Question 2







