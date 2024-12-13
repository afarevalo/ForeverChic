#===============================================================================
# Limpiar el entorno
#rm(list = ls())
#===============================================================================
#source("0. Nomina/APP/1. Cargar la Base.R")
#source("0. Nomina/APP/2. Nombre del Archivo Base.R")
#source("0. Nomina/APP/3. Agregar y Eliminar la Base.R")
#source("0. Nomina/APP/4. Generar la Base de Descuentos.R")
#source("0. Nomina/APP/5. Clasificacion Tipo de Servicio.R")
#===============================================================================
# Limpiar datos
Data_Color <- Data %>% select("Identificador","Fecha de Pago","Prestador/Vendedor"
                              ,"Nombre cliente","Servicio/Producto"
                              ,"Precio", "Tipo")

# Filtrar las filas donde Part_profesional es "Descuento"
Data_Color <- Data_Color %>% filter(Tipo %in% c("Colorimetria", "Queratina"))

# Inicalización de la Variable Valor Producto
Data_Color$Valor_producto <- NA
Data_Color$Ayuda <- NA

# Crear el nombre del archivo de salida añadiendo " - Color" al nombre original
nombre_archivo_salida <- paste0(numero_extraido, ". Color - ", MES1, " ",  MIN, " al ", MES2, " ", MAX, ".xlsx")

# Escribir el archivo con el nuevo nombre en la carpeta destino
write_xlsx(Data_Color, file.path("2. Descuentos/Color", nombre_archivo_salida))
