#===============================================================================
#source("0. Nomina/APP/1. Cargar la Base.R")
#source("0. Nomina/APP/2. Nombre del Archivo Base.R")
#source("0. Nomina/APP/3. Agregar y Eliminar la Base.R")
#===============================================================================

# Genera el nombre de la Base de Datos para Descuentos
cadena_descuentos <- paste0(". descuentos ", MES1, " ",  MIN, " al ", MES2, " ", MAX)
nuevo_descuento <- paste0(numero_extraido, cadena_descuentos,".xlsx")

# Ruta de la Base de Datos de Descuentos
archivo_descuento <- "2. Descuentos/Otros/0. Formato.xlsx"
ruta_descuento <- "2. Descuentos/Otros"

# Ruta completa del archivo destino
archivo_destino <- file.path(ruta_descuento, nuevo_descuento)

# Copiar el archivo a la nueva ubicación con el nuevo nombre
file.copy(from = archivo_descuento, to = archivo_destino, overwrite = TRUE)
