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
      menuItem("Nomina APP", tabName = "datasets", icon = icon("folder-open")),
      fileInput(
        "loadData", 
        "Cargar datos (Excel o CSV):", 
        accept = c(".csv", ".xlsx", ".xls")
      ),
      div(
        style = "display: flex; flex-direction: column; gap: 10px;",
        actionButton("editDiscounts", "Editar Descuentos", icon = icon("edit"), width = "87%"),
        actionButton("editColor", "Editar Color", icon = icon("paint-brush"), width = "87%"),
        actionButton("az05", "AZ-5", icon = icon("cogs"), width = "87%")
      )
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
              tabPanel("Manage", "Opciones de gestión aquí..."),
              tabPanel("View", "Opciones de visualización aquí..."),
              tabPanel("Visualize", "Opciones de visualización aquí..."),
              tabPanel("Pivot", "Opciones de pivote aquí..."),
              tabPanel("Explore", "Opciones de exploración aquí..."),
              tabPanel("Transform", "Opciones de transformación aquí..."),
              tabPanel("Combine", "Opciones de combinación aquí..."),
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

server <- function(input, output, session) {
  
  # Create reactive values to store the loaded script status and data
  rv <- reactiveValues(
    script_loaded = FALSE,
    script2_loaded = FALSE,  # New flag for second script
    data = NULL,
    nuevo_nombre = NULL,
    cambio = NULL
  )
  
  # Observe file input and load data
  observeEvent(input$loadData, {
    file <- input$loadData$datapath
    ext <- tools::file_ext(file)
    
    if (ext %in% c("xlsx", "xls")) {
      # Load the scripts if not already loaded
      if (!rv$script_loaded) {
        source("1. Cargar la Base.R", local = TRUE)
        rv$script_loaded <- TRUE
      }
      if (!rv$script2_loaded) {
        source("2. Nombre del Archivo Base.R", local = TRUE)  # Load second script
        rv$script2_loaded <- TRUE
      }
      
      # Now try to load and process the data
      tryCatch({
        # Load the initial data
        datos_cargados <- cargar_base(file)
        
        # Process the dates and get the new filename
        resultados <- procesar_fechas(datos_cargados)
        
        # Update reactive values
        rv$data <- resultados$data
        rv$nuevo_nombre <- resultados$nuevo_nombre
        rv$cambio <- resultados$cambio
        
      }, error = function(e) {
        showNotification(
          paste("Error loading file:", e$message),
          type = "error"
        )
      })
    } else if (ext == "csv") {
      tryCatch({
        rv$data <- read.csv(file)
      }, error = function(e) {
        showNotification(
          paste("Error loading file:", e$message),
          type = "error"
        )
      })
    } else {
      showNotification("Unsupported file type", type = "error")
    }
  })
  
  # Display data preview
  output$dataPreview <- renderTable({
    req(rv$data)
    head(rv$data)
  })
  
  # You can add observers to react to the new values if needed
  observe({
    req(rv$nuevo_nombre, rv$cambio)
    # Do something with the new filename and change status
  })
}

# Run the application 
shinyApp(ui = ui, server = server)