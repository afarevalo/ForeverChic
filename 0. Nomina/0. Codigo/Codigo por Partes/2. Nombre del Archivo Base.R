cat("\014")
#===============================================================================
# Limpiar el entorno
#rm(list = ls())
#===============================================================================
#source("0. Codigo/Codigo por Partes/1. Cargar la Base.R")
#===============================================================================

# Encuentra la fecha mínima y máxima de la columna "Fecha de Pago"
min_fecha <- min(Data$`Fecha de Pago`)
max_fecha <- max(Data$`Fecha de Pago`)

# Extrae el mes y el día de la fecha mínima y máxima
MES1 <- format(min_fecha, "%m")  # Mes de la fecha mínima
MIN <- format(min_fecha, "%d")   # Día de la fecha mínima
MES2 <- format(max_fecha, "%m")  # Mes de la fecha máxima
MAX <- format(max_fecha, "%d")   # Día de la fecha máxima

# Vector con las abreviaturas de los meses
abreviaturas_meses <- c("ENE", "FEB", "MAR", "ABR", "MAY", "JUN", 
                        "JUL", "AGO", "SEP", "OCT", "NOV", "DIC")

# Convierte MES1 y MES2 de números a abreviaturas
MES1 <- abreviaturas_meses[as.numeric(MES1)]
MES2 <- abreviaturas_meses[as.numeric(MES2)]

# Crea la cadena de texto
cadena_reporte <- paste0(". reporte de ventas ", MES1, " ",  MIN, " al ", MES2, " ", MAX, ".xlsx")

#===============================================================================

# El directorio donde están los archivos de Ventas
directorio <- "1. Ventas Mensuales"

# Obtener la lista de archivos en el directorio actual o especificado
archivos <- list.files(directorio)

# Extraer los números al inicio de los nombres de los archivos
numeros <- as.numeric(sub("^(\\d+).*", "\\1", archivos))

# Ordenar los archivos según los números
archivos_ordenados <- archivos[order(numeros)]

# Extraer el último archivo (con el número más alto)
# Extraer el nombre del ultimo archivo
ultimo_archivo <- tail(archivos_ordenados, n = 1)

# Extraer el número al inicio de la cadena antes del primer "."
numero_extraido <- as.numeric(sub("^([0-9]+)\\..*", "\\1", ultimo_archivo))

# Extraer la parte del texto después del primer punto "."
texto_extraido <- sub("^[0-9]+(\\..*)", "\\1", ultimo_archivo)

# No cambio el Nombre
Cambio <- 0

# Comparar la parte extraída con la cadena_reporte
if (texto_extraido == cadena_reporte) {
  
  # Si son iguales, conservar el mismo archivo
  nuevo_nombre <- ultimo_archivo
  Cambio <- 1
  
} else {
  
  # Si son diferentes, incrementar el número y generar un nuevo nombre
  numero_extraido <- numero_extraido + 1
  numero_formateado <- sprintf("%02d", numero_extraido)
  nuevo_nombre <- paste0(numero_formateado, cadena_reporte)

}

#===============================================================================

# Arreglar el formato de la Fecha para extraer el MAX y MIN.
Data$`Fecha de Pago` <- format(as.POSIXct(Data$`Fecha de Pago`, tz = "UTC"), 
                               format = "%d/%m/%Y %H:%M")
