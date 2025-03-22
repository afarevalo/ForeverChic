#===============================================================================
# Limpiar el entorno
rm(list = ls())
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
ruta_retardos_formato <- "2. Descuentos - Retardos"
formato_retardo <- file.path(ruta_retardos_formato, "0. Formato - Retardos.xlsx")
rm(ruta_retardos_formato)

# Lógica condicional según el valor de Cambio
if (Cambio == 1) {
  
  # Obtén la lista de archivos en el directorio actual o especificado
  archivos_retardo <- list.files(ruta_retardos)
  
  # Ordenar los archivos según los números
  ultimo_descuento <- archivos_retardo[length(archivos_retardo)]
  
  # Si Cambio es 1, usar el último archivo como archivo destino
  archivo_destino <- file.path(ruta_descuento, ultimo_descuento)
  
  # Convertir la ruta relativa a ruta absoluta
  archivo_destino_absoluto <- normalizePath(archivo_destino, winslash = "/", mustWork = TRUE)
  
  # Abrir el archivo copiado con el programa predeterminado del sistema
  #shell.exec(archivo_destino_absoluto)
  
} else {
     
        # Si Cambio es 0, generar el nombre del nuevo archivo
        # Genera el nombre de la Base de Datos para Descuentos
        cadena_retardos <- paste0(". Retardos ", MES1, " ", MIN, " al ", MES2, " ", MAX, " - ", ANIO)
        nuevo_retardo <- paste0(numero_extraido, cadena_retardos, ".xlsx")
        rm(cadena_retardos)
        
        # Ruta completa del archivo destino
        archivo_retardo <- file.path(ruta_retardos, nuevo_retardo)
        
        # Copiar el archivo a la nueva ubicación con el nuevo nombre
        file.copy(from = formato_retardo, to = archivo_retardo, overwrite = TRUE)

        # Convertir la ruta relativa a ruta absoluta
        archivo_destino_absoluto <- normalizePath(archivo_retardo, winslash = "/", mustWork = TRUE)
        
        # Abrir el archivo copiado con el programa predeterminado del sistema
        #shell.exec(archivo_destino_absoluto)
        
        rm(archivo_destino_absoluto, archivo_retardo, formato_retardo, nuevo_retardo)
  
       }
