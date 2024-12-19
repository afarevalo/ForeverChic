#===============================================================================
# Limpiar el entorno
#rm(list = ls())
#===============================================================================
#source("0. Nomina/APP/1. Cargar la Base.R")
#source("0. Nomina/APP/2. Nombre del Archivo Base.R")
#source("0. Nomina/APP/3. Agregar y Eliminar la Base.R")
#source("0. Nomina/APP/4. Generar la Base de Descuentos.R")
#source("0. Nomina/APP/5. Clasificacion Tipo de Servicio.R")
#source("0. Nomina/APP/6. Generar la Base de Color.R")
#source("0. Nomina/APP/7. Manejo Partícipes.R")
#source("0. Nomina/APP/8. Costos de transacción.R")
#===============================================================================

# Inicalización de la Variable % de Participación Producto
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
                      ifelse(Data$Tipo == "Maquillaje_S", 0, NA)))))))))

#===============================================================================

# Inicalización de la Variable Valor Producto
Data$val_prod <- NA

# Condicional
Data$val_prod <- ifelse(Data$Precio > 0, Data$pct_prod * Data$Precio, 
                 ifelse(Data$Precio == 0, Data$pct_prod * Data$`Precio de Lista`,
                                     NA))

