library(shiny)
library(tidyverse)
library(shinydashboard)
library(DT)

# reading in bcl data
bcl <- read.csv(here::here("bcl-data.csv"))



# adding a title component to the shiny dashboard header feature, including a picture and a clickable
# titles that will take users to the BCL webpage
title <- tags$a(
  href="https://www.bcliquorstores.com/",
  tags$img(src="cartoonliquor.png", height="50", width="50"),
  "BC Liquor Stores Data"
)

# order in which arguments are passed here defines in what order they will appear spatially
# on the webpage
ui <- fluidPage(
  # adjusting color aesthetic of the page and applying title created with hyperlink and image
  dashboardPage(ski = "black",
     dashboardHeader(title = h4(title),
                     titleWidth = 250
    )
    ,
    dashboardSidebar(
  # creating menu items in the sidebar of the dashboard for ease of navigation to view data tables or charts
      width = 250,
      sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("Charts", tabName = "charts", icon = icon("bar-chart-o")),
        menuItem("Table", tabName = "table", icon = icon("table"))
        )
    )
    ,
    dashboardBody(
  # populating the tab/each menu item with text and respective content
      tabItems(
        tabItem(tabName = "dashboard",
          h1(strong("Welcome to the BC Liquor Data Visualization Dashboard!", style = "font-si40pt")),
          br(),
          tags$div("This Shiny Dashboard has been created as an assignment for UBC's STAT 545B course. Students are tasked with building and deploying a Shiny App where they must demonstrate their ability to 
            display clear data findings, along with a clean and useful webpage UI. This page has been created using ",
                   tags$a(href="https://shiny.rstudio.com/",
                          "shiny"),
                   "and",
                   tags$a(href="hhttps://rstudio.github.io/shinydashboard/",
                          "shiny dashboard"),
                   "."
                   ),
          br(),
          p("Use the tabs on the left hand side of the page for navigation. Each tab accesses a different form of visualizaiton."),
          br(),
          a(href = "https://github.com/daattali/shiny-server/tree/master/bcl", 
           "Link to Original Dataset")
      )
      ,
      tabItem(tabName = "charts",
              h2(strong("BC Liquor Data : Histrogram Visualization")),
              br(),
              p("Using the Control panel on the right side of the page, filter data sorted by Alcohol Content based on price range,
                type of product, and country of origin."),
              br(),
              fluidRow(
                # putting the histogram and control panel into respective "boxes" on the dashboard
                box(
                  plotOutput("alcohol_hist"))
                ,
                box(
                  title = "Controls",
                  sliderInput("priceInput", "Price", 0, 100,
                              value = c(25,40), pre = "$"),
                  # changed radio buttons to be checkboxes, allowing users to search for multiple types of 
                  # alcohol at once
                  checkboxGroupInput("typeInput", "Type", 
                               choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                               selected = "BEER"),
                  # adding select bar widget such that users can choose to further filter histogram output by country
                  selectInput("countryInput", label = "Country", choices = unique(bcl$Country), selected = "Canada")),
                # adding text output that tells user how many options fit the criteria of their selected parameters   
                box(
                  textOutput("text"))
                )
              )
      ,
      tabItem(tabName = "table",
              h2(strong("BC Liquor Data : Data Table")),
              br(),
              p("Sort columns in ascending or descending order (alphabetically or numerically depending on column type) or
                search by keyword using the search bar located at the top right of the data table."),
              br(),
              # output entire data table to a new tab on the dashboard using the "DT" library, includes the ability to order
              # columns in ascending or descending order numerically or alphabetically (depending on column type) and search
              # by keyword 
              fluidRow(
                  DTOutput("mytable1"),
                  downloadButton("downloadData", 
                               "Download Results in CSV Format")
               )
              )
        
       )
      )
    )
  )
  

server <- function(input, output) {
  
  filtered_data <-  
    reactive(bcl %>% filter(Price > input$priceInput[1] &
                                          Price < input$priceInput[2] &
                                          Type %in% c(input$typeInput) &
                                          Country == input$countryInput))
  
  # must now add round brackets to whatever reactive variable is in the code to access
  output$alcohol_hist <- 
    renderPlot({
      filtered_data() %>%
      # adding additional filter to go along with the select bar widget
      filter(Country == input$countryInput) %>%
      ggplot(aes(Alcohol_Content)) + 
        geom_histogram(color = "darkblue", fill = "lightblue") +
        ggtitle("Count vs Alcohol Content") +
        theme_minimal() +
        xlab("Alcohol Content (%)") +
        ylab("Count")
      })
  
# creating output text that displays the number of options produced after filtering data
  output$text <- renderText({
    paste("We have found", nrow(filtered_data()), "options for you!")
  })
  
# new full data table to be displayed using the "DT" library
  output$mytable1 <-
    DT::renderDataTable({
      bcl
    })

  
# creating button for users to download the displayed the filtered table as a csv file 
  output$downloadData <- downloadHandler(
    filename = function(){
      paste("bcl-data.csv", sep="")
    },
    content = function(file) {
      s = input$mytable1_rows_all
      write.csv(bcl[s, , drop=FALSE], file)
    }
  )
}

shinyApp(ui = ui, server = server)
