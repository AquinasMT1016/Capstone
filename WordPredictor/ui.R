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
library(shinycssloaders)
library(shinydashboard)

dashboardPage(
    dashboardHeader(title = "Aquinas Text Prediction Project"),
    dashboardSidebar(),
    dashboardBody(
        fluidRow(
            column(12,
                   br(),
                   h4("Enter a short prediction phrase below, and the app will search the corpus for the best next word:"),
            )
        ),
        
        fluidRow(
            column(6,
                   textInput("input_str", 
                             label = "(no punctuation please)", 
                             value = " ")
                   )             
            ),

            mainPanel(
                h4("Predicted Word"),
                
                verbatimTextOutput("text") %>% withSpinner(color="#290902")            
            )
            
    )
)


#shinyUI(fluidPage(
#    setBackgroundColor(
#        color = c("#F7FBFF", "#D2B271"),
#        gradient = "radial",
#        direction = c("top", "left")
#    ),
#    

#    titlePanel(h1("Aquinas' Text Predictor")),
#    tags$h1(tags$style(".titlePanel{ 
#                         color: red;
#                         font-size: 20px;
#                         font-style: italic;
#                         }")),
    
#    fluidRow(
#        column(12,
#               br(),
#               h4("Enter a short prediction phrase below, and the app will search the corpus for the best next word:"),
#                )
#            ),
#    
#    fluidRow(
#        column(6,
#               textInput("input_str", 
#                         label = "(no punctuation please)", 
#                         value = " "
#                           )             
#            )    
    
#    ),
    
#    mainPanel(
#       h4("Predicted Word"),
        
#         verbatimTextOutput("text") %>% withSpinner(color="#290902")            
#         )
    
#    ))

