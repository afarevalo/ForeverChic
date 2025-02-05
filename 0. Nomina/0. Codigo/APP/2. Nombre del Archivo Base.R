#===============================================================================
# Limpiar el entorno
#rm(list = ls())
#===============================================================================
#source("0. Nomina/APP/1. Cargar la Base.R")
#===============================================================================

procesar_fechas <- function(Data) {
  # Convierte la fecha de nuevo a POSIXct para los cálculos
  Data$`Fecha de Pago` <- as.POSIXct(Data$`Fecha de Pago`)
  
  # Encuentra la fecha mínima y máxima
  min_fecha <- min(Data$`Fecha de Pago`)
  max_fecha <- max(Data$`Fecha de Pago`)
  
  # Extrae el mes y el día
  MES1 <- format(min_fecha, "%m")
  MIN <- format(min_fecha, "%d")
  MES2 <- format(max_fecha, "%m")
  MAX <- format(max_fecha, "%d")
  
  # Vector con las abreviaturas de los meses
  abreviaturas_meses <- c("ENE", "FEB", "MAR", "ABR", "MAY", "JUN", 
                          "JUL", "AGO", "SEP", "OCT", "NOV", "DIC")
  
  # Convierte MES1 y MES2 de números a abreviaturas
  MES1 <- abreviaturas_meses[as.numeric(MES1)]
  MES2 <- abreviaturas_meses[as.numeric(MES2)]
  
  # Crea la cadena de texto
  cadena_reporte <- paste0(". reporte de ventas ", MES1, " ",  MIN, " al ", MES2, " ", MAX, ".xlsx")
  
  # El directorio donde están los archivos de Ventas
  directorio <- "1. Ventas Mensuales"
  
  # Asegúrate de que el directorio existe
  if (!dir.exists(directorio)) {
    dir.create(directorio, recursive = TRUE)
  }
  
  # Obtener la lista de archivos
  archivos <- list.files(directorio)
  
  if (length(archivos) > 0) {
    # Extraer los números y ordenar
    numeros <- as.numeric(sub("^(\\d+).*", "\\1", archivos))
    archivos_ordenados <- archivos[order(numeros)]
    ultimo_archivo <- tail(archivos_ordenados, n = 1)
    numero_extraido <- as.numeric(sub("^([0-9]+)\\..*", "\\1", ultimo_archivo))
    texto_extraido <- sub("^[0-9]+(\\..*)", "\\1", ultimo_archivo)
    
    # Determinar el nuevo nombre
    if (texto_extraido == cadena_reporte) {
      nuevo_nombre <- ultimo_archivo
      Cambio <- 1
    } else {
      numero_extraido <- numero_extraido + 1
      nuevo_nombre <- paste0(sprintf("%02d", numero_extraido), cadena_reporte)
      Cambio <- 0
    }
  } else {
    # Si no hay archivos, empezar con 01
    nuevo_nombre <- paste0("01", cadena_reporte)
    Cambio <- 0
  }
  
  # Formatear la fecha para el output
  Data$`Fecha de Pago` <- format(Data$`Fecha de Pago`, format = "%d/%m/%Y %H:%M")
  
  return(list(
    data = Data,
    nuevo_nombre = nuevo_nombre,
    cambio = Cambio
  ))
}