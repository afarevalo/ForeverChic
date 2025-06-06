#===============================================================================
# Limpiar el entorno
#rm(list = ls())
#===============================================================================
#source("0. Nomina/APP/1. Cargar la Base.R")
#source("0. Nomina/APP/2. Nombre del Archivo Base.R")
#source("0. Nomina/APP/3. Agregar y Eliminar la Base.R")
#source("0. Nomina/APP/4. Clasificacion Tipo de Servicio.R")
#source("0. Nomina/APP/5. Manejo Partícipes.R")
#source("0. Nomina/APP/6. Costos de transacción.R")
#source("0. Nomina/APP/7. Participación Producto.R")
#source("0. Nomina/APP/8. Generar la Base de Color.R")
#source("0. Nomina/APP/9. Completar Base con Color.R")
#source("0. Nomina/APP/10. Porcentaje de los Profesionales.R")
#source("0. Nomina/APP/11. Participación Salón.R")
#===============================================================================

# Ruta de la Base de Datos de Descuentos
archivo_descuento <- "2. Descuentos/Otros/0. Formato.xlsx"
ruta_descuento <- "2. Descuentos/Otros"

# Obtén la lista de archivos en el directorio actual o especificado
archivos_descuento <- list.files(ruta_descuento)

# Ordenar los archivos según los números
ultimo_descuento <- archivos_descuento[length(archivos_descuento)]

# Lógica condicional según el valor de Cambio
if (Cambio == 1) {
  # Si Cambio es 1, usar el último archivo como archivo destino
  archivo_destino <- file.path(ruta_descuento, ultimo_descuento)
  
  # Convertir la ruta relativa a ruta absoluta
  archivo_destino_absoluto <- normalizePath(archivo_destino, winslash = "/", mustWork = TRUE)
  
  # Abrir el archivo copiado con el programa predeterminado del sistema
  #shell.exec(archivo_destino_absoluto)
  
} else {
  # Si Cambio es 0, generar el nombre del nuevo archivo
  # Genera el nombre de la Base de Datos para Descuentos
  cadena_descuentos <- paste0(". descuentos ", MES1, " ", MIN, " al ", MES2, " ", MAX)
  numero_formateado <- sprintf("%02d", numero_extraido)
  nuevo_descuento <- paste0(numero_formateado, cadena_descuentos, ".xlsx")
  
  # Ruta completa del archivo destino
  archivo_destino <- file.path(ruta_descuento, nuevo_descuento)
  
  # Copiar el archivo a la nueva ubicación con el nuevo nombre
  file.copy(from = archivo_descuento, to = archivo_destino, overwrite = TRUE)
  
  # Convertir la ruta relativa a ruta absoluta
  archivo_destino_absoluto <- normalizePath(archivo_destino, winslash = "/", mustWork = TRUE)
  
  # Abrir el archivo copiado con el programa predeterminado del sistema
  shell.exec(archivo_destino_absoluto)
  
  }
