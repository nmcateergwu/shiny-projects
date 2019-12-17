# Individual Project
# Create an R Shiny application.
# Application must have multiple tabs
# and where user can choose certain inputs.
# Build application with own data.
# Upload Shiny app to the web.
# Recommend uploading to shinyapp.io
# Need to turn in web app and R code.

# Individual Project
# Create an R Shiny application.
# Application must have multiple tabs
# and where user can choose certain inputs.
# Build application with own data.
# Upload Shiny app to the web.
# Recommend uploading to shinyapp.io
# Need to turn in web app and R code.

library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(plotly)
library(rsconnect)

setwd('~/Desktop/MyApp/')

world_CO2 <- read_csv("CO2_Data.csv")
world_CO2 <- world_CO2 %>%
  gather(key = "year", value = "CO2_emissions", -`Country Name`:-`Indicator Code`) %>%
  rename(country_name = `Country Name`,
         country_code = `Country Code`,
         indicator_name = `Indicator Name`,
         indicator_code = `Indicator Code`)

x <- world_CO2$year
y <- world_CO2$CO2_emissions
z <- world_CO2$country_name


df <- data.frame(x , y, z)
df$x <- as.character(df$x)
df <- filter(df, x >= 2000)

##
ui <- fluidPage(
  tabsetPanel(
    tabPanel("Description", fluid = TRUE,
             mainPanel(h1("Description"),
                       p("This is an R Shiny web application"),
                       p("This R Shiny web application has two tabs: Description and Plot"),
                       p("The Plot tab shows a line graph of the different countries of the world
                         and their respective CO2 emissions in kilotons from the year 2000
                         to 2014."),
                       p("The sidebar panel on the left is used to choose which country's
                         CO2 emissions over time to display on the main panel")
             )
    ),
    tabPanel("Plot", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 selectInput("country",
                             label = "Choose Country to Display",
                             choices = z,
                             selected = df$z[1])
               ),
               mainPanel(h1("CO2 Emissions (kt) by Country", align = "center"),
                         plotlyOutput("line_graph"))
             )
    )
  )
)

server <- function(input, output) {
  rdf <- reactive({
    df %>%
      filter(z == input$country)
  })
  output$line_graph <- renderPlotly({
    ggplot(data = rdf(), aes(x, y, group = 2)) + geom_line() + labs(x = "Year", y = "CO2 Emission (kt)")
  })
}

shinyApp(ui, server)





