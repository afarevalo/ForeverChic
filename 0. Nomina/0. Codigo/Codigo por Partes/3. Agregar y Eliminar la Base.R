#===============================================================================
# Limpiar el entorno
#rm(list = ls())
cat("\014")
#===============================================================================
# tryCatch({
#   source("0. Codigo/Codigo por Partes/1. Cargar la Base.R")
#   source("0. Codigo/Codigo por Partes/2. Nombre del Archivo Base.R")
# }, error = function(e) {
#   cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
#   stop(e)  # Detiene toda la ejecución
# })
#===============================================================================

# Obtén la lista de archivos en el directorio actual o especificado
ruta_data <- "1. Ventas Mensuales"

if (!exists("Data") || is.null(Data) || nrow(Data) == 0) {
  
  # Si "Data" no existe, está vacío o es nulo, cargar los datos
  archivos_ventas <- list.files(ruta_data)
  
  # Ordenar los archivos según los números
  ultima_data <- archivos_ventas[length(archivos_ventas)]

  # Cargar la Data  
  Data <- read_excel(file.path(ruta_data, ultima_data))
  
  # Extrae el ultimo nombre de la lista de archivos
  nuevo_nombre <- tail(archivos_ventas, n = 1)
  
  # Extraer el número al inicio de la cadena antes del primer "."
  numero_extraido <- as.numeric(sub("^([0-9]+)\\..*", "\\1", nuevo_nombre))
  numero_extraido <- sprintf("%02d", numero_extraido)
  
  # La Data es vieja
  Cambio <- 1
  
  # Eliminar Variables
  rm(ultima_data, archivos_ventas)
  
} else {
  # Si "Data" existe y no está vacío, guardar los datos en un nuevo archivo
  # Exporta la  Base de Datos
  write_xlsx(Data, file.path(ruta_data, nuevo_nombre))
  
  # Elimina la Base de Datos Original
  file.remove(ruta_archivo)
}

# Elimina variables
rm(ruta_archivo, ruta_data)
