#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        output$plot1 <- renderPlot({
                # input <- NULL
                # setwd("/Users/toddrimes/Desktop/coursera/DataProducts/Week4/Project")
                deaths <- read.csv("http://www.rimesmedia.com/datascience/overdosesVdeathCounts.csv",stringsAsFactors = FALSE)
                statepops <- read.csv("http://www.rimesmedia.com/datascience/statepops.csv",stringsAsFactors = FALSE)
                
                popframe <- data.frame(name=statepops$name, population=statepops$population)
                deaths <- merge(deaths, popframe)
                
                state1 <- ifelse(!is.null(input$state1),input$state1,"Ohio")
                state2 <- ifelse(!is.null(input$state2),input$state2,"Connecticut")
                type1 <- ifelse(!is.null(input$type1),input$type1,"Number of Deaths")
                
                deaths1_1 <- deaths[ which(deaths$name==state1 & deaths$label==type1),]
                type2 <- ifelse(!is.null(input$type2),input$type2,"Number of Drug Overdose Deaths")
                
                deaths2_1 <- NULL
                deaths2_2 <- NULL
                showUSA <- ifelse(!is.null(input$showUSA),input$showUSA,FALSE)
                showNYC <- ifelse(!is.null(input$showNYC),input$showNYC,FALSE)
                
                if(!is.null(state2)){
                        # 1 type, 2 States
                        deaths2_1 <- deaths[ which(deaths$name==state2 & deaths$label==type1),]
                        dataset2 <- deaths2_1
                } else {
                        if(!is.null(type2)) {
                                # 2 types, 1 State
                                deaths1_2 <- deaths[ which(deaths$name==state1 & deaths$label==type2),]
                                dataset2 <- deaths1_2
                        } else {
                                # 1 type, 1 State + ( USA | NYC )
                                showUSA <- ifelse(!is.null(input$showUSA) & !showNYC,input$showUSA,FALSE)
                                showNYC <- ifelse(!is.null(input$showNYC) & !showUSA,input$showNYC,FALSE)
                                
                                if(!showNYC) {
                                        nyc_1 <- deaths[ which(deaths$name=="New York City" & deaths$label==type1),]
                                        dataset2 <- nyc_1
                                }
                                if(showUSA) {
                                        usa_1 <- deaths[ which(deaths$name=="United States" & deaths$label==type1),]
                                        dataset2 <- usa_1
                                }
                        }
                }
                d4 <- rbind(deaths1_1,dataset2)
                d4 <- d4[order(d4$state,d4$date),]
                customYLabel <- "Deaths, Previous 12 Months (000's)"
                # print("**************************************************")
                if(input$normalize==TRUE) {
                        cols <- grepl("count", names(d4))
                        d4[cols] <- lapply(d4[cols], `/`, d4$population)
                        d4[cols] <- lapply(d4[cols], `*`, 1000)
                        customYLabel <- "Deaths per 1000 Ppl, Previous 12 Months"
                        # print(d4)
                } else {
                        cols <- grepl("count", names(d4))
                        d4[cols] <- lapply(d4[cols], `/`, 1000)
                }
                if(nrow(d4)>0){
                        
                        library(RColorBrewer)
                        mycolors <- brewer.pal(8,"Set1")
                        x3 <- sample(1:8, 2)
                        mycolors[state1] <- mycolors[x3[1]]
                        mycolors[state2] <- mycolors[x3[2]]
                        ggplot(d4, aes(x=date, y=count, group=paste(state,label), color=state)) +
                                geom_path() +
                                geom_point() +
                                labs(title = type1) +
                                ylab(customYLabel) + 
                                xlab("Year/Month") + 
                                ylim(0, 1.25*max(d4$count)) +
                                theme(
                                        axis.title.y = element_text(color = "black"),
                                        axis.text.y = element_text(color = "black"),
                                        axis.title.y.right = element_text(color = "black"),
                                        axis.text.y.right = element_text(color = "black"),
                                        axis.text.x = element_text(angle = 90, hjust = 1)
                                )
                }
        })
})



