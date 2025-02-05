cat("\014")
#===============================================================================
# Limpiar el entorno
#rm(list = ls())
#===============================================================================
#source("0. Codigo/Codigo por Partes/1. Cargar la Base.R")
#source("0. Codigo/Codigo por Partes/2. Nombre del Archivo Base.R")
#source("0. Codigo/Codigo por Partes/3. Agregar y Eliminar la Base.R")
#source("0. Codigo/Codigo por Partes/4. Clasificacion Tipo de Servicio.R")
#source("0. Codigo/Codigo por Partes/5. Manejo Partícipes.R")
#source("0. Codigo/Codigo por Partes/6. Generar la Base de Color.R")
#source("0. Codigo/Codigo por Partes/7. Generar la Base de Descuentos.R")
#source("0. Codigo/Codigo por Partes/8. Costos de transacción.R")
#source("0. Codigo/Codigo por Partes/9. Participación Producto.R")
#===============================================================================

# Ruta del archivo color
archivos_color <- list.files(ruta_color)
ultimo_color <- archivos_color[length(archivos_color)]

# Importacion de los Datos
ultimo_color <- archivos_color[length(archivos_color)]
Data_Color <- read_excel(file.path("2. Descuentos/Color", ultimo_color))

#===============================================================================

Posibilidades <- c("SI", "si", "Si", "sI", "Ayudo")
Data_Color$Ayuda <- ifelse(Data_Color$Ayuda %in% Posibilidades, 1,0)

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

# Completar la Variable pct_prod
Data$pct_prod <- ifelse(Data$Tipo == "Colorimetria",Data$val_prod/Data$Precio,Data$pct_prod)
Data$pct_prod <- ifelse(Data$Tipo == "Queratina",Data$val_prod/Data$Precio,Data$pct_prod)

# Completar la variable Dummy Ayuda
Data$Ayuda <- ifelse(is.na(Data$Ayuda), 0, Data$Ayuda)

rm(Data_Color)
