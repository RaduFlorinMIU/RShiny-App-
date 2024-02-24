#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.

# Define UI for application that draws a histogram
fluidPage(
  
  # Application title
  titlePanel("Top 9 biggest cities' real Estade data from 2015 to 2019"),
  
  
  # Creating a navigation page for our app 
  navbarPage("Pages",
             
             # Creating the first tab Panel. Where a subset of the data will be displayed
             tabPanel("Dataset",
                      
                      # Sidebar with a slider input for number of bins
                      sidebarLayout(
                        sidebarPanel(
                          
                          # Select input City
                          pickerInput(inputId = "City", 
                                      label = "City", 
                                      choices = unique(real_estate_no_outliers$City),
                                      options = list(`actions-box` = TRUE), multiple = TRUE
                          )
                        ),
                        
                        # Show the subset of the data in the main panel  
                        mainPanel(
                          tabsetPanel(type = "tabs",
                                      tabPanel("Real Estate table", dataTableOutput('Data'))
                          )
                        )
                      )
             ), 
             
             # Creating the second tab Panel. Where the plot will be displayed
             tabPanel("Plots", 
                      
                      # Creating 3 different sidebars tha will be used to subset the dataset based on the 
                      # Year, Local Type and Sale Type
                      sidebarLayout(
                        sidebarPanel(
                          pickerInput(inputId = "Year", 
                                      label = "Year of Sale", 
                                      choices = unique(real_estate_plot_data$Year),
                                      options = list(`actions-box` = TRUE), multiple = TRUE, 
                                      selected = c(2015, 2016, 2017, 2018, 2019)
                          ), 
                          pickerInput(inputId = "local_type", 
                                      label = "Local Type", 
                                      choices = unique(real_estate_plot_data$`Local Type`),
                                      options = list(`actions-box` = TRUE), multiple = TRUE,
                                      selected = c("APARTMENT", "HOUSE")
                          ), 
                          pickerInput(inputId = "sale_type", 
                                      label = "Sale Type", 
                                      choices = unique(real_estate_plot_data$`Sale Type`),
                                      options = list(`actions-box` = TRUE), multiple = TRUE, 
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
