#===============================================================================
# Limpiar el entorno
# rm(list = ls())
cat("\014")
#===============================================================================
# tryCatch({
#   source("0. Codigo/Codigo por Partes/1. Cargar la Base.R")
#   source("0. Codigo/Codigo por Partes/2. Nombre del Archivo Base.R")
#   source("0. Codigo/Codigo por Partes/3. Agregar y Eliminar la Base.R")
# }, error = function(e) {
#   cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
#   stop(e)  # Detiene toda la ejecución
# })
#===============================================================================

# Lista de Profesionales
Base_Profesionales <- read_excel("0. Codigo/Info.xlsx", sheet = "0. Profesionales")
Base_Profesionales <- as.vector(Base_Profesionales[[1]])

#===============================================================================

# Crear una lista de vectores desde el archivo Excel
sheets <- c("1. Tocador", "2. Spa", "3. Depilacion", "4. Bac", 
            "5. Colorimetria", "6. Venta", "7. Maquillaje", 
            "8. Maquillaje Salon", "9. Accesorios", "10. Queratina", 
            "11. TermoCut", "12. Venta N", "13. Companeros N", "14. Masaje")

tipos <- c("Tocador", "Spa", "Depilacion", "Bac", 
           "Colorimetria", "Venta", "Maquillaje", 
           "Maquillaje_S", "Accesorios", "Queratina", 
           "TermoCut", "Venta_N", "Compa_N", "Masaje")

# Leer todas las hojas y guardar en una lista de vectores
servicios <- lapply(seq_along(sheets), function(i) {
              list(tipo = tipos[i], items = read_excel("0. Codigo/Info.xlsx", 
                                                       sheet = sheets[i])[[1]])
})

# Inicialización de la variable Tipo
Data$Tipo <- "NA"

# Clasificación de los servicios
Data$Tipo <- ifelse(Data$`Prestador/Vendedor` == "Nydia Gamba" & 
                      !(Data$`Servicio/Producto` == "Propina desde") &
                      !(Data$`Servicio/Producto` %in% servicios[[12]]$items), "Alianza",
                    sapply(Data$`Servicio/Producto`, function(producto) {
                      match <- sapply(servicios, function(servicio) producto %in% 
                                        servicio$items)
                      if (any(match)) servicios[[which(match)]]$tipo 
                      else if (producto == "Propina desde") "Propina" 
                      else NA
                    }))

# Clasifica los Bonos
Data$Tipo <- ifelse(Data$`Servicio/Producto` == "Bonos desde", "Bonos", Data$Tipo)
rm(servicios, sheets, tipos)

#===============================================================================

# Verificar si hay valores NA en la variable "Tipo"
if (any(is.na(Data$Tipo))) {
  # Extraer los servicios/productos sin clasificar
  servicios_sin_clasificar <- Data$`Servicio/Producto`[is.na(Data$Tipo)]
  
  # Mostrar mensaje de alerta con lista de servicios sin clasificar
  cat("\n⚠️  ERROR: Servicios sin clasificar en la base de datos:\n")
  print(servicios_sin_clasificar)
  
  # Detener ejecución completamente
  stop("Ejecución detenida: Existen servicios sin clasificar en la variable 'Tipo'.")
}
