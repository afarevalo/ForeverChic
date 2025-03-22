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
#   source("0. Codigo/Codigo por Partes/8. Generar la Base de Descuentos.R")
#   source("0. Codigo/Codigo por Partes/9. Generar la Base de Color.R")
#   source("0. Codigo/Codigo por Partes/10. Completar Base con Color.R")
#   source("0. Codigo/Codigo por Partes/11. Porcentaje de los Profesionales.R")
#   source("0. Codigo/Codigo por Partes/12. Participación Salón.R")
#   source("0. Codigo/Codigo por Partes/13. Descuento Ajuste Producto.R")
#   source("0. Codigo/Codigo por Partes/14. Descuentos Varios a Profesionales.R")
# }, error = function(e) {
#   cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
#   stop(e)  # Detiene toda la ejecución
# })
#===============================================================================

# Lista de Profesionales 
Tipo_Profesionales <- read_excel("0. Codigo/Info.xlsx", sheet = "0. Profesionales")

# Crear el Nombre de la carpeta donde se exportaran los resultados
cadena_carpeta <- paste0(". Resultados ", MES1, " ",  MIN, " al ", MES2, " ", MAX, " - ", ANIO)
nombre_carpeta <- paste0(numero_extraido, cadena_carpeta)

# Crear la carpeta de Resultados
ruta_resultados <- file.path(ruta_resultados, nombre_carpeta)

# Verificar si la carpeta existe
if (dir.exists(ruta_resultados)) {
  # Eliminar la carpeta existente y su contenido
  unlink(ruta_resultados, recursive = TRUE)
}

# Crear una nueva carpeta vacía
dir.create(ruta_resultados, recursive = TRUE, showWarnings = FALSE)
#===============================================================================

# Filtrar los datos de "Marinela Olaya"
datos_marinela <- Data %>% filter(`Prestador/Vendedor` == "Marinela Olaya")

# Sumar los valores positivos de "Part_profesional"
suma_positivos <- sum(datos_marinela$Part_profesional[datos_marinela$Part_profesional > 0], na.rm = TRUE)

# Sumar los valores negativos de "Part_profesional"
suma_negativos <- sum(datos_marinela$Part_profesional[datos_marinela$Part_profesional < 0], na.rm = TRUE)

# Borrar datos de la cosnsola
cat("\014")

if (suma_positivos >= 900000) {
  cat("- Marinela Olaya no necesita Apoyo Económico, pues facturó ", 
      formatC(suma_positivos, format = "f", big.mark = ",", digits = 2), ".\n")
} else {
  # Calcular cuánto apoyo necesita
  apoyo_economico <- 900000 - suma_positivos
  
  # Calcular el monto total a pagar incluyendo los descuentos y anticipos
  total_pagar_marinela <- 900000 + suma_negativos
  
  cat("- Marinela necesita Apoyo Económico de ", 
      formatC(apoyo_economico, format = "f", big.mark = ",", digits = 2), "\n",
      " Pero con los descuentos y anticipos se le debe pagar", 
      formatC(total_pagar_marinela, format = "f", big.mark = ",", digits = 2), ".\n")
  
  nueva_fila <- data.frame(
    `Nombre cliente` = "Apoyo",
    `Servicio/Producto` = "Apoyo",
    `Prestador/Vendedor` = "Marinela Olaya",
    Part_profesional = apoyo_economico, # Asegúrate de que 'apoyo_economico' esté definido previamente como numérico
    stringsAsFactors = FALSE # Evita la conversión de cadenas a factores
  )
  
  # Agregar la nueva fila a la base de datos 'Data'
  Data <- rbind(Data, nueva_fila)
  Data$`Prestador/Vendedor` <- ifelse(is.na(Data$Identificador) & 
                                      is.na(Data$`Fecha de Pago`) & 
                                      is.na(Data$Precio), Data$Prestador.Vendedor, Data$`Prestador/Vendedor`)
  
  Data$`Nombre cliente` <- ifelse(is.na(Data$Identificador) & 
                                        is.na(Data$`Fecha de Pago`) & 
                                        is.na(Data$Precio), Data$Nombre.cliente, Data$`Nombre cliente`)
  
  Data$`Servicio/Producto` <- ifelse(is.na(Data$Identificador) & 
                                    is.na(Data$`Fecha de Pago`) & 
                                    is.na(Data$Precio), Data$Servicio.Producto, Data$`Servicio/Producto`)
  rm(nueva_fila)
  
  Data <- Data %>% select(-Servicio.Producto, -Nombre.cliente, -Prestador.Vendedor)
  
  }

