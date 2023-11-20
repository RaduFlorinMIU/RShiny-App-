#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {
  
  # Reactive function to filter based on city
  real_estate_no_outliers_sub = reactive({
    data = real_estate_no_outliers %>% 
      filter(real_estate_no_outliers$City %in% input$City)
    return(data)
  })

    # Reactive function to filter for the rendering plots
  real_estate_plot_sub = reactive({
    data = real_estate_plot_data %>% 
      filter(real_estate_plot_data$Year %in% input$Year & real_estate_plot_data$`Local Type` %in% input$local_type & real_estate_plot_data$`Sale Type` %in% input$sale_type) %>% 
      group_by(lng, lat) %>% 
      summarise(total_price=sum(Price), total_living_are=sum(`Living Area`), number_of_sales=n()) %>% 
      mutate(price_m2=total_price/total_living_are)
    return(data) 
  })
  

      # Render Data table
  output$Data <- renderDataTable({
    real_estate_no_outliers_sub()
  })
  
  # Render plot
  output$Plot <- renderPlotly({
    
    plot = ggplot() +
      geom_polygon(data=france_map, 
                   aes(x = long, y = lat, group = group),
                   fill="lightgray", 
                   colour = "white"
      )+
      geom_point(data=real_estate_plot_sub(),
                 aes(x=lng, y=lat, size=number_of_sales, color=price_m2)
      )+
      geom_text(data=labels_data, aes(x=lng, y=lat, label = city), nudge_y = -0.4)+
      scale_size_area()+
      scale_colour_gradient(low="gold", high="green4")+
      theme_void()
    
    # Arranging the plot size so that it shows nicely on computer screen 
    ggplotly(plot) %>% layout(autosize = F, width = 700, height = 500)
  })
  
  # Command to stop the app when quitting R Shiny 
  session$onSessionEnded ( stopApp )
}
