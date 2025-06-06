#===============================================================================
# Limpiar el entorno
# rm(list = ls())
cat("\014")
#===============================================================================
# tryCatch({
#   source("0. Codigo/Codigo por Partes/01. Cargar la Base.R")
#   source("0. Codigo/Codigo por Partes/02. Nombre del Archivo Base.R")
#   source("0. Codigo/Codigo por Partes/03. Agregar y Eliminar la Base.R")
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
            "11. TermoCut", "12. Venta N", "13. Companeros N", "14. Masaje", 
            "15. Otros", "16. Leydy")

tipos <- c("Tocador", "Spa", "Depilacion", "Bac", 
           "Colorimetria", "Venta", "Maquillaje", 
           "Maquillaje_S", "Accesorios", "Queratina", 
           "TermoCut", "Venta_N", "Compa_N", "Masaje", "Otros", "Alianza")

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

rm(servicios, sheets, tipos)
#===============================================================================
# Correcion de servicios - 16. Leydy
leydy <- read_excel("0. Codigo/Info.xlsx", sheet = "16. Leydy")
leydy <- as.vector(leydy[[1]])

Data$`Prestador/Vendedor` <- ifelse(Data$`Prestador/Vendedor` == "Sandra Mogollon" & 
                                    Data$`Servicio/Producto` %in% leydy, "Nydia Gamba",
                                    Data$`Prestador/Vendedor`)

rm(leydy)
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

#===============================================================================
# Corrige si hay precios 1 en la variable `Precio de Lista`
if (any(Data$`Precio de Lista` == 1)) {
# Corrige errores de facturación
Data_precios <- Data %>% select("Precio de Lista", "Servicio/Producto")
# Filtrar por precios distitos de 1
Data_precios <- Data_precios %>% filter(`Precio de Lista` != 1)
Data_precios <- Data_precios %>% arrange(desc(`Precio de Lista`))
Data_precios <- Data_precios %>% distinct(`Servicio/Producto`, .keep_all = TRUE)

# Remplaza el 1 por un precio de lista mayor a 1. 
Data_actualizado <- Data %>%
  left_join(Data_precios, by = "Servicio/Producto", suffix = c("", "_nuevo")) %>%
  mutate(`Precio de Lista` = ifelse(`Precio de Lista` == 1, `Precio de Lista_nuevo`, `Precio de Lista`)) %>%
  select(-`Precio de Lista_nuevo`)  # eliminamos la columna auxiliar

Data <- Data_actualizado

# Elimina las datas auxiliares
rm(Data_actualizado, Data_precios)

# Corregir el precio y el total
Data$Precio <- ifelse(Data$Precio == 1, 0, Data$Precio)
Data$Total <- ifelse(Data$Total == 1, 0, Data$Total)

}

#===============================================================================

# Verificar si hay precios 1 en la variable `Precio de Lista`
if (any(Data$`Precio de Lista` == 1)) {
  # Extraer los servicios/productos sin clasificar
  precio_error <- Data$Identificador[Data$`Precio de Lista` == 1]
  precio_error <- na.omit(precio_error)
  
  # Mostrar mensaje de alerta con lista de servicios sin clasificar
  cat("\n⚠️  ERROR: Servicios sin clasificar en la base de datos:\n")
  print(precio_error[1])
  
  # Detener ejecución completamente
  stop("Ejecución detenida: Existen servicios mal facturados, pues el Precio de Lista es 1.")
}

