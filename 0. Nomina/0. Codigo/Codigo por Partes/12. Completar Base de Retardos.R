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
#   source("0. Codigo/Codigo por Partes/09. Generar la Base de Descuentos.R")
#   source("0. Codigo/Codigo por Partes/10. Generar la Base de Color.R")
#   source("0. Codigo/Codigo por Partes/11. Completar Base con Color.R")
# }, error = function(e) {
#   cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
#   stop(e)  # Detiene toda la ejecución
# })
#===============================================================================
# Inicializar la variable ´Part_profesional´
Data$Part_profesional <- NA
#===============================================================================
# Si MES1 == MES2, se deben mirar solo de una base de datos.
if(MES1 == MES2){

  # Importacion de los Datos
  Data_Retardos <- read_excel(archivo_mes1)
  
  # Convierte los caracteres a num
  MIN_NUM <- as.numeric(MIN)
  MAX_NUM <- as.numeric(MAX)
  
  # Define el valor de la multa
  Multa <- -1000
  
  # Convertir el rango de días en nombres de columnas
  dias_rango <- as.character(MIN_NUM:MAX_NUM)
  
  # Calcular la suma de llegadas tarde en el rango de días para cada empleado
  Data_Retardos$Total_Rango <- rowSums(Data_Retardos[, dias_rango], na.rm = TRUE)
  
  # Transformar la base de datos
  Data_Procesada <- Data_Retardos %>%
    rowwise() %>% # Procesa cada fila individualmente
    mutate(
      `Prestador/Vendedor` = Profesional, 
      `Servicio/Producto` = ifelse(
        all(is.na(c_across(all_of(dias_rango)))), 
        paste("No llegaste tarde en el mes de", MES1), 
        paste("Llegaste tarde los días:", 
              paste(which(!is.na(c_across(all_of(dias_rango)))) + MIN_NUM - 1, collapse = ","),
              "del mes de", MES1)
      ),
      `Part_profesional` = Total_Rango * Multa
    ) %>%
    ungroup() %>% # Salir del modo rowwise()
    select(`Prestador/Vendedor`, `Servicio/Producto`, `Part_profesional`) # Seleccionar solo las columnas requeridas
  
  # Filtrar las observaciones donde Part_profesional no sea 0
  Data_Procesada <- Data_Procesada %>% filter(Part_profesional != 0)
  
  # Elimina variables
  rm(MAX_NUM, MIN_NUM, archivo_mes1, archivo_mes2, dias_rango, Multa)
  rm(Data_Retardos)
}

#===============================================================================
# Si MES1 != MES2, se deben mirar más de una base de datos.
if(MES1 != MES2){
  
  # Importacion de los Datos
  Data_Retardos <- read_excel(archivo_mes1)
  
  # Convierte los caracteres a num
  MIN_NUM <- as.numeric(MIN)
  MAX_NUM <- as.numeric(31)
  
  # Define el valor de la multa
  Multa <- -1000
  
  # Convertir el rango de días en nombres de columnas
  dias_rango <- as.character(MIN_NUM:MAX_NUM)
  
  # Calcular la suma de llegadas tarde en el rango de días para cada empleado
  Data_Retardos$Total_Rango <- rowSums(Data_Retardos[, dias_rango], na.rm = TRUE)
  
  # Transformar la base de datos
  Data_Procesada <- Data_Retardos %>%
    rowwise() %>% # Procesa cada fila individualmente
    mutate(
      `Prestador/Vendedor` = Profesional, 
      `Servicio/Producto` = ifelse(
        all(is.na(c_across(all_of(dias_rango)))), 
        paste("No llegaste tarde en el mes de", MES1), 
        paste("Llegaste tarde los días:", 
              paste(which(!is.na(c_across(all_of(dias_rango)))) + MIN_NUM - 1, collapse = ","),
              "del mes de", MES1)
      ),
      `Part_profesional` = Total_Rango * Multa
    ) %>%
    ungroup() %>% # Salir del modo rowwise()
    select(`Prestador/Vendedor`, `Servicio/Producto`, `Part_profesional`) # Seleccionar solo las columnas requeridas
  
  #=============================================================================
  
  # Importacion de los Datos
  Data_Retardos <- read_excel(archivo_mes2)
  
  # Convierte los caracteres a num
  MIN_NUM <- as.numeric(1)
  MAX_NUM <- as.numeric(MAX)
  
  # Define el valor de la multa
  Multa <- -1000
  
  # Convertir el rango de días en nombres de columnas
  dias_rango <- as.character(MIN_NUM:MAX_NUM)
  
  # Calcular la suma de llegadas tarde en el rango de días para cada empleado
  Data_Retardos$Total_Rango <- rowSums(Data_Retardos[, dias_rango], na.rm = TRUE)
  
  # Transformar la base de datos
  Data_Procesada_2 <- Data_Retardos %>%
    rowwise() %>% # Procesa cada fila individualmente
    mutate(
      `Prestador/Vendedor` = Profesional, 
      `Servicio/Producto` = ifelse(
        all(is.na(c_across(all_of(dias_rango)))), 
        paste("No llegaste tarde en el mes de", MES2), 
        paste("Llegaste tarde los días:", 
              paste(which(!is.na(c_across(all_of(dias_rango)))) + MIN_NUM - 1, collapse = ","),
              "del mes de", MES2)
      ),
      `Part_profesional` = Total_Rango * Multa
    ) %>%
    ungroup() %>% # Salir del modo rowwise()
    select(`Prestador/Vendedor`, `Servicio/Producto`, `Part_profesional`) # Seleccionar solo las columnas requeridas
  
  # Codigo para unir las 2 bases de datos
  Data_Procesada <- rbind(Data_Procesada, Data_Procesada_2)
  rm(Data_Procesada_2)
  
  # Filtrar las observaciones donde Part_profesional no sea 0
  Data_Procesada <- Data_Procesada %>% filter(Part_profesional != 0)
  
  # Elimina variables
  rm(MAX_NUM, MIN_NUM, archivo_mes1, archivo_mes2, dias_rango, Multa)
  rm(Data_Retardos)
}

#===============================================================================
# Unir Base de Retardos con Data
Data_Procesada$Tipo <- "Descuento"

if (nrow(Data_Procesada) > 0){
  # Unir las bases de datos
  Data <- rbind(Data, Data_Procesada)
}
#===============================================================================
# Eliminar Data Retardos
rm(Data_Procesada)