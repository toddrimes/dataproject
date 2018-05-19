#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

## FILENAME: overdosesVdeathCounts
## WORKINF DIRECTORY: /Users/toddrimes/Desktop/coursera/DataProducts/Week4/Project
library(shiny)

# Define UI for application that draws a histogram
library(shiny)
# setwd("/Users/toddrimes/Desktop/coursera/DataProducts/Week4/Project")
deaths <- read.csv("http://www.rimesmedia.com/datascience/overdosesVdeathCounts.csv",stringsAsFactors = TRUE)
stateList <- unique(deaths$name[deaths$is_state==TRUE])
labelList <- unique(deaths$label)
shinyUI(fluidPage(
        titlePanel("Drug Deaths by State - 12 months cumulative"),
        sidebarLayout(
                sidebarPanel(
                        selectInput("state1", "Choose first state:",
                                    stateList),
                        selectInput("state2", "Choose second state:",
                                    stateList),
                        selectInput("type1", "Choose a COD:",
                                    labelList),
                        checkboxInput("normalize","Normalize by Population", value = FALSE),
                        # adding the new div tag to the sidebar            
                        tags$div(class="footer", checked=NA,
                                 tags$a(href="https://www.healthdata.gov/dataset/vsrr-provisional-drug-overdose-death-counts", "Source: HealthData.gov"),
                                 tags$p(""),
                                 tags$p("This app enables comparison of drug related deaths between states.  Interestingly, the trends may appear parallel or flat between states, especially neighboring states.  However, normalizing deaths by population can tell a more alarming story!"),
                                 tags$p(""),
                                 tags$p("For instance, compare California and New York on Drug Overdose Deaths.  They look similar."),
                                 tags$p(""),
                                 tags$p("Then, check the 'Normalize' box."),
                                 tags$p(""),
                                 tags$p("Next, try Delaware and Florida.")
                        )
                ),
                mainPanel(
                        plotOutput("plot1")
                )
        )
))
