#===============================================================================
# Puede ejecutar la aplicación haciendo clic en el botón 'Run App' de arriba.
#===============================================================================
# Más información sobre la creación de aplicaciones con Shiny aquí:
# https://shiny.posit.co/
#===============================================================================
# APP - Nomina Version 1.0
#===============================================================================
# Limpiar el entorno
# rm(list = ls())
#===============================================================================
library(shiny)
library(shinydashboard)

# Define UI for application
ui <- dashboardPage(
  dashboardHeader(title = "Nomina App"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Datasets", tabName = "datasets", icon = icon("folder-open")),
      selectInput("dataset", "Datasets:", choices = c("diamonds", "mtcars")),
      checkboxInput("editDescription", "Add/edit data description", value = FALSE),
      checkboxInput("renameData", "Rename data", value = FALSE),
      radioButtons("displayOption", "Display:", choices = c("preview", "str", "summary")),
      fileInput("loadData", "Load data of type:", accept = c(".rds", ".rda", ".rdata")),
      downloadButton("saveData", "Save data to type:"),
      checkboxInput("showRcode", "Show R-code", value = FALSE),
      checkboxInput("removeFromMemory", "Remove data from memory", value = FALSE)
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "datasets",
        fluidRow(
          box(
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            tabsetPanel(
              tabPanel("Manage", "Manage options here..."),
              tabPanel("View", "View options here..."),
              tabPanel("Visualize", "Visualize options here..."),
              tabPanel("Pivot", "Pivot options here..."),
              tabPanel("Explore", "Explore options here..."),
              tabPanel("Transform", "Transform options here..."),
              tabPanel("Combine", "Combine options here..."),
              tabPanel(
                "Data preview",
                tableOutput("dataPreview")
              )
            )
          )
        )
      )
    )
  )
)

# Define server logic 
server <- function(input, output, session) {
  # Placeholder dataset
  dataset <- reactive({
    switch(input$dataset,
           "diamonds" = head(ggplot2::diamonds),
           "mtcars" = head(mtcars))
  })
  
  # Display data preview
  output$dataPreview <- renderTable({
    dataset()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
