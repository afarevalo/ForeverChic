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
#source("0. Nomina/APP/9. Participación Producto.R")
#source("0. Nomina/APP/10. Completar Base con Color.R")
#source("0. Nomina/APP/11. Porcentaje de los Profesionales.R")
#===============================================================================

# Inicalización de la Variable Participación Salón
Data$Part_salon <- NA

# Convertir los valores no numéricos en NA y sumar solo los valores numéricos
Data$Part_salon <- ifelse(Data$Precio > 0,
                          Data$Precio - 
                            suppressWarnings(as.numeric(Data$val_prod)) - 
                            suppressWarnings(as.numeric(Data$costo_tx)) - 
                            suppressWarnings(as.numeric(Data$Part_profesional)),
                          NA)