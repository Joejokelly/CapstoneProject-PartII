library(shiny)
library(dplyr)
library(stringr)
library(shinyWidgets)
library(RcppParallel)
library(RcppArmadillo)
#library(RcppArmadillo)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    setBackgroundColor(color = "#28a745"),
    # Application title
    tags$div(
        h2(HTML("<font color=\"#FFFFFF\"><b>Word Prediction Online App</b></font>"), align = "center")
    ),
    
    tags$div(
        h3(HTML("<font color=\"#FFFFFF\"><b>Please refer to below writeup how to use the app?</b></font>"), align = "center")
    ),
    tags$div(
        h5(HTML("<font color=\"#FFFFFF\">Welcome! 
            The app predicts the next word for your input text, and it predict the next three words, 
            you have to click the button with the predicted words, and it will add it to the text you have entered
            </font>"), align = "center"),
        br(),
        h5(HTML("<font color = \"#FFFFFF\"> Note: If the application will be unable to predict the next word and 'NA's will be displayed for all buttons.</font>"), align = 'center')),
    sidebarLayout(position = "left", 
                  sidebarPanel(
                      h4("Enter word/phrase"),
                      textInput("inputString", "", value = ""), width = 20, align = "center",
                      h4(HTML("<center>Predicted Next Word</center>")),
                      uiOutput("show")),
                  mainPanel(
                  )
    )
)
)

