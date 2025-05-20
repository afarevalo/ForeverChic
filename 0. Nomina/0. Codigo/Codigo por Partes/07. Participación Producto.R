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
# }, error = function(e) {
#   cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
#   stop(e)  # Detiene toda la ejecución
# })
#===============================================================================
# Inicalización de la Variable % de Participación Producto
# Participación Producto <- Cuanto se gasta en cada servicio, APROX
Data$pct_prod <- NA
Producto_tocador <- 4081

# Condicional Para Agregar % de Participación Producto
Data$pct_prod <- ifelse(Data$Tipo == "Spa", 0.26,
                      ifelse(Data$Tipo == "Bac", 0.25,
                      ifelse(Data$Tipo == "Depilacion", 0.15, 
                      ifelse(Data$Tipo == "Maquillaje", 0,
                      ifelse(Data$Tipo == "Alianza", 0,
                      ifelse(Data$Tipo == "Tocador" & Data$Precio > 0, 
                      Producto_tocador/Data$Precio,
                      ifelse(Data$Tipo == "Tocador" & Data$Precio == 0,
                      Producto_tocador/Data$`Precio de Lista`,
                      ifelse(Data$Tipo == "Venta", 0.56, 
                      ifelse(Data$Tipo == "Maquillaje_S", 0, 0)))))))))
#===============================================================================
# Inicalización de la Variable Valor Producto 
Data$val_prod <- NA

# Condicional
Data$val_prod <- ifelse(Data$Precio > 0, Data$pct_prod * Data$Precio, 
                 ifelse(Data$Precio == 0, Data$pct_prod * Data$`Precio de Lista`,
                        Data$val_prod))
