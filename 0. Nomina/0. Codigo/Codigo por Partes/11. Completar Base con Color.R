#===============================================================================
# Limpiar el entorno
# rm(list = ls())
cat("\014")
#===============================================================================
# tryCatch({
#   source("0. Codigo/Codigo por Partes/01. Cargar la Base.R")
#   source("0. Codigo/Codigo por Partes/02. Nombre del Archivo Base.R")
#   source("0. Codigo/Codigo por Partes/03. Agregar y Eliminar la Base.R")
#   source("0. Codigo/Codigo por Partes/04. Clasificacion Tipo de Servicio.R")
#   source("0. Codigo/Codigo por Partes/05. Manejo Partícipes.R")
#   source("0. Codigo/Codigo por Partes/06. Costos de transacción.R")
#   source("0. Codigo/Codigo por Partes/07. Participación Producto.R")
#   source("0. Codigo/Codigo por Partes/08. Generar la Base de Retardos.R")
#   source("0. Codigo/Codigo por Partes/09. Generar la Base de Descuentos.R")
#   source("0. Codigo/Codigo por Partes/10. Generar la Base de Color.R")
# }, error = function(e) {
#   cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
#   stop(e)  # Detiene toda la ejecución
# })
#===============================================================================
# Importacion de los Datos
Data_Color <- read_excel(archivo_color)
#===============================================================================

# Volver texto a dummy
Posibilidades <- c("SI", "si", "Si", "sI", "Ayudo", 1, "1")
Data_Color$Ayuda <- ifelse(Data_Color$Ayuda %in% Posibilidades, 1,0)
rm(Posibilidades)

#===============================================================================
# Completar Data_actualizada con la información de Colorimetria
# Asegurarse de que Data_Color no tenga duplicados para las claves usadas en el join
Data_Color_unique <- Data_Color %>%
  distinct(Identificador, `Servicio/Producto`, `Prestador/Vendedor`, `Nombre cliente`, Precio, .keep_all = TRUE)

# Realizar el left_join
Data_actualizada <- Data %>%
  left_join(
    Data_Color_unique %>% select(Identificador, `Servicio/Producto`, `Prestador/Vendedor`, `Nombre cliente`, Precio, val_prod, Ayuda),
    by = c("Identificador", "Servicio/Producto", "Prestador/Vendedor", "Nombre cliente", "Precio"),
    suffix = c("", "_color")
  )

# Correccion de los NAs en val_prod para el Tipo Colorimetria, concicion para Rellenar los Valores
Data_actualizada$val_prod <- ifelse(Data_actualizada$Tipo == "Colorimetria", NA, Data_actualizada$val_prod)
Data_actualizada$Ayuda <- ifelse(Data_actualizada$Tipo == "Colorimetria", NA, Data_actualizada$Ayuda)
Data_actualizada$val_prod <- ifelse(Data_actualizada$Tipo == "Queratina" , NA, Data_actualizada$val_prod)

# Rellenar valores de "val_prod" y "Ayuda" solo cuando están vacíos y se cumple la condición
Data_actualizada <- Data_actualizada %>%
  mutate(
    val_prod = ifelse(is.na(val_prod), val_prod_color, val_prod),
    Ayuda = ifelse(is.na(Ayuda), Ayuda, Ayuda)
  ) %>%
  select(-val_prod_color)  # Eliminar columnas auxiliares

#===============================================================================

# Asignar la base de datos actualizada a "Data" si se desea
Data <- Data_actualizada
rm(Data_actualizada)

# Completar la Variable 'pct_prod'
Data$pct_prod <- ifelse(Data$Tipo == "Colorimetria" & Data$Precio > 100, Data$val_prod/Data$Precio,
                    ifelse(Data$Tipo == "Colorimetria" & Data$`Precio de Lista` > 100, 
                           Data$val_prod/Data$`Precio de Lista`, Data$pct_prod))

Data$pct_prod <- ifelse(Data$Tipo == "Queratina" & Data$Precio > 100, Data$val_prod/Data$Precio,
                        ifelse(Data$Tipo == "Queratina" & Data$`Precio de Lista` > 100, 
                               Data$val_prod/Data$`Precio de Lista`, Data$pct_prod))

# Completar la variable Dummy Ayuda
Data$Ayuda <- ifelse(is.na(Data$Ayuda), 0, Data$Ayuda)

# Eliminar Variables
rm(Data_Color_unique, Data_Color, archivo_color)

