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
#   
#   source("0. Codigo/Codigo por Partes/9. Generar la Base de Descuentos.R")
# }, error = function(e) {
#   cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
#   stop(e)  # Detiene toda la ejecución
# })
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

if (Cambio == 1) {

  # Ruta del archivo color
  archivos_color <- list.files(ruta_color)
  ultimo_color <- archivos_color[length(archivos_color)]
    
  Data_C1 <- read_excel(file.path(ruta_color, ultimo_color))

  # Realiza un left_join entre Data_Color y Data_C1 usando las columnas clave
  Data_Color <- Data_Color %>%
    left_join(Data_C1 %>%
                select(Identificador, `Fecha de Pago`, `Prestador/Vendedor`, `Nombre cliente`, 
                       `Servicio/Producto`, Precio, Tipo, val_prod), 
              by = c("Identificador", "Fecha de Pago", "Prestador/Vendedor", 
                     "Nombre cliente", "Servicio/Producto", "Precio", "Tipo")) %>%
    mutate(val_prod = ifelse(!is.na(val_prod.y), val_prod.y, NA)) %>%
    select(-val_prod.y, -val_prod.x) # Ajusta el nombre de las columnas si se duplican

  # Para llenar la variable Ayuda
  Data_Color <- Data_Color %>%
    left_join(Data_C1 %>%
                select(Identificador, `Fecha de Pago`, `Prestador/Vendedor`, `Nombre cliente`, 
                       `Servicio/Producto`, Precio, Tipo, Ayuda), 
              by = c("Identificador", "Fecha de Pago", "Prestador/Vendedor", 
                     "Nombre cliente", "Servicio/Producto", "Precio", "Tipo")) %>%
    mutate(Ayuda = ifelse(!is.na(Ayuda.y), Ayuda.y, NA)) %>%
    select(-Ayuda.y, -Ayuda.x) # Ajusta el nombre de las columnas si se duplican
  
  # Completar la variable NAs de val_prod y Ayuda
  Data_Color$Ayuda <- ifelse(is.na(Data_Color$Ayuda) & Data_Color$Tipo == "Colorimetria", 0, Data_Color$Ayuda)
  Data_Color$val_prod <- ifelse(is.na(Data_Color$val_prod), 0, Data_Color$val_prod)
  
  # Escribir el archivo con el nuevo nombre en la carpeta destino
  write_xlsx(Data_Color, file.path(ruta_color, ultimo_color))
  
  # Crear un Workbook
  wb <- createWorkbook()
  
  # Agregar una hoja con el nombre "Sheet1"
  addWorksheet(wb, "Sheet1")
  
  # Escribir los datos en la hoja
  writeData(wb, sheet = "Sheet1", x = Data_Color)
  
  # Aplicar negrilla a los encabezados
  header_style <- createStyle(textDecoration = "bold")
  addStyle(wb, sheet = "Sheet1", style = header_style, rows = 1, cols = 1:ncol(Data_Color), gridExpand = TRUE)
  
  # Ajustar las celdas
  setColWidths(wb, sheet = "Sheet1", cols = 1:ncol(Data_Color), widths = "auto")
  
  # Colorear la columna "val_prod" en amarillo
  # Buscar el índice de la columna "val_prod"
  val_prod_col <- which(names(Data_Color) == "val_prod")
  if (length(val_prod_col) > 0) {
    yellow_fill <- createStyle(fgFill = "#FFFF00")
    addStyle(wb, sheet = "Sheet1", style = yellow_fill, rows = 2:(nrow(Data_Color) + 1), cols = val_prod_col, gridExpand = TRUE)
  }
  
  # Guardar el archivo
  saveWorkbook(wb, file = file.path(ruta_color, ultimo_color), overwrite = TRUE)

  #Eliminar variables, vectores y archivos
  rm(header_style, yellow_fill, Data_C1, Data_Color, archivos_color, 
     nuevo_nombre, wb, val_prod_col, ultimo_color)
  
  # #Archivo que se quiere abrir
  # archivo_destino_col <- file.path(ruta_color, ultimo_color)
  # # Convertir la ruta relativa a ruta absoluta
  # archivo_destino_absoluto_col <- normalizePath(archivo_destino_col, winslash = "/", mustWork = TRUE)
  # # Abrir el archivo copiado con el programa predeterminado del sistema
  # shell.exec(archivo_destino_absoluto_col)
  
}

#===============================================================================

if (Cambio == 0) {
  
  nombre_archivo_salida <- paste0(numero_extraido, ". Color - ", MES1, " ",  MIN, " al ", MES2, " ", MAX, " - ", ANIO, ".xlsx")
  
  # Crear un Workbook
  wb <- createWorkbook()
  
  # Agregar una hoja con el nombre "Sheet1"
  addWorksheet(wb, "Sheet1")
  
  # Escribir los datos en la hoja
  writeData(wb, sheet = "Sheet1", x = Data_Color)
  
  # Aplicar negrilla a los encabezados
  header_style <- createStyle(textDecoration = "bold")
  addStyle(wb, sheet = "Sheet1", style = header_style, rows = 1, cols = 1:ncol(Data_Color), gridExpand = TRUE)
  
  # Ajustar las celdas
  setColWidths(wb, sheet = "Sheet1", cols = 1:ncol(Data_Color), widths = "auto")
  
  # Colorear la columna "val_prod" en amarillo
  # Buscar el índice de la columna "val_prod"
  val_prod_col <- which(names(Data_Color) == "val_prod")
  if (length(val_prod_col) > 0) {
    yellow_fill <- createStyle(fgFill = "#FFFF00")
    addStyle(wb, sheet = "Sheet1", style = yellow_fill, rows = 2:(nrow(Data_Color) + 1), cols = val_prod_col, gridExpand = TRUE)
  }
  
  # # Guardar el archivo
  saveWorkbook(wb, file = file.path(ruta_color, nombre_archivo_salida), overwrite = TRUE)
   
  # #Archivo que se quiere abrir
  # archivo_destino_col <- file.path(ruta_color, nombre_archivo_salida)
  # # Convertir la ruta relativa a ruta absoluta
  # archivo_destino_absoluto_col <- normalizePath(archivo_destino_col, winslash = "/", mustWork = TRUE)
  # # Abrir el archivo copiado con el programa predeterminado del sistema
  # shell.exec(archivo_destino_absoluto_col)
  
  # Eliminar Estilos
  rm(header_style, yellow_fill)
  
}
