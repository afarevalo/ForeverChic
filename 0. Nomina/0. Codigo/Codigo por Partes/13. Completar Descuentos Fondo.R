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
#   source("0. Codigo/Codigo por Partes/12. Completar Base de Retardos.R")
# }, error = function(e) {
#   cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
#   stop(e)  # Detiene toda la ejecución
# })
#===============================================================================
# Data Descuentos
Data_Ahorro <- read_excel(archivo_formato_descuento, sheet = "1. Ahorro")
Data_Almuerzo <- read_excel(archivo_formato_descuento, sheet = "2. Almuerzos")
#===============================================================================
# Limpieza de Data AHORRO
Data_Ahorro <- Data_Ahorro %>% select("Quincena...1", "Partícipes Fondo", "Valor")

# Filtrar las observaciones donde Valor no sea NA
Data_Ahorro <- Data_Ahorro %>% filter(!is.na(Valor))

# Cambiar el nombre de las variables
Data_Ahorro <- Data_Ahorro %>% rename(`Fecha de Pago` = `Quincena...1`)
Data_Ahorro <- Data_Ahorro %>% rename(`Prestador/Vendedor` = `Partícipes Fondo`)
Data_Ahorro <- Data_Ahorro %>% rename(Part_profesional = Valor)

# Formatear la columna 'Part_profesional'
options(scipen = 999, digits = 10)

#===============================================================================

# Crear un vector para mapear meses en español a números
meses_es <- c("ENE" = 1, "FEB" = 2, "MAR" = 3, "ABR" = 4, "MAY" = 5, "JUN" = 6, 
              "JUL" = 7, "AGO" = 8, "SEP" = 9, "OCT" = 10, "NOV" = 11, "DIC" = 12)

# Convertir los componentes de fecha a formato adecuado
Fecha_Min <- as.POSIXct(paste(ANIO, meses_es[MES1], MIN, sep = "-"), format = "%Y-%m-%d", tz = "UTC")
Fecha_Max <- as.POSIXct(paste(ANIO, meses_es[MES2], MAX, sep = "-"), format = "%Y-%m-%d", tz = "UTC")

# Filtrar los datos dentro del rango de fechas
Data_Ahorro <- Data_Ahorro %>% filter(`Fecha de Pago` >= Fecha_Min & `Fecha de Pago` <= Fecha_Max)

# Elinar variables
rm(meses_es)

# Part_profesional es negativo para descontar
Data_Ahorro$Part_profesional <- Data_Ahorro$Part_profesional * (-1)

# Clasificación para Tipo de Variable y concepto de descuento
Data_Ahorro$Tipo <- "Descuento"
Data_Ahorro$`Servicio/Producto` <- "Fondo de Ahorro Quincenal"

# Cambio de formato para el unir las bases
Data_Ahorro$`Fecha de Pago` <- as.character(Data_Ahorro$`Fecha de Pago`)

if (nrow(Data_Ahorro) > 0){
  # Unir las bases de datos
  Data <- rbind(Data, Data_Ahorro)
}

# Eliminar variables
rm(Data_Ahorro)

#===============================================================================
# Limpieza de Data ALMUERZOS
Data_Almuerzo <- Data_Almuerzo %>% select("Dia...1", "Partícipes Fondo", "Valor...4")

# Cambiar el nombre de las variables
Data_Almuerzo <- Data_Almuerzo %>% rename(`Fecha de Pago` = `Dia...1`)
Data_Almuerzo <- Data_Almuerzo %>% rename(`Prestador/Vendedor` = `Partícipes Fondo`)
Data_Almuerzo <- Data_Almuerzo %>% rename(Part_profesional = Valor...4)

# Filtrar las observaciones donde Valor no sea NA
Data_Almuerzo <- Data_Almuerzo %>% filter(!is.na(Part_profesional))

# Filtrar los datos dentro del rango de fechas
Data_Almuerzo <- Data_Almuerzo %>% filter(`Fecha de Pago` >= Fecha_Min & `Fecha de Pago` <= Fecha_Max)

# Part_profesional es negativo para descontar
Data_Almuerzo$Part_profesional <- Data_Almuerzo$Part_profesional * (-1)

# Cambio de formato para el unir las bases
Data_Almuerzo$`Fecha de Pago` <- as.character(Data_Almuerzo$`Fecha de Pago`)

# Clasificación para Tipo de Variable y concepto de descuento
Data_Almuerzo$Tipo <- "Descuento"
Data_Almuerzo$`Servicio/Producto` <- paste("Almuerzo del día", Data_Almuerzo$`Fecha de Pago`)
Data_Almuerzo$`Fecha de Pago` <- NA


if (nrow(Data_Almuerzo) > 0){
  # Unir las bases de datos
  Data <- rbind(Data, Data_Almuerzo)
}

# Eliminar variables
rm(Data_Almuerzo, archivo_formato_descuento, Fecha_Max, Fecha_Min, ruta_fondo)
