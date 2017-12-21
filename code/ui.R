#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("slate"),
                  tags$head(
                    tags$style(HTML("
                                    @import url('//fonts.googleapis.com/css?family=Tangerine|Cabin:400,700');
                                    
                                    body {
                                    background-color:  	#FAF0E6;
                                    }"))
                    ),
                  
                  
                  headerPanel(
                    h1("Breact Cancer Predictor", 
                       style = "font-family: 'Lobster', cursive;
                       font-weight: 200; line-height: 1.1; 
                       color: #4d3a7d;")),
                  
                  
                  hr(),
                  
                  
                  fluidRow(
                    column(3, 
                           h4("Enter Tumor Dimensions"),
                           
                           numericInput("Area_worst", "area_worst", 0, min = NA, max = NA),
                           
                           numericInput("Concave.points_worst", "concave.points_worst", 0, min = NA, max = NA),
                           
                           numericInput("Perimeter_worst", "perimeter_worst", 0, min = NA, max = NA),
                           
                           numericInput("Radius_worst", "radius_worst", 0, min = NA, max = NA)
                           
                    ),
                    
                    column(4, offset = 1,
                           
                           numericInput("Texture_worst", "texture_worst", 0, min = NA, max = NA),
                           
                           numericInput("Concave.points_mean", "concave.points_mean", 0, min = NA, max = NA),
                           
                           numericInput("Area_se", "area_se", 0, min = NA, max = NA),
                           
                           numericInput("Texture_mean", "texture_mean", 0, min = NA, max = NA)
                           
                    ),
                    column(4,
                           
                           numericInput("Concavity_worst", "concavity_worst", 0, min = NA, max = NA),
                           
                           numericInput("Smoothness_worst", "smoothness_worst", 0, min = NA, max = NA),
                           
                           numericInput("Area_mean", "area_mean", 0, min = NA, max = NA),
                           
                           actionButton("start","submit")
                           
                    )
                  ),
                  
                  hr(),
                  
                  h3("The tumor is:",
                     style = "font-family: 'Lobster', cursive;
                       font-weight: 200; line-height: 1; 
                     color: #9932CC;"),
                  textOutput("prediction")
)
                  
                  
          
      
    )
