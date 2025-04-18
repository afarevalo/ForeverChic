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
# }, error = function(e) {
#   cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
#   stop(e)  # Detiene toda la ejecución
# })
#===============================================================================

# Ruta de la Base de Datos de Descuentos
ruta_retardos_formato <- "2. Descuentos - Retardos"
formato_retardo <- file.path(ruta_retardos_formato, "0. Formato - Retardos.xlsx")

# Definir las abreviaturas de los meses en español con su número correspondiente
meses_esp <- c("ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC")

# Genera "01", "02", ..., "12"
numeros_meses <- sprintf("%02d", 1:12)
mes_dict <- setNames(numeros_meses, meses_esp)

# Crear los nombres de archivo esperados
archivo_mes1 <- file.path(ruta_retardos, sprintf("%s. Retardos - %s.xlsx", mes_dict[MES1], MES1))
archivo_mes2 <- file.path(ruta_retardos, sprintf("%s. Retardos - %s.xlsx", mes_dict[MES2], MES2))

# Verificar si existen los archivos
existe_mes1 <- file_exists(archivo_mes1)

# Copiar el archivo si es necesario
if (!existe_mes1) {
  file_copy(formato_retardo, archivo_mes1)
}

# Verificar si existen los archivos
existe_mes2 <- file_exists(archivo_mes2)

if (!existe_mes2) {
  file_copy(formato_retardo, archivo_mes2)
}

# Eliminar variables
rm(ruta_retardos_formato, formato_retardo, meses_esp, numeros_meses, mes_dict,
   existe_mes1, existe_mes2, ruta_retardos)
