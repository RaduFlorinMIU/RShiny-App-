# French Real Estate Shiny App

This project is a simple Shiny web application developed as a part of a course project. It utilizes real estate data from the 9 biggest French cities to create visualizations and provide insights.

## Project Structure

- **Data Preparation Script**: This script (`data_preparation.R`) contains the code for cleaning and preparing the real estate data for visualization in the Shiny app.
  
- **Shiny App Scripts**:
  - **Global Script** (`global.R`): Contains code for loading necessary libraries and data.
  - **Server Script** (`server.R`): Defines the server logic required for the Shiny app, including data filtering and plotting.
  - **UI Script** (`ui.R`): Defines the user interface layout of the Shiny app, including input widgets and output displays.

## Features

- Geographical Plot: Visualizes real estate data on a geographical map, allowing users to filter by year, property type, and sale type.
  
- DataTable Visualization: Displays a datatable with detailed real estate data, allowing users to filter by city.

## Technologies Used

- R
- Shiny
- ggplot2
- DataTables

## Usage

1. Run the `CleaningTheData.R` script to clean and prepare the real estate data.
2. Run the Shiny app by executing the `server.R` and `ui.R` scripts together.
3. Use the filters provided in the app to explore the real estate data for the 9 biggest French cities.

