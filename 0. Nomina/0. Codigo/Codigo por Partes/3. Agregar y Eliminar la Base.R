#===============================================================================
# Limpiar el entorno
# rm(list = ls())
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

# Concicional con "O" y Data NA <- if (!exists("Data") || is.null(Data) || nrow(Data) == 0)
if (Cambio == 1) {
  
  # Si "Data" no existe, está vacío o es nulo, cargar los datos
  archivos_ventas <- list.files(ruta_data)
  
  # Ordenar los archivos según los números
  ultima_data <- archivos_ventas[length(archivos_ventas)]

  # Cargar la Data  
  Data <- read_excel(file.path(ruta_data, ultima_data))
  
  # Eliminar Variables
  rm(ultima_data, archivos_ventas)
  
} else {
    
      # Si "Data" existe y no está vacío, guardar los datos en un nuevo archivo
      # Exporta la  Base de Datos
      write_xlsx(Data, file.path(ruta_data, nuevo_nombre))
      
      # Elimina la Base de Datos Original
      #file.remove(ruta_archivo)
      rm(nuevo_nombre)

      }

# Elimina variables
rm(ruta_data)
