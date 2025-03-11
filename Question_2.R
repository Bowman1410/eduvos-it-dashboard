#a)
count_tools <- function(df_top_campuses, column_name) {
  df_top_campuses %>%
    dplyr::select(all_of(column_name)) %>%  # Explicitly call dplyr::select()
    drop_na() %>%
    mutate(Separated = strsplit(as.character(.data[[column_name]]), ";")) %>%
    unnest(Separated) %>%
    count(Separated, sort = TRUE) %>%
    top_n(10)  # Get top 10 tools
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
plot_tools(df_top_campuses, "ProgLang", "Top 10 Programming Languages")
plot_tools(df_top_campuses, "Databases", "Top 10 Databases")
plot_tools(df_top_campuses, "Platform", "Top 10 Platforms")
plot_tools(df_top_campuses, "WebFramework", "Top 10 Web Frameworks")
plot_tools(df_top_campuses, "AISearch", "Top 10 AI Search Tools")
plot_tools(df_top_campuses, "AIToolCurrently Using", "Top 10 AI Tools Use Cases for Developers")

#b)
industry_counts <- df_top_campuses %>%
  separate_rows(Industry, sep = ";") %>%
  count(Industry, sort = TRUE)
ggplot(industry_counts, aes(x = reorder(Industry, n), y = n)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +  # Flip for better readability
  labs(title = "Most Popular Industries for Graduates",
       x = "Industry",
       y = "Count") +
  theme_minimal()

#c)
role_counts <- df_top_campuses %>%
  separate_rows(Role, sep = ";") %>%
  count(StudyField, Role, sort = TRUE)

ggplot(role_counts, aes(x = reorder(Role, n), y = n, fill = StudyField)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +  # Flip for better readability
  labs(title = "Top Job Roles by Study Field",
       x = "Job Role",
       y = "Count",
       fill = "Study Field") +
  theme_minimal()

#d)
df_top_campuses <- df_top_campuses %>%
  mutate(Employed = ifelse(grepl("Employed", Employment), "Employed", "Unemployed"))
employment_rate <- df_top_campuses %>%
  group_by(StudyField) %>%
  summarize(EmploymentRate = mean(Employed == "Employed"))
ggplot(employment_rate, aes(x = StudyField, y = EmploymentRate)) +
  geom_col(fill = "steelblue") +
  labs(title = "Employment Rate by Study Field",
       x = "Study Field",
       y = "Employment Rate") +
  theme_minimal()
