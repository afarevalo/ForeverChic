#===============================================================================
# Limpiar el entorno
#rm(list = ls())
#===============================================================================
#source("0. Nomina/Codigo por Partes/1. Cargar la Base.R")
#source("0. Nomina/Codigo por Partes/2. Nombre del Archivo Base.R")
#===============================================================================

# Librerias del Proyecto
library(readxl)
library(dplyr)
library(writexl)
library(rio)
library(openxlsx)
library(stringr)
library(lubridate)

# Obtén la lista de archivos en el directorio actual o especificado
ruta_data <- "1. Ventas Mensuales"

if (!exists("Data") || is.null(Data) || nrow(Data) == 0) {
  # Si "Data" no existe, está vacío o es nulo, cargar los datos
  archivos_descuento <- list.files(ruta_data)
  
  # Ordenar los archivos según los números
  ultima_data <- archivos_descuento[length(archivos_descuento)]

  # Cargar la Data  
  Data <- read_excel(file.path(ruta_data, ultima_data))
  
} else {
  # Si "Data" existe y no está vacío, guardar los datos en un nuevo archivo
  # Exporta la  Base de Datos
  write_xlsx(Data, file.path(ruta_data, nuevo_nombre))
  
  # Elimina la Base de Datos Original
  #file.remove(ruta_archivo)
}
