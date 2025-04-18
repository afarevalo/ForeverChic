#===============================================================================
# Limpiar el entorno
# rm(list = ls())
cat("\014")
#===============================================================================
# tryCatch({
#   source("0. Codigo/Codigo por Partes/01. Cargar la Base.R")
#   source("0. Codigo/Codigo por Partes/02. Nombre del Archivo Base.R")
#   source("0. Codigo/Codigo por Partes/03. Agregar y Eliminar la Base.R")
#   source("0. Codigo/Codigo por Partes/04. Clasificacion Tipo de Servicio.R")
#   source("0. Codigo/Codigo por Partes/05. Manejo Partícipes.R")
#   source("0. Codigo/Codigo por Partes/06. Costos de transacción.R")
#   source("0. Codigo/Codigo por Partes/07. Participación Producto.R")
#   source("0. Codigo/Codigo por Partes/08. Generar la Base de Retardos.R")
# }, error = function(e) {
#   cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
#   stop(e)  # Detiene toda la ejecución
# })
#===============================================================================
# Ruta de la Base de Datos de Descuentos
ruta_fondo_formato <- "2. Descuentos - Fondo y Anticipos"
archivo_descuento <- file.path(ruta_fondo_formato, "0. Formato - Otros.xlsx")

# Genera el nombre de la Base de Datos para Descuentos
cadena_descuentos <- paste0(". Descuentos ", MES1, " ", MIN, " al ", MES2, " ", MAX, " - ", ANIO)
nuevo_descuento <- paste0(numero_extraido, cadena_descuentos, ".xlsx")

# Ruta completa del archivo destino
archivo_descuentos <- file.path(ruta_fondo, nuevo_descuento)

# Verificar si existen los archivos
existe_descuento <- file_exists(archivo_descuentos)

# Lógica condicional según el valor de Cambio
if (existe_descuento) {
  
  # Convertir la ruta relativa a ruta absoluta
  # archivo_destino_absoluto <- normalizePath(archivo_descuentos, winslash = "/", mustWork = TRUE)
  
  # Abrir el archivo copiado con el programa predeterminado del sistema
  # shell.exec(archivo_destino_absoluto)
  
  # Elinimar variables
  rm(existe_descuento, archivo_descuento, cadena_descuentos, nuevo_descuento)
  
} else {
  # Si Cambio es 0, generar el nombre del nuevo archivo
  # Copiar el archivo a la nueva ubicación con el nuevo nombre
  file.copy(from = archivo_descuento, to = archivo_descuentos, overwrite = TRUE)
  
  # Convertir la ruta relativa a ruta absoluta
  # archivo_destino_absoluto <- normalizePath(archivo_descuentos, winslash = "/", mustWork = TRUE)
  
  # Abrir el archivo copiado con el programa predeterminado del sistema
  #shell.exec(archivo_destino_absoluto)
  #rm(archivo_destino)

  #Borrar variables
  rm(cadena_descuentos, archivo_descuento, nuevo_descuento)
}

#===============================================================================
# Arhivo de fondo
formato_descuento <- file.path(ruta_fondo_formato, "0. Formato - Fondo.xlsx")

# Nombre del archivo
archivo_formato_descuento <- file.path(ruta_fondo, sprintf("%s. Formato - Fondo %s.xlsx", "00", ANIO))

# Existe el archivo?
existe_descuento <- file_exists(archivo_formato_descuento)

# Copiar el archivo si es necesario
if (!existe_descuento) {
  file_copy(formato_descuento, archivo_formato_descuento)
}

# Eliminar variables
rm(formato_descuento, existe_descuento, ruta_fondo_formato)