#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)

# Define UI for application that draws a histogram
fluidPage(
  
  # Application title
  titlePanel("Top 9 biggest cities' real Estade data from 2015 to 2019"),
  
  
  # Creating a navigation page for our app 
  navbarPage("Pages",
             tabPanel("Dataset",
                      
                      #####
                      # Sidebar with a slider input for number of bins
                      sidebarLayout(
                        sidebarPanel(
                          
                          # Select input City
                          pickerInput(inputId = "City", 
                                      label = "City", 
                                      choices = unique(real_estate_no_outliers$City),
                                      options = list(`actions-box` = TRUE), multiple = T
                          )
                        ),
                        
                        # Show a plot of the generated distribution
                        mainPanel(
                          tabsetPanel(type = "tabs",
                                      tabPanel("Real Estate table", dataTableOutput('Data'))
                          )
                        )
                      )
                      #####
             ), 
             
             tabPanel("Plots", 
                      sidebarLayout(
                        sidebarPanel(
                          pickerInput(inputId = "Year", 
                                      label = "Year of Sale", 
                                      choices = unique(real_estate_plot_data$Year),
                                      options = list(`actions-box` = TRUE), multiple = T, 
                                      selected = c(2015, 2016, 2017, 2018, 2019)
                          ), 
                          pickerInput(inputId = "local_type", 
                                      label = "Local Type", 
                                      choices = unique(real_estate_plot_data$`Local Type`),
                                      options = list(`actions-box` = T), multiple = T,
                                      selected = c("APARTMENT", "HOUSE")
                          ), 
                          pickerInput(inputId = "sale_type", 
                                      label = "Sale Type", 
                                      choices = unique(real_estate_plot_data$`Sale Type`),
                                      options = list(`actions-box` = T), multiple = T, 
                                      selected = c("SALE BEFORE COMPLETION", "SALE")
                          )
                        ),
                        
                        # Show a plot of the generated distribution
                        mainPanel(
                          tabsetPanel(type = "tabs", 
                                      tabPanel("Real Estate table", plotlyOutput('Plot'))
                          )
                          
                        )
                      )
                      
             ) 
             
  ) 
  
)