#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(reshape2)
library(dplyr)
library(plotly)
library(shinythemes)

library(shiny)
library(reshape2)
library(dplyr)
library(plotly)
library(shinythemes)


data1 <- subset(mtcars,select = c(1:4))
name <- row.names.data.frame(mtcars)
newdata <- data.frame(name,data1)
newdata$name <- as.factor(newdata$name)

pdf(NULL)

# Define UI for application that draws a histogram
ui <- fluidPage(
  navbarPage("Star Wars NavBar", 
             theme = shinytheme("united"),
             tabPanel("Plot",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("char_select",
                                      "Characters:",
                                      choices = levels(newdata$name),
                                      multiple = TRUE,
                                      selectize = TRUE,
                                      selected = c("Mazda RX4", "Duster 360"))
                        ),
                        # Output plot
                        mainPanel(
                          plotlyOutput("plot")
                        )
                      )
             ),
             # Data Table
             tabPanel("Table",
                      fluidPage(DT::dataTableOutput("table"))
             )
  )
)

# Define server logic
server <- function(input, output) {
  output$plot <- renderPlotly({
    datcars <- subset(newdata, name %in% input$char_select)
    ggplot(data = datcars, aes(x = name, y = as.numeric(mpg), fill = name)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))
  })
  output$table <- DT::renderDataTable({
    subset(newdata, name %in% input$char_select, select = c(name, mpg, cyl, disp, hp))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

