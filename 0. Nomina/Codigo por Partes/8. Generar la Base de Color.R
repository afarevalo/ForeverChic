#===============================================================================
# Limpiar el entorno
#rm(list = ls())
#===============================================================================
#source("0. Nomina/APP/1. Cargar la Base.R")
#source("0. Nomina/APP/2. Nombre del Archivo Base.R")
#source("0. Nomina/APP/3. Agregar y Eliminar la Base.R")
#source("0. Nomina/APP/4. Clasificacion Tipo de Servicio.R")
#source("0. Nomina/APP/5. Manejo Partícipes.R")
#source("0. Nomina/APP/6. Costos de transacción.R")
#source("0. Nomina/APP/7. Participación Producto.R")
#===============================================================================

#Ruta Color
ruta_color <- "2. Descuentos/Color"

#===============================================================================
# Limpiar datos
Data_Color <- Data %>% select("Identificador","Fecha de Pago","Prestador/Vendedor"
                              ,"Nombre cliente","Servicio/Producto"
                              ,"Precio", "Tipo")

# Filtrar las filas donde Part_profesional es "Descuento"
Data_Color <- Data_Color %>% filter(Tipo %in% c("Colorimetria", "Queratina"))

# Inicalización de la Variable Valor Producto
Data_Color$val_prod <- NA
Data_Color$Ayuda <- NA
Data_Color$Ayuda <- ifelse(Data_Color$Tipo == "Queratina", NA, 0)

# Ruta del archivo color
archivos_color <- list.files(ruta_color)
ultimo_color <- archivos_color[length(archivos_color)]

if (Cambio == 1) {
  
  # Crear el nombre del archivo de salida añadiendo " - Color" al nombre original
  numero_extraido_col <- as.numeric(sub("^([0-9]+)\\..*", "\\1", ultimo_color))
  numero_extraido_col <- numero_extraido_col + 1
  numero_formateado <- sprintf("%02d", numero_extraido_col)
  nombre_archivo_salida <- paste0(numero_formateado, ". Color - ", MES1, " ",  MIN, " al ", MES2, " ", MAX, ".xlsx")
  
  # Escribir el archivo con el nuevo nombre en la carpeta destino
  write_xlsx(Data_Color, file.path(ruta_color, nombre_archivo_salida))
  
  Data_C1 <- read_excel(file.path(ruta_color, ultimo_color))
  Data_C2 <- read_excel(file.path(ruta_color, nombre_archivo_salida))
  
  # Realiza un left_join entre Data_C2 y Data_C1 usando las columnas clave
  Data_C2 <- Data_C2 %>%
    left_join(Data_C1 %>%
                select(Identificador, `Fecha de Pago`, `Prestador/Vendedor`, `Nombre cliente`, 
                       `Servicio/Producto`, Precio, Tipo, val_prod), 
              by = c("Identificador", "Fecha de Pago", "Prestador/Vendedor", 
                     "Nombre cliente", "Servicio/Producto", "Precio", "Tipo")) %>%
    mutate(val_prod = ifelse(!is.na(val_prod.y), val_prod.y, NA)) %>%
    select(-val_prod.y, -val_prod.x) # Ajusta el nombre de las columnas si se duplican
  
  # Para llenar la variable Ayuda
  
  Data_C2 <- Data_C2 %>%
    left_join(Data_C1 %>%
                select(Identificador, `Fecha de Pago`, `Prestador/Vendedor`, `Nombre cliente`, 
                       `Servicio/Producto`, Precio, Tipo, Ayuda), 
              by = c("Identificador", "Fecha de Pago", "Prestador/Vendedor", 
                     "Nombre cliente", "Servicio/Producto", "Precio", "Tipo")) %>%
    mutate(Ayuda = ifelse(!is.na(Ayuda.y), Ayuda.y, NA)) %>%
    select(-Ayuda.y, -Ayuda.x) # Ajusta el nombre de las columnas si se duplican
  
  # Completar la variable Ayuda 
  ifelse(is.na(Data_C2$Ayuda) & Data_C2$Tipo == "Colorimetria", 0, Data_C2$Ayuda)
  # Elimina el archivo viejo
  #file.remove(file.path(ruta_color, ultimo_color))
  
  # Crear un Workbook
  wb <- createWorkbook()
  
  # Agregar una hoja con el nombre "Sheet1"
  addWorksheet(wb, "Sheet1")
  
  # Escribir los datos en la hoja
  writeData(wb, sheet = "Sheet1", x = Data_C2)
  
  # Ajustar las celdas
  setColWidths(wb, sheet = "Sheet1", cols = 1:ncol(Data_C2), widths = "auto")
  
  # Aplicar negrilla a los encabezados
  header_style <- createStyle(textDecoration = "bold")
  addStyle(wb, sheet = "Sheet1", style = header_style, rows = 1, cols = 1:ncol(Data_C2), gridExpand = TRUE)
  
  # Colorear la columna "val_prod" en amarillo
  # Buscar el índice de la columna "val_prod"
  val_prod_col <- which(names(Data_C2) == "val_prod")
  if (length(val_prod_col) > 0) {
    yellow_fill <- createStyle(fgFill = "#FFFF00")
    addStyle(wb, sheet = "Sheet1", style = yellow_fill, rows = 2:(nrow(Data_C2) + 1), cols = val_prod_col, gridExpand = TRUE)
  }
  
  # Guardar el archivo
  saveWorkbook(wb, file = file.path(ruta_color, ultimo_color), overwrite = TRUE)
  
  #Archivo que se quiere abrir
  archivo_destino_col <- file.path(ruta_color, ultimo_color)
  # Convertir la ruta relativa a ruta absoluta
  archivo_destino_absoluto_col <- normalizePath(archivo_destino_col, winslash = "/", mustWork = TRUE)
  # Abrir el archivo copiado con el programa predeterminado del sistema
  shell.exec(archivo_destino_absoluto_col)
  
  rm(Data_C1)
  rm(Data_C2)
  rm(Data_Color)
  rm(header_style)
  rm(yellow_fill)
  file.remove(file.path(ruta_color, nombre_archivo_salida))
}

