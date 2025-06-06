#===============================================================================
# Limpiar el entorno
# rm(list = ls())
cat("\014")
#===============================================================================
# tryCatch({
#  source("0. Codigo/Codigo por Partes/01. Cargar la Base.R")
# }, error = function(e) {
#  cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
#  stop(e)  # Detiene toda la ejecución
# })
#===============================================================================

if (Cambio == 1) {
  
  # Obtén la lista de archivos en el directorio actual o especificado
  ruta_data <- "1. Ventas Mensuales"
  ruta_color <- "2. Descuentos - Color"
  ruta_fondo <- "2. Descuentos - Fondo y Anticipos"
  ruta_retardos <- "2. Descuentos - Retardos"
  ruta_resultados <- "3. Resultados"
  
  # Obtener la lista de carpetas dentro de la ruta base
  carpetas_ventas <- list.dirs(path = ruta_data, full.names = TRUE, recursive = FALSE)
  
  # Seleccionar la última carpeta (suponiendo que están ordenadas correctamente por defecto)
  ultima_carpeta <- tail(carpetas_ventas, 1)
  
  # Obtener los archivos dentro de la última carpeta
  ultimo_archivo <- list.files(path = ultima_carpeta, full.names = FALSE)
  ultimo_archivo <- tail(ultimo_archivo, 1)
  
  # Eliminar la extensión del archivo
  archivo_sin_ext <- sub("\\.xlsx$", "", ultimo_archivo)
  
  # Extraer cada componente usando expresiones regulares
  numero_extraido <- regmatches(archivo_sin_ext, regexpr("^\\d{2}", archivo_sin_ext))  # 2 primeros dígitos
  MES1 <- regmatches(archivo_sin_ext, regexpr("[A-Z]{3}", archivo_sin_ext))  # Primer mes (ENE)
  MIN <- regmatches(archivo_sin_ext, regexpr("\\d{2}(?= al)", archivo_sin_ext, perl=TRUE))  # Primer día (16)
  MES2 <- regmatches(archivo_sin_ext, regexpr("(?<= al )[A-Z]{3}", archivo_sin_ext, perl=TRUE))  # Segundo mes (FEB)
  MAX <- regmatches(archivo_sin_ext, regexpr("\\d{2}(?= -)", archivo_sin_ext, perl=TRUE))  # Segundo día (31)
  ANIO <- regmatches(archivo_sin_ext, regexpr("\\d{4}$", archivo_sin_ext))  # Últimos 4 dígitos (Año 2020)

  # Definir las nuevas rutas de los archivo
  ruta_data <- file.path(ruta_data, ANIO)
  ruta_color <- file.path(ruta_color, ANIO)
  ruta_fondo <- file.path(ruta_fondo, ANIO)
  ruta_retardos <- file.path(ruta_retardos, ANIO)
  ruta_resultados <- file.path(ruta_resultados, ANIO)

  rm(archivo_sin_ext, carpetas_ventas, ultima_carpeta)
}

#===============================================================================

