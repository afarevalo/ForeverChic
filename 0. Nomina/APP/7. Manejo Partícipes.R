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
#===============================================================================

# Vector de Nombres de Partícipes FOREVER para manejo del Servicio a los Socios
participes <- c("Andres Arevalo", "Andres Arévalo", "Andrés Arevalo",
                "Andrés Arévalo", "Carlitos Arevalo", "Carlos Arevalo",
                "Elsa Arevalo", "Sandra Mogollon", "Sandra Mogollón", 
                "Carlos Arévalo") 

# Renombrar a los Partícipes para agruparlos en una sola categoria
Data$`Nombre cliente` <- ifelse(Data$`Nombre cliente` %in% participes & Data$Precio == 0,
                                "Partícipes FOREVER", Data$`Nombre cliente`)

# Variable Modificado
Data$Modificado <- NA

# Se modificara el la Variable Precio
Data$Modificado <- ifelse(Data$`Nombre cliente` == "Partícipes FOREVER" & Data$Precio == 0,
                                1, NA)

# Concicional Para recalificar a los socios
Data$Precio <- ifelse(Data$`Nombre cliente` == "Partícipes FOREVER" & Data$Precio == 0,
                      Data$`Precio de Lista` , Data$Precio)