if (Cambio == 0) {
  
  # Crear el nombre del archivo de salida añadiendo " - Color" al nombre original
  numero_formateado <- sprintf("%02d", numero_extraido)
  nombre_archivo_salida <- paste0(numero_formateado, ". Color - ", MES1, " ",  MIN, " al ", MES2, " ", MAX, ".xlsx")
  
  # Crear un Workbook
  wb <- createWorkbook()
  
  # Agregar una hoja con el nombre "Sheet1"
  addWorksheet(wb, "Sheet1")
  
  # Escribir los datos en la hoja
  writeData(wb, sheet = "Sheet1", x = Data_Color)
  
  # Ajustar las celdas
  setColWidths(wb, sheet = "Sheet1", cols = 1:ncol(Data_Color), widths = "auto")
  
  # Aplicar negrilla a los encabezados
  header_style <- createStyle(textDecoration = "bold")
  addStyle(wb, sheet = "Sheet1", style = header_style, rows = 1, cols = 1:ncol(Data_Color), gridExpand = TRUE)
  
  # Colorear la columna "val_prod" en amarillo
  # Buscar el índice de la columna "val_prod"
  val_prod_col <- which(names(Data_Color) == "val_prod")
  if (length(val_prod_col) > 0) {
    yellow_fill <- createStyle(fgFill = "#FFFF00")
    addStyle(wb, sheet = "Sheet1", style = yellow_fill, rows = 2:(nrow(Data_Color) + 1), cols = val_prod_col, gridExpand = TRUE)
  }
  
  # Guardar el archivo
  saveWorkbook(wb, file = file.path(ruta_color, nombre_archivo_salida), overwrite = TRUE)
  
  #Archivo que se quiere abrir
  archivo_destino_col <- file.path(ruta_color, nombre_archivo_salida)
  # Convertir la ruta relativa a ruta absoluta
  archivo_destino_absoluto_col <- normalizePath(archivo_destino_col, winslash = "/", mustWork = TRUE)
  # Abrir el archivo copiado con el programa predeterminado del sistema
  shell.exec(archivo_destino_absoluto_col)
  
  rm(header_style)
  rm(yellow_fill)
  
}