if (Cambio == 0) {
  
  # Encuentra la fecha mínima y máxima de la columna "Fecha de Pago"
  min_fecha <- min(Data$`Fecha de Pago`)
  max_fecha <- max(Data$`Fecha de Pago`)
  
  # Extrae el mes y el día de la fecha mínima y máxima
  MES1 <- format(min_fecha, "%m")  # Mes de la fecha mínima
  MIN <- format(min_fecha, "%d")   # Día de la fecha mínima
  MES2 <- format(max_fecha, "%m")  # Mes de la fecha máxima
  MAX <- format(max_fecha, "%d")   # Día de la fecha máxima
  ANIO <- format(max_fecha, "%Y")  # Año de la fecha máxima
  
  rm(min_fecha, max_fecha)
  
  # Vector con las abreviaturas de los meses
  abreviaturas_meses <- c("ENE", "FEB", "MAR", "ABR", "MAY", "JUN", 
                          "JUL", "AGO", "SEP", "OCT", "NOV", "DIC")
  
  # Convierte MES1 y MES2 de números a abreviaturas
  MES1 <- abreviaturas_meses[as.numeric(MES1)]
  MES2 <- abreviaturas_meses[as.numeric(MES2)]
  rm(abreviaturas_meses)
  
  # Crea la cadena de texto
  cadena_reporte <- paste0(". Reporte de Ventas ", MES1, " ",  MIN, " al ", MES2
                           , " ", MAX, " - ", ANIO, ".xlsx")
  
  #===============================================================================
  
  # Obtén la lista de archivos en el directorio actual o especificado
  ruta_data <- "1. Ventas Mensuales"
  ruta_color <- "2. Descuentos - Color"
  ruta_fondo <- "2. Descuentos - Fondo y Anticipos"
  ruta_retardos <- "2. Descuentos - Retardos"
  ruta_resultados <- "3. Resultados"
  ruta_consolidado <- "4. Consolidado General"
  
  #===============================================================================
  # Crear Carpeta por Año, Si es necesario
  #===============================================================================

  # Listar las carpetas dentro de la ruta principal
  if (!dir.exists(file.path(ruta_data, ANIO))) {
    
    # Crear las carpetas
    dir.create(file.path(ruta_data, ANIO))
    dir.create(file.path(ruta_color, ANIO))
    dir.create(file.path(ruta_fondo, ANIO))
    dir.create(file.path(ruta_resultados, ANIO))
    dir.create(file.path(ruta_retardos, ANIO))
    dir.create(file.path(ruta_consolidado, ANIO))
      
    } 
  
  # Definir las nuevas rutas de los archivo
  ruta_data <- file.path(ruta_data, ANIO)
  ruta_color <- file.path(ruta_color, ANIO)
  ruta_fondo <- file.path(ruta_fondo, ANIO)
  ruta_retardos <- file.path(ruta_retardos, ANIO)
  ruta_resultados <- file.path(ruta_resultados, ANIO)
  ruta_consolidado <- file.path(ruta_consolidado, ANIO)
  
  rm(ruta_consolidado)
  
  #===============================================================================

  # Obtener la lista de archivos en el directorio
  archivos_ventas <- list.files(ruta_data, full.names = FALSE)
  
  if (length(archivos_ventas) == 0) {
    
    numero_extraido <- "01"
    nuevo_nombre <- paste0(numero_extraido, cadena_reporte)
    rm(cadena_reporte, archivos_ventas)
    
    } else {
      
            # Extraer números al inicio del nombre del archivo y filtrar los valores no numéricos
            numeros <- as.numeric(gsub("^([0-9]+)\\..*", "\\1", archivos_ventas))
            validos <- !is.na(numeros)
            
            # Seleccionar el archivo con el número más alto
            if (any(validos)) {
              ultimo_archivo <- archivos_ventas[which.max(numeros)]
              numero_extraido <- max(numeros, na.rm = TRUE)
            }
          
            # Extraer la parte del texto después del primer punto "."
            texto_extraido <- sub("^[0-9]+(\\..*)", "\\1", ultimo_archivo)
            rm(archivos_ventas, numeros, validos)
            
            # Comparar la parte extraída con la cadena_reporte
            if (texto_extraido == cadena_reporte & Cambio == 0) {
              
              # Si son iguales, conservar el mismo archivo
              nuevo_nombre <- ultimo_archivo
              rm(cadena_reporte, texto_extraido)
              
            } else {
              
              # Si son diferentes, incrementar el número y generar un nuevo nombre
              numero_extraido <- numero_extraido + 1
              numero_extraido <- sprintf("%02d", numero_extraido)
              nuevo_nombre <- paste0(numero_extraido, cadena_reporte)
              rm(cadena_reporte, texto_extraido)
              
            }
          
          }  
  #===============================================================================
  
  # Arreglar el formato de la Fecha para extraer el MAX y MIN.
  Data$`Fecha de Pago` <- format(as.POSIXct(Data$`Fecha de Pago`, tz = "UTC"), 
                                 format = "%d/%m/%Y %H:%M")
  
}
