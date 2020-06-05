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
    dashboardSidebar(
        
        sidebarMenu(
            
            menuItem("Predictor",tabName="predictor",icon=icon("predictor")),
            menuItem("Project Summary",tabName= "overview",icon=icon("overview")),
            menuItem("Milestone Report",tabName="milestone",icon=icon("milestone")),
            menuItem("Top N-Gram Plots",tabName="plots",icon=icon("plots")),
            menuItem("Citations and Sources",tabName="citations",icon=icon("citations"))
        )
        
    ),
    dashboardBody(
        
        tabItems(
         
            tabItem(tabName="predictor",class="active",       
            
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
            ),
        
        tabItem(tabName="milestone",       
                
                mainPanel(
                    h2("Milestone Report"),
                    br(),
                    br(),
                    h4("The milestone report was a report written about one third of the way through the project. It gives a good overview of exploring the data structure and the n-grams results. If you are interested in the initial exploration of data, it can be downloaded at:"),
                    a("RPubs link",href="https://rpubs.com/Aquinas/619884")
                )
                ),   
        
        tabItem(tabName="overview",       
                
                mainPanel(
                    h2("Project Summary"),
                    br(),
                    h4("The Text Predictor project is designed to build a predictive-text model based upon a corpus of text provided by SwiftKey, drawing from blogs, news articles, and tweets. The rubric was to be able to enter one or more words, and the app would predict the next words in the sequence based upon the corpus provided by SwiftKey."),
                    br(),
                    h4("The corpus was quite large, and I was limited by the size of my machine memory for processing the data. Even after cleaning up the data, I was only able to use 40% of the corpus as a sample in order to train the predictor algorithm. Comparing to others who have attempted the same, the results were pretty solid overall: a 23.5% accuracy rate. Even better, if you test the Top 20 trigrams, you will find a 76% accuracy, and most of the errors which do exist come from trigrams which start identically (for example: 'I don't know' and 'I don't want.')"),
                    br(),
                    h4("The results were acheived by following a process similar to that taught in the Data Science Dojo videos. The corpus was cleaned up, and then a Katz Backoff model was used with J-M smoothing to make the predictions."),
                    br(),
                    h4("For future work, I would propose a larger corpus (including things like fiction), and enough machine power to use at least 70% of the corpus as a training sample."),
                    br(),
                    h4("The slideshow 'selling' the project to a company's investors is included at this link:"),
                    a("Slideshow",href="https://rpubs.com/Aquinas/624216")
                )
        ),   

                tabItem(tabName="plots",       
                
                mainPanel(
                    h2("Top N-Gram Plots from Exploratory Analysis"),
                    br(),
                    br(),
                    img(src="unigrams.png",width="50%"),
                    br(),
                    br(),
                    img(src="bigrams.png",width="50%"),
                    br(),
                    br(),
                    img(src="trigrams.png",width="50%")
                )
        ),   

        tabItem(tabName="citations",       
                
                mainPanel(
                    h2("Citations and Sources"),
                    br(),
                    br(),
                    h4("This project was extremely challenging, and required a significant amount of research. I learned a lot through the process."),
                    br(),
                    h4("Below are a series of sources and citations that were invaluable to me, and which I hope will help anyone else looking to achieve a similar outcome:"),
                    br(),
                    br(),
                    a("Data Science Dojo - the basis of most of my learning. Watch every video in the series.",href="https://www.youtube.com/watch?v=4vuw0AsHeGw"),
                    br(),
                    br(),
                    a("The Experiences of Partha Majumdar - a good real life example of trying to run text prediction; good ideas here.",href="https://parthamajumdar.org/2018/05/16/next-word-predictor/"),
                    br(),
                    br(),
                    a("Chosengmong Github Repo - another student who solved the code differently than I would have, but some good snippets in here for ideas.",href="https://github.com/chosengmong/Final_Capstone_Project/blob/master/milestone.R"),
                    br(),
                    br(),
                    a("Next Word Prediction with Katz Backoff - a fantastic three part series on how to approach the issues.",href="https://www.vitaarca.net/post/tech/dscapstone_report_1/"),
                    br(),
                    br(),
                    a("Derek Hashman Github Repo - some clever snippets of code here that solved a couple of my problems.",href="https://github.com/dhashman/datasciencecapstone/blob/master/capstone.R")
                )
        )   

                
        
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

