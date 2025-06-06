#===============================================================================
# Limpiar el entorno
rm(list = ls())
cat("\014")
#===============================================================================
tryCatch({
  source("0. Codigo/Codigo por Partes/01. Cargar la Base.R")
  source("0. Codigo/Codigo por Partes/02. Nombre del Archivo Base.R")
  source("0. Codigo/Codigo por Partes/03. Agregar y Eliminar la Base.R")
  source("0. Codigo/Codigo por Partes/04. Clasificacion Tipo de Servicio.R")
  source("0. Codigo/Codigo por Partes/05. Manejo Partícipes.R")
  source("0. Codigo/Codigo por Partes/06. Costos de transacción.R")
  source("0. Codigo/Codigo por Partes/07. Participación Producto.R")
  source("0. Codigo/Codigo por Partes/08. Generar la Base de Retardos.R")
  source("0. Codigo/Codigo por Partes/09. Generar la Base de Descuentos.R")
  source("0. Codigo/Codigo por Partes/10. Generar la Base de Color.R")
  source("0. Codigo/Codigo por Partes/11. Completar Base con Color.R")
  source("0. Codigo/Codigo por Partes/12. Completar Base de Retardos.R")
  source("0. Codigo/Codigo por Partes/13. Completar Descuentos Fondo.R")
  source("0. Codigo/Codigo por Partes/14. Porcentaje de los Profesionales.R")
  source("0. Codigo/Codigo por Partes/15. Participación Salón.R")
  source("0. Codigo/Codigo por Partes/16. Descuento Ajuste Producto.R")
  source("0. Codigo/Codigo por Partes/17. Descuentos Varios a Profesionales.R")
  source("0. Codigo/Codigo por Partes/18. Ajuste Partícipes.R")
  source("0. Codigo/Codigo por Partes/19. Exportar Resultados.R")
  source("0. Codigo/Codigo por Partes/20. Reporte Final.R")
}, error = function(e) {
  cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
  stop(e)  # Detiene toda la ejecución
})
#===============================================================================
# Ruta principal
ruta_resultados <- "3. Resultados"

# Buscar todos los archivos llamados '0. Consolidado.xlsx' dentro de subcarpetas
archivos <- list.files(path = ruta_resultados, pattern = "0. Consolidado.xlsx$", recursive = TRUE, full.names = TRUE)

# Función para extraer fecha desde el nombre del directorio
extraer_fecha <- function(path) {
  # Buscar el nombre de la subcarpeta que contiene el rango de fechas
  carpeta <- str_extract(path, "(?<=/)[0-9]{2}\\. Resultados .* - [0-9]{4}(?=/|$)")
  
  # Extraer solo la primera fecha (formato: MES DD)
  fecha_txt <- str_extract(carpeta, "[A-Z]{3} [0-9]{1,2}") 
  anio <- str_extract(carpeta, "[0-9]{4}$")
  
  # Convertir a fecha
  fecha <- suppressWarnings(dmy(paste0(fecha_txt, " ", anio)))
  
  return(fecha)
}

# Leer todos los archivos y agregar fecha
consolidado <- purrr::map_dfr(archivos, function(archivo) {
  df <- read_excel(archivo)
  df$fecha <- extraer_fecha(archivo)
  return(df)
})

# Ordenar por la fecha extraída
consolidado <- consolidado %>% arrange(fecha)

# Eliminar la variable
consolidado <- consolidado %>% select(-fecha)

# Eliminar variables
rm(archivos, ruta_resultados, extraer_fecha)

#-------------------------------------------------------------------------------
# Llenar valores NA de "Fecha de Pago" con el último valor no NA anterior
consolidado <- consolidado %>%
  fill(`Fecha de Pago`, .direction = "down")
#-------------------------------------------------------------------------------
# Exportar resultados
ruta_consolidado <- "4. Consolidado General"

# Crear un nuevo workbook
wb <- createWorkbook()

# Agregar hoja
addWorksheet(wb, "Consolidado")

# Escribir los datos con títulos
writeData(wb, sheet = "Consolidado", x = consolidado, headerStyle = createStyle(textDecoration = "bold"))

# Ajustar el ancho de columnas automáticamente
setColWidths(wb, sheet = "Consolidado", cols = 1:ncol(consolidado), widths = "auto")

# Definir la ruta completa del archivo a guardar
ruta_archivo <- file.path(ruta_consolidado, "Consolidado.xlsx")

# Guardar el archivo (sobrescribe si ya existe)
saveWorkbook(wb, file = ruta_archivo, overwrite = TRUE)

# Eliminar variables
rm(ruta_archivo, ruta_consolidado, wb)