#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("C:/Users/mikeb/Documents/R/CourseRA R Projects/Capstone/helpers.R")

shinyServer(
    function(input, output) {
        output$text1 <- renderText({
            paste(filter_text(get_word(input$input_str)))
        })
        output$text2 <- renderText({
            paste(filter_text(get_pred(input$input_str)))
        })
    }
)
