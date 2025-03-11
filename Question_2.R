library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)

# Load the cleaned data
df_top_campuses <- readRDS("df_top_campuses.rds")

# a) Function to count tools
count_tools <- function(df_top_campuses, column_name) {
  df_top_campuses %>%
    select(all_of(column_name)) %>%
    drop_na() %>%
    mutate(Separated = strsplit(as.character(.data[[column_name]]), ";")) %>%
    unnest(Separated) %>%
    count(Separated, sort = TRUE) %>%
    top_n(10)
}

# Function to plot the top tools
plot_tools <- function(df_top_campuses, column_name, title) {
  tool_counts <- count_tools(df_top_campuses, column_name)

  ggplot(tool_counts, aes(x = reorder(Separated, n), y = n, fill = Separated)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    theme_minimal() +
    labs(title = title, x = "Tool", y = "Count") +
    theme(legend.position = "none")
}

# b) Industry counts plot
industry_counts <- df_top_campuses %>%
  separate_rows(Industry, sep = ";") %>%
  count(Industry, sort = TRUE)

plot_industry <- ggplot(industry_counts, aes(x = reorder(Industry, n), y = n)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Most Popular Industries for Graduates", x = "Industry", y = "Count") +
  theme_minimal()

# c) Role counts plot
role_counts <- df_top_campuses %>%
  separate_rows(Role, sep = ";") %>%
  count(StudyField, Role, sort = TRUE)

plot_roles <- ggplot(role_counts, aes(x = reorder(Role, n), y = n, fill = StudyField)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(title = "Top Job Roles by Study Field", x = "Job Role", y = "Count", fill = "Study Field") +
  theme_minimal()

# d) Employment rate plot
df_top_campuses <- df_top_campuses %>%
  mutate(Employed = ifelse(grepl("Employed", Employment), "Employed", "Unemployed"))

employment_rate <- df_top_campuses %>%
  group_by(StudyField) %>%
  summarize(EmploymentRate = mean(Employed == "Employed"))

plot_employment <- ggplot(employment_rate, aes(x = StudyField, y = EmploymentRate)) +
  geom_col(fill = "steelblue") +
  labs(title = "Employment Rate by Study Field", x = "Study Field", y = "Employment Rate") +
  theme_minimal()

# Save plots for use in the Shiny app
saveRDS(list(plot_tools, plot_industry, plot_roles, plot_employment), "plots.rds")