rm(datos_marinela)
rm(Data_Color_unique)
# Descargar los soportes de Pago por Profesional
#===============================================================================

# Filtrar y ajustar las columnas según el tipo de profesional
Data_Spa <- Data %>% select(-costo_tx, -val_prod, -Tipo, -pct_prod, -val_neto, -Part_salon, -Modificado)
Data_Tocador <- Data %>% select(-costo_tx, -pct_prod, -val_neto, -Part_salon, -Modificado)
Data_Alianza <- Data %>% select(-val_prod, -Tipo, -pct_prod, -val_neto, -Part_salon,  -Modificado)

# Concidicional Para val_prod
Data_Tocador$val_prod <- ifelse(Data_Tocador$Tipo == "Colorimetria", 
                                Data_Tocador$val_prod, 0)
Data_Tocador <- Data_Tocador %>% select(-Tipo)

# Vectores de profesionales


# Crear los vectores dinámicamente
profesionales_tipo <- split(Tipo_Profesionales$Profesional, Tipo_Profesionales$Tipo)

# Asignar los valores a variables individuales
tocador <- profesionales_tipo[["Tocador"]]
alianza <- profesionales_tipo[["Alianza"]]
spa <- profesionales_tipo[["Spa"]]
revisar <- c("Revisar")

# Eliminar variables
rm(profesionales_tipo, Tipo_Profesionales)

#===============================================================================

# Iterar sobre cada trabajador
for (trabajador in unique(Data$`Prestador/Vendedor`)) {
  
  # Determinar la base de datos a usar
  if (trabajador %in% tocador) {
    base_datos <- Data_Tocador
  } else if (trabajador %in% alianza) {
    base_datos <- Data_Alianza
  } else if (trabajador %in% spa) {
    base_datos <- Data_Spa
  } else if (trabajador %in% revisar) {
    base_datos <- Data
  } else {
    next # Ignorar trabajadores que no están en ningún vector
  }
  
  # Filtrar los datos para el trabajador actual
  datos_trabajador <- base_datos %>% filter(`Prestador/Vendedor` == trabajador)
  
  # Crear un workbook
  wb <- createWorkbook()
  
  # Agregar una hoja
  addWorksheet(wb, "Datos")
  
  # Escribir los datos en la hoja
  writeData(wb, "Datos", datos_trabajador)
  
  # Ajustar automáticamente el ancho de las columnas
  setColWidths(wb, sheet = "Datos", cols = 1:ncol(datos_trabajador), widths = "auto")
  
  # Aplicar estilo de negrilla a los encabezados
  header_style <- createStyle(textDecoration = "bold", halign = "center", valign = "center")
  addStyle(
    wb,
    sheet = "Datos",
    style = header_style,
    rows = 1, # Fila 1: Encabezados
    cols = 1:ncol(datos_trabajador),
    gridExpand = TRUE
  )
  
  # Formatear la columna "Part_profesional" como ($ 26.675)
  if ("Part_profesional" %in% colnames(datos_trabajador)) {
    col_index <- which(colnames(datos_trabajador) == "Part_profesional")
    
    # Formato contable
    accounting_style <- createStyle(numFmt = "\"$\" #,##0;[Red]\"$\" -#,##0") # Valores negativos en rojo
    addStyle(
      wb,
      sheet = "Datos",
      style = accounting_style,
      rows = 2:(nrow(datos_trabajador) + 1),
      cols = col_index,
      gridExpand = TRUE
    )
    
    # Identificar filas con valores negativos en "Part_profesional"
    filas_negativas <- which(datos_trabajador$Part_profesional < 0)
    
    # Pintar toda la fila de amarillo en las filas negativas
    if (length(filas_negativas) > 0) {
      yellow_row_style <- createStyle(fgFill = "#FFFF00") # Fondo amarillo para toda la fila
      for (fila in filas_negativas) {
        addStyle(
          wb, 
          sheet = "Datos", 
          style = yellow_row_style, 
          rows = fila + 1, # +1 porque la primera fila son los encabezados
          cols = 1:ncol(datos_trabajador), # Toda la fila
          gridExpand = TRUE,
          stack = TRUE # Combina estilos existentes
        )
      }
    }
  }
  
  # Definir la ruta de guardado del archivo Excel
  ruta_archivo <- file.path(ruta_resultados, paste0(trabajador, ".xlsx"))
  
  # Guardar el archivo
  saveWorkbook(wb, ruta_archivo, overwrite = TRUE)
}

rm(header_style,datos_trabajador, Data_Alianza, Data_Spa, Data_Tocador, base_datos,accounting_style)
