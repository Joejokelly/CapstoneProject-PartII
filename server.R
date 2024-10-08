
library(shiny)
library(dplyr)
library(stringr)
library(quanteda)
library(RcppParallel)


# Define server logic required to draw a histogram
    shinyServer(function(input, output, session) {
        
        uni_words <- readRDS("uniary.rds")
        bi_words <- readRDS("binary.rds")
        tri_words <- readRDS("trinary.rds")
        
      #  data <- readRDS("uniary.rds")
      #  new_record <- data.frame(One_Word = "Viceroy", Frequency = 1)  
      #  data <- rbind(data, new_record)
      #  saveRDS(data, "uniary.rds")
      #  uni_words <- readRDS("uniary.rds")
        
        # function to return highly probable previous word given two successive words
        triWords <- function(wx1, wx2, n = 5) {
            pwords <- tri_words[.(wx1, wx2)][order(-Prob)]
            if (any(is.na(pwords)))
                return(biWords(wx2, n))
            if (nrow(pwords) > n)
                return(pwords[1:n, word_3])
            count <- nrow(pwords)
            bwords <- biWords(wx2, n)[1:(n - count)]
            return(c(pwords[, word_3], bwords))
        }
        
        # function to return highly probable previous word given a word
        biWords <- function(wx1, n = 5) {
            pwords <- bi_words[wx1][order(-Prob)]
            if (any(is.na(pwords)))
                return(uniWords(n))
            if (nrow(pwords) > n)
                return(pwords[1:n, word_2])
            count <- nrow(pwords)
            unWords <- uniWords(n)[1:(n - count)]
            return(c(pwords[, word_2], unWords))
        }
        
        # function to return random words from unigrams
        uniWords <- function(n = 5) {  
            return(sample(uni_words[, word_1], size = n))
        }
        
        # The prediction app
        pred_words <- function(str){
            if (str == ""){
                list_word <- list(first = "",
                                  second = "",
                                  third = "")
            }
            else{
                require(quanteda)
                length_word = str_count(str,"\\w+")
                tokens <- tokens(x = char_tolower(str))[[1]]
                
                if (length_word != 1) {
                  tokens <- char_wordstem(tokens[(length(tokens)-1):length(tokens)], language = "english")
                } else {
                  tokens <- char_wordstem(tokens[length(tokens)], language = "english")
                }
                
                if(length_word == 1){
                    predicted <- bi_words %>% filter(One_Word == tokens[1]) %>% arrange(desc(Frequency))
                    i = 2
                }
                else if(length_word >= 2){
                    predicted <- tri_words %>% filter(One_Word == tokens[1], Two_Words == tokens[2]) %>% arrange(desc(Frequency))
                    i = 3
                }
                list_word <- list(
                  first = if (nrow(predicted) >= 1) predicted[1, i] else "",
                  second = if (nrow(predicted) >= 2) predicted[2, i] else "",
                  third = if (nrow(predicted) >= 3) predicted[3, i] else ""
                )
                
            }
            return(list_word)
        }
        
        pbutton <- reactive({
            pb1 = pred_words(input$inputString)
            pb1
        })
        
        output$show <- renderUI({
            tags$div(
            
            actionButton("predict1", label = ifelse(is.null(pbutton()$first) || pbutton()$first == "", "N/A", pbutton()$first)),
            actionButton("predict2", label = ifelse(is.null(pbutton()$second) || pbutton()$second == "", "N/A", pbutton()$second)),
            actionButton("predict3", label = ifelse(is.null(pbutton()$third) || pbutton()$third == "", "N/A", pbutton()$third))
            
        )
          
        })
        
        observeEvent(input$predict1, {
            updateTextInput(session, "inputString", value = paste(input$inputString, pbutton()$first))
        }) 
        
        observeEvent(input$predict2, {
            updateTextInput(session, "inputString", value = paste(input$inputString, pbutton()$second))
        })
        
        
        observeEvent(input$predict3, {
            updateTextInput(session, "inputString", value = paste(input$inputString, pbutton()$third))
        }) 
        
    })        
    
    
    
