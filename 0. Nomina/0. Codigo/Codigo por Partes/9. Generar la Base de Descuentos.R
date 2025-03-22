#===============================================================================
# Limpiar el entorno
# rm(list = ls())
cat("\014")
#===============================================================================
# tryCatch({
#   source("0. Codigo/Codigo por Partes/1. Cargar la Base.R")
#   source("0. Codigo/Codigo por Partes/2. Nombre del Archivo Base.R")
#   source("0. Codigo/Codigo por Partes/3. Agregar y Eliminar la Base.R")
#   source("0. Codigo/Codigo por Partes/4. Clasificacion Tipo de Servicio.R")
#   source("0. Codigo/Codigo por Partes/5. Manejo Partícipes.R")
#   source("0. Codigo/Codigo por Partes/6. Costos de transacción.R")
#   source("0. Codigo/Codigo por Partes/7. Participación Producto.R")
# }, error = function(e) {
#   cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
#   stop(e)  # Detiene toda la ejecución
# })
#===============================================================================

# Ruta de la Base de Datos de Descuentos
ruta_fondo_formato <- "2. Descuentos - Fondo y Anticipos"
archivo_descuento <- file.path(ruta_fondo_formato, "0. Formato - Fondo y Otros.xlsx")

# Lógica condicional según el valor de Cambio
if (Cambio == 1) {
  
  ## ERORRRR si es 1, pues no se encuentra el ultimo archivo HP!!!
  # Ruta del archivo color
  archivos_descuentos <- list.files(ruta_color)
  ultimo_descuento <- archivos_descuentos[length(archivos_descuentos)]
  
  # Si Cambio es 1, usar el último archivo como archivo destino
  archivo_destino <- file.path(ruta_fondo, ultimo_descuento)
  
  # Convertir la ruta relativa a ruta absoluta
  archivo_destino_absoluto <- normalizePath(archivo_destino, winslash = "/", mustWork = TRUE)
  
  # Abrir el archivo copiado con el programa predeterminado del sistema
  #shell.exec(archivo_destino_absoluto)
  
} else {
  # Si Cambio es 0, generar el nombre del nuevo archivo
  # Genera el nombre de la Base de Datos para Descuentos
  cadena_descuentos <- paste0(". Descuentos ", MES1, " ", MIN, " al ", MES2, " ", MAX, " - ", ANIO)
  nuevo_descuento <- paste0(numero_extraido, cadena_descuentos, ".xlsx")
  
  # Ruta completa del archivo destino
  archivo_destino <- file.path(ruta_fondo, nuevo_descuento)
  
  # Copiar el archivo a la nueva ubicación con el nuevo nombre
  file.copy(from = archivo_descuento, to = archivo_destino, overwrite = TRUE)
  
  # Convertir la ruta relativa a ruta absoluta
  archivo_destino_absoluto <- normalizePath(archivo_destino, winslash = "/", mustWork = TRUE)
  
  # Abrir el archivo copiado con el programa predeterminado del sistema
  shell.exec(archivo_destino_absoluto)
  
}
