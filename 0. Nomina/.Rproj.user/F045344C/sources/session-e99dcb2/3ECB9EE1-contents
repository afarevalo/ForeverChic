#===============================================================================
# Limpiar el entorno
# rm(list = ls())
cat("\014")
#===============================================================================
# tryCatch({
#   source("0. Codigo/Codigo por Partes/1. Cargar la Base.R")
#   source("0. Codigo/Codigo por Partes/2. Nombre del Archivo Base.R")
#   source("0. Codigo/Codigo por Partes/3. Agregar y Eliminar la Base.R")
#   source("0. Codigo/Codigo por Partes/4. Clasificacion Tipo de Servicio.R")
#   source("0. Codigo/Codigo por Partes/5. Manejo Partícipes.R")
#   source("0. Codigo/Codigo por Partes/6. Costos de transacción.R")
#   source("0. Codigo/Codigo por Partes/7. Participación Producto.R")
#   source("0. Codigo/Codigo por Partes/8. Generar la Base de Retardos.R")
#   source("0. Codigo/Codigo por Partes/9. Generar la Base de Descuentos.R")
#   source("0. Codigo/Codigo por Partes/10. Generar la Base de Color.R")
#   source("0. Codigo/Codigo por Partes/11. Completar Base con Color.R")
#   source("0. Codigo/Codigo por Partes/12. Completar Base de Retardos.R")
#   source("0. Codigo/Codigo por Partes/13. Completar Descuentos Fondo.R")
#   source("0. Codigo/Codigo por Partes/14. Porcentaje de los Profesionales.R")
# }, error = function(e) {
#   cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
#   stop(e)  # Detiene toda la ejecución
# })
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
