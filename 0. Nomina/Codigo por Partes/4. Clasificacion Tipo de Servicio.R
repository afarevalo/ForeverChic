#===============================================================================
# Limpiar el entorno
#rm(list = ls())
#===============================================================================
#source("0. Nomina/Codigo por Partes/1. Cargar la Base.R")
#source("0. Nomina/Codigo por Partes/2. Nombre del Archivo Base.R")
#source("0. Nomina/Codigo por Partes/3. Agregar y Eliminar la Base.R")
#===============================================================================

# Cargar la data
Data <- read_excel(file.path("1. Ventas Mensuales", nuevo_nombre))

# Lista de Profesionales
Base_Profesionales <- read_excel("0. Nomina/Info.xlsx", sheet = "0. Profesionales")
Base_Profesionales <- as.vector(Base_Profesionales[[1]])
Base_Profesionales

#===============================================================================

# Crear una lista de vectores desde el archivo Excel
sheets <- c("1. Tocador", "2. Spa", "3. Depilacion", "4. Bac", 
            "5. Colorimetria", "6. Venta", "7. Maquillaje", 
            "8. Maquillaje Salon", "9. Accesorios", "10. Queratina", 
            "11. TermoCut", "12. Venta N", "14. Masaje")

tipos <- c("Tocador", "Spa", "Depilacion", "Bac", 
           "Colorimetria", "Venta", "Maquillaje", 
           "Maquillaje_S", "Accesorios", "Queratina", 
           "TermoCut", "Venta_N", "Masaje")

# Leer todas las hojas y guardar en una lista de vectores
servicios <- lapply(seq_along(sheets), function(i) {
              list(tipo = tipos[i], items = read_excel("0. Nomina/Info.xlsx", 
              sheet = sheets[i])[[1]])
             })

# Inicialización de la variable Tipo
Data$Tipo <- "NA"

# Clasificación de los servicios
Data$Tipo <- ifelse(Data$`Prestador/Vendedor` == "Nydia Gamba", "Alianza",
                    sapply(Data$`Servicio/Producto`, function(producto) {
                      match <- sapply(servicios, function(servicio) producto %in% 
                                      servicio$items)
                      if (any(match)) servicios[[which(match)]]$tipo 
                      else if (producto == "Propina desde") "Propina" 
                      else NA
                    }))

# Clasifica los Bonos
Data$Tipo <- ifelse(Data$`Servicio/Producto` == "Bonos desde", "Bonos", Data$Tipo)
rm(servicios)