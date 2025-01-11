#===============================================================================
# Codigo para importar la Base de datos de las Ventas
#===============================================================================

# Librerias del Proyecto
library(readxl)
library(dplyr)
library(writexl)
library(rio)
library(openxlsx)
library(stringr)
library(lubridate)

#===============================================================================

# Input del Usuario
ruta_archivo <- "C:/Users/windows/Downloads/Dic 16 a 24.xlsx"
# Leer el archivo
Data <- read_excel(ruta_archivo, sheet = "Produccion v2")

# Soluciona el problema de las filas iniciales
colnames(Data) <- Data[1, ]
Data <- Data[-c(1:1),]
rownames(Data) <- NULL

# Limpiar datos
Data <- Data %>% select("Identificador","Fecha de Pago","Nombre cliente",
                           "Servicio/Producto","Prestador/Vendedor","Precio de Lista",
                           "Precio", "Total","Descuento","Efectivo","Tarjeta de Crédito",
                           "Tarjeta de Débito","Cheque","Otro","Gift card",
                           "Transferencia Bancaria","Nequi Carlos","Daviplata Carlos",
                           "Nequi Nambad","Daviplata Nambad","Bold")

# Eliminar espacios múltiples
Data$`Nombre cliente` <- gsub("\\s+", " ", Data$`Nombre cliente`)
Data$`Prestador/Vendedor` <- gsub("\\s+", " ", Data$`Prestador/Vendedor`)

# Eliminar espacios al inicio y al final, si los hubiera
Data$`Nombre cliente` <- trimws(Data$`Nombre cliente`)
Data$`Prestador/Vendedor` <- trimws(Data$`Prestador/Vendedor`)

#===============================================================================
# Condicional para corregir el error de AgendaPro con la gif card
Data$`Gift card` <- ifelse(Data$`Gift card` == 0, 1,Data$`Gift card`)
#===============================================================================
# Corrección del Tipo de Variable
#===============================================================================

# Vector con los nombres de las columnas que deseas convertir
columnas_a_convertir <- c( "Identificador", "Efectivo", "Total", "Otro", "Gift card", "Nequi Carlos", 
                           "Daviplata Carlos", "Nequi Nambad", "Daviplata Nambad",
                           "Tarjeta de Crédito", "Tarjeta de Débito", "Cheque",
                           "Transferencia Bancaria", "Bold", "Precio",
                           "Precio de Lista")

# Convertir las columnas seleccionadas a numéricas y reemplazar NA por 0
Data[columnas_a_convertir] <- lapply(Data[columnas_a_convertir], function(columna) {
  as.numeric(replace(columna, is.na(columna), 0))
})

# Convertir las columnas de chr a formato fecha para extraer el MAX y MIN.
Data$`Fecha de Pago` <- dmy_hm(Data$`Fecha de Pago`)
