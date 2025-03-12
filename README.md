# Code Documentation 
## 1. Question_1.R ##
   * Load libraries
     1. `library(readr)`: For reading CSV files.
     2. `library(dplyr)`: For data manipulation.
     3. `library(tidyverse)`: For data wrangling and visualization.
     4. `library(ggplot2)`: For creating plots.
     
   * Load Data
     `graduate_survey <- read_csv("graduate_survey.csv"): Reads the survey data from a CSV file.`
     
   * Data Cleaning
     1. Selecting Relevant columns:
     `graduate_survey <- graduate_survey %>%
  select(Campus, StudyField, Branch, Role, EduLevel, ProgLang, Databases, Platform, WebFramework, Industry, AISearch, 'AIToolCurrently Using', Employment)`

     2. Removing Missing Values:
      `clean_df <- graduate_survey %>% na.omit()`
     
      3. Standardize Campus Names:
      `clean_df <- clean_df %>%
  mutate(Campus = case_when(
    Campus %in% c("Durban Campus", "Umhlanga Campus") ~ "Durban Campus",
    Campus %in% c("Mbombela Campus", "Nelspruit Campus") ~ "Mbombela Campus",
    Campus %in% c("Nelson Mandela Bay Campus", "Port Elizabeth Campus") ~ "Nelson Mandela Bay Campus",
    TRUE ~ Campus
  ))`

     4. Subset to Top Campuses:
      ` campus_counts <- table(clean_df$Campus)
sorted_counts <- sort(campus_counts, decreasing = TRUE)
top_campuses <- names(head(sorted_counts, 5))
df_top_campuses <- clean_df %>% filter(Campus %in% top_campuses)`

   * Save Cleaned Data:
      `saveRDS(df_top_campuses, "df_top_campuses.rds")`

## 2. Question_2.R ##
   * `Count_tools` = Counts the occurrences of tools in a specified column.
   * `plot_tools` = Creates a plot of the top plot tools
   * `saveRDS(list(plot_tools, plot_industry, plot_roles, plot_employment), "plots.rds")` = Saves the plots for use in the Shiny Application

## 3. app.R ##
  * UI Components:
    1. *Dashboard Header*
       * Title: "Eduvos IT Graduate Dashboard".
    2. *Sidebar*
       * Inputs for filtering data by StudyField and Employment.
    3. *Tabs*
       * Overview: Displays summary statistics.
       * Programming Languages: Displays top programming languages.
       * Databases: Displays top databases.
       * Web Frameworks: Displays top web frameworks.
      
  * Server Logic:
    1. Reactive data filtering
       * Filters data based on user inputs.
    2. Value Boxes
       * Displays total respondents, employment rate, and most popular programming language.
    3. Plots and Tables
       * Renders interactive plots and tables for programming languages, databases, and web frameworks.
      
# User Guide
## 1. How to use the application:
   1. Launch the application:
      * Click the link to open the application
   2. Filter Data:
      * Use the dropdown menus in the sidebar to filter the data by:
        * Study Field: Select one or more study fields.
        * Employment Status: Select one or more employment statuses.
   3. Explore the tabs
      * Overview = View summary statistics
      * Programming Languages = View a bar plot and table of the top programming languages
      * Databases = View a bar plot and table of the top databases
      * Webframeworks = View a bar plot and table of the webframeworks
   4. Interact with PLots
      * Hover curser over plots to see additional information
## 2. How to deploy app
   1. Prepare the files:
      * Make sure you have cloned the repo correctly and that the files are in the same directory
   2. Install the required packages:
      * run the follwing command in R: `install.packages(c("shiny", "shinydashboard", "tidyverse", "plotly", "DT", "readr", "dplyr", "ggplot2"))`
   3. Deploy to ShinyApps.io:
      * Run the following command in R: `rsconnect::deployApp()`
    


