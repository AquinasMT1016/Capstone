#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyUI(fluidPage(
    titlePanel("Predicting the Next Word"),
    
    fluidRow(
        column(12,
               br(),
               h4("To run the application, type a phrase in the box below."),
               br(),
               br()
        )
    ),
    
    fluidRow(
        column(6,
               textInput("input_str", 
                         label = "Enter some text without punctuation:", 
                         value = " "
               )             
        )    
    ),
    fluidRow(
        column(12,
               br(),
               br(),
               h4("Predicted next word:", style = "color:blue"), 
               verbatimTextOutput("text")            
        )
    )
))