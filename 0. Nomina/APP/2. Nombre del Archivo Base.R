#===============================================================================
#source("0. Nomina/APP/1. Cargar la Base.R")
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
cadena_reporte <- paste0(". reporte de ventas ", MES1, " ",  MIN, " al ", MES2, " ", MAX)

#===============================================================================

# El directorio donde estan los archivos de Ventas
directorio <- "1. Ventas Mensuales"

# Obtén la lista de archivos en el directorio actual o especificado
archivos <- list.files(directorio)

# Extrae el nombre del último archivo en la lista
ultimo_archivo <- tail(archivos, n = 1)

# Extrae el número al inicio de la cadena antes del primer "."
numero_extraido <- as.numeric(sub("^([0-9]+)\\..*", "\\1", ultimo_archivo))
numero_extraido <- numero_extraido + 1

nuevo_nombre <- paste0(numero_extraido, cadena_reporte,".xlsx")
