#===============================================================================
#source("0. Nomina/APP/1. Cargar la Base.R")
#source("0. Nomina/APP/2. Nombre del Archivo Base.R")
#===============================================================================

# Exporta la  Base de Datos 
write_xlsx(Data, file.path("1. Ventas Mensuales", nuevo_nombre))

# Elimina la Base de Datos Original
#file.remove(ruta_archivo)