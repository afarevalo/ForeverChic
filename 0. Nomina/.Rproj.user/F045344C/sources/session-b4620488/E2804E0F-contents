cat("\014")
#===============================================================================
# Limpiar el entorno
#rm(list = ls())
#===============================================================================
#source("0. Codigo/Codigo por Partes/1. Cargar la Base.R")
#source("0. Codigo/Codigo por Partes/2. Nombre del Archivo Base.R")
#source("0. Codigo/Codigo por Partes/3. Agregar y Eliminar la Base.R")
#source("0. Codigo/Codigo por Partes/4. Clasificacion Tipo de Servicio.R")
#source("0. Codigo/Codigo por Partes/5. Manejo Partícipes.R")
#source("0. Codigo/Codigo por Partes/6. Generar la Base de Color.R")
#source("0. Codigo/Codigo por Partes/7. Generar la Base de Descuentos.R")
#source("0. Codigo/Codigo por Partes/8. Costos de transacción.R")
#source("0. Codigo/Codigo por Partes/9. Participación Producto.R")
#source("0. Codigo/Codigo por Partes/10. Completar Base con Color.R")
#===============================================================================

# Inicalización de la Variable Valor Neto
Data$val_neto <- 0

# Condicional para Calcular la variable val_neto con las condiciones requeridas
Data$val_neto <- ifelse(Data$Tipo == "Propina", Data$Precio - Data$costo_tx,
                 ifelse(Data$Precio > 0, Data$Precio - Data$val_prod - Data$costo_tx,
                 ifelse(Data$Precio == 0, 0, Data$Precio)))

#===============================================================================

# Inicalización de la Variable Participación Profesional
Data$Part_profesional <- NA

# Inicalización Porcentajes de Profesionales
Parte_Alianza <- 0.8
Parte_Spa <- 0.45
Parte_Bac <- 0.4
Parte_Tocador <- 0.55
Parte_Depilacion <- 0.6
Parte_Venta <- 0.08
Parte_Color <- 0.55
Parte_Maquillaje_Lina <- 0.58
Parte_Maquillaje_S <- 0.58
Parte_Alianza_Producto <- 0.90
Parte_Venta_N <- 0.9
Parte_TermoCut <- 0.45
Parte_Masaje<- 0.55

# Condicional
# Crear la variable Part_profesional en Data con los valores requeridos
Data$Part_profesional <- ifelse(Data$`Nombre cliente` %in% Base_Profesionales & Data$Total < 10, 0, 
                         ifelse(Data$Tipo == "Alianza" & Data$Precio > 0, Data$val_neto *  Parte_Alianza, 
                         ifelse(Data$Tipo == "Spa" & Data$Precio > 0, Data$Precio * Parte_Spa, 
                         ifelse(Data$Tipo == "Bac" & Data$Precio > 0, Data$Precio * Parte_Bac, 
                         ifelse(Data$Tipo == "Tocador" & Data$Precio > 0, Data$Precio * Parte_Tocador,
                         ifelse(Data$Tipo == "Depilacion" & Data$Precio > 0, Data$val_neto * Parte_Depilacion,
                         ifelse(Data$Tipo == "Venta" & Data$Precio > 0, Data$Precio * Parte_Venta, 
                         ifelse(Data$Tipo == "Propina" & Data$Precio > 0, Data$val_neto, 
                         ifelse(Data$Tipo == "Colorimetria" & Data$Precio > 0, 
                                Data$Precio * Parte_Color - Data$val_prod, 
                         ifelse(Data$Tipo == "Maquillaje_S" & Data$Precio > 0, 
                                Data$Precio * Parte_Maquillaje_S - Data$val_prod, 
                         ifelse(Data$Tipo == "Maquillaje" & Data$Precio > 0, Data$val_neto * Parte_Maquillaje_Lina, 
                         ifelse(Data$Tipo == "Accesorios" & Data$Precio > 0, Data$val_neto,
                         ifelse(Data$Tipo == "Queratina" & Data$Precio > 0,  Data$Precio * Parte_Tocador - Data$val_prod, 
                         ifelse(Data$Tipo == "Venta_N" & Data$Precio > 0, Data$val_neto *  Parte_Venta_N,
                         ifelse(Data$Tipo == "TermoCut" & Data$Precio > 0, Data$Precio * Parte_TermoCut, 
                         ifelse(Data$Tipo == "Masaje" & Data$Precio > 0, Data$Precio * Parte_Masaje, 
                                0))))))))))))))))

#===============================================================================

# Apoyo de Marinela en las Queratinas 
if (any(Data$Ayuda == 1)) {
  # Identificar las filas donde Ayuda == 1
  filas_a_duplicar <- which(Data$Ayuda == 1)
  
  # Crear las nuevas filas basadas en las filas identificadas
  nuevas_filas <- Data[filas_a_duplicar, ] # Duplicar las filas originales
  nuevas_filas$`Servicio/Producto` <- paste("Apoyo Queratina a", nuevas_filas$`Prestador/Vendedor`) # Descripción
  nuevas_filas$`Prestador/Vendedor` <- "Marinela Olaya" # Cambiar el prestador/vendedor
  nuevas_filas$Modificado <- 1
  nuevas_filas$Part_profesional <- 20000 # Asignar el nuevo valor a Part_profesional
  
  # Actualizar las filas originales en Data
  Data$Part_profesional[filas_a_duplicar] <- 
    (Data$Precio[filas_a_duplicar] * Parte_Tocador) - Data$val_prod[filas_a_duplicar] - 20000
  
  # Agregar las nuevas filas a Data
  Data <- rbind(Data, nuevas_filas)
  rm(nuevas_filas)
}

#===============================================================================

# Condicional para revisar errores
Data$Part_profesional <- ifelse(is.na(Data$Tipo), NA, Data$Part_profesional)
Data$Tipo <- ifelse(is.na(Data$Tipo), "Revisar", Data$Tipo)
