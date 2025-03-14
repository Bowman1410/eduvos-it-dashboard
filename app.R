# Load necessary libraries
library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(DT)

# Source external R scripts
source("Get_The_Data.R", local = TRUE)  # Loads cleaned & prepped data
source("Get_The_Plots.R", local = TRUE)  # Loads visualization functions

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Eduvos IT Graduate Dashboard"),

  dashboardSidebar(
    selectInput("study_field", "Select Study Field:", choices = unique(df_top_campuses$StudyField), selected = "All", multiple = TRUE),
    selectInput("employment", "Employment Status:", choices = unique(df_top_campuses$Employment), selected = "All", multiple = TRUE),
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
      menuItem("Programming Languages", tabName = "prog_lang", icon = icon("code")),
      menuItem("Databases", tabName = "databases", icon = icon("database")),
      menuItem("Web Frameworks", tabName = "web_frameworks", icon = icon("laptop-code"))
    )
  ),

  dashboardBody(
    tabItems(
      tabItem(tabName = "overview",
              fluidRow(
                valueBoxOutput("total_respondents"),
                valueBoxOutput("employment_rate"),
                valueBoxOutput("most_popular_language")
              )
      ),

      tabItem(tabName = "prog_lang",
              fluidRow(
                plotlyOutput("prog_lang_plot"),
                DTOutput("prog_lang_table")
              )
      ),

      tabItem(tabName = "databases",
              fluidRow(
                plotlyOutput("databases_plot"),
                DTOutput("databases_table")
              )
      ),

      tabItem(tabName = "web_frameworks",
              fluidRow(
                plotlyOutput("web_frameworks_plot"),
                DTOutput("web_frameworks_table")
              )
      )
    )
  )
)

# Define Server
server <- function(input, output) {

  # Reactive data filtering
  filtered_data <- reactive({
    df_top_campuses %>%
      filter(StudyField %in% input$study_field & Employment %in% input$employment)
  })

  # Overview stats
  output$total_respondents <- renderValueBox({
    valueBox(nrow(filtered_data()), "Total Respondents", icon = icon("users"))
  })

  output$employment_rate <- renderValueBox({
    rate <- mean(filtered_data()$Employed == "Employed")
    valueBox(paste0(round(rate * 100, 1), "%"), "Employment Rate", icon = icon("percent"))
  })

    output$most_popular_language <- renderValueBox({
      lang <- count_tools(filtered_data(), "ProgLang") %>% slice(1) %>% pull(Separated)
      valueBox(lang, "Most Popular Language", icon = icon("code"))
    })

    # Programming Languages Plot
    output$prog_lang_plot <- renderPlotly({
      plot_tools(filtered_data(), "ProgLang", "Top 10 Programming Languages")
    })

    output$prog_lang_table <- renderDT({
      count_tools(filtered_data(), "ProgLang")
    })

    # Databases Plot
    output$databases_plot <- renderPlotly({
      plot_tools(filtered_data(), "Databases", "Top 10 Databases")
    })

    output$databases_table <- renderDT({
      count_tools(filtered_data(), "Databases")
    })

    # Web Frameworks Plot
    output$web_frameworks_plot <- renderPlotly({
      plot_tools(filtered_data(), "WebFramework", "Top 10 Web Frameworks")
    })

    output$web_frameworks_table <- renderDT({
      count_tools(filtered_data(), "WebFramework")
    })
}

# Run the application
shinyApp(ui = ui, server = server)
