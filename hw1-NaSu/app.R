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
library(DT)

# In the future the dplyr package might make all your data cleaning a bit easier. No pts removed.
data1 <- subset(mtcars,select = c(1:4))
name <- row.names.data.frame(mtcars)
newdata <- data.frame(name,data1)
newdata$name <- as.factor(newdata$name)
newdata$cyl <- as.factor(newdata$cyl)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Motor Cars Grid"),
  fluidRow(
    column(4,
           wellPanel(
             # The label should probably be renamed here since we're selecting Models of cars not characters. I deducted a few UI pts
             selectInput("char_select",
                         "Characters:",
                         choices = levels(newdata$name),
                         multiple = TRUE,
                         selectize = TRUE,
                         selected = c("Mazda RX4", "Duster 360","Cadillac Fleetwood","Lotus Europa","Maserati Bora")),
             selectInput("cyl_select",
                         "cyl:",
                         choices = levels(newdata$cyl),
                         multiple = TRUE,
                         selectize = TRUE,
                         selected = c("6", "8"))
           )       
    ),
    column(8,
           plotlyOutput("plot")
    )
  ),
  fluidRow(
    DT::dataTableOutput("table")
  )
)

# Define server logic
server <- function(input, output) {
  output$plot <- renderPlotly({
    dat <- subset(newdata, name %in% input$char_select)
    ggplot(data = dat, aes(x = name, y = as.numeric(mpg), fill = name)) + 
      geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))
  })
  output$table <- DT::renderDataTable({
    subset(newdata, name %in% input$char_select, select = c(name, mpg, cyl, disp, hp))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
