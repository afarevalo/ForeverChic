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
#   source("0. Codigo/Codigo por Partes/11. Completar Base con Color.R")
#   source("0. Codigo/Codigo por Partes/12. Completar Base de Retardos.R")
#   source("0. Codigo/Codigo por Partes/13. Completar Descuentos Fondo.R")
#   source("0. Codigo/Codigo por Partes/14. Porcentaje de los Profesionales.R")
#   source("0. Codigo/Codigo por Partes/15. Participación Salón.R")
#   source("0. Codigo/Codigo por Partes/16. Descuento Ajuste Producto.R")
#   source("0. Codigo/Codigo por Partes/17. Descuentos Varios a Profesionales.R")
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

# 1. Filtrar los profesionales que realmente necesitamos procesar ----
profes_activos <- Tipo_Profesionales %>%          # tabla de referencia
  filter(Minimo > 0) %>%                          # sólo los que tienen un mínimo positivo
  semi_join(                                       # y que aún aparecen en los servicios
    Data,
    by = c("Profesional" = "Prestador/Vendedor")
  )

# 2. Resumen de ventas vs. mínimos por profesional -------------------
resumen <- Data %>%
  filter(`Prestador/Vendedor` %in% profes_activos$Profesional) %>%
  group_by(`Prestador/Vendedor`) %>%
  summarise(
    suma_positivos = sum(Part_profesional[Part_profesional > 0], na.rm = TRUE),
    suma_negativos = sum(Part_profesional[Part_profesional < 0], na.rm = TRUE),
    .groups = "drop"
  ) %>%
  left_join(profes_activos, by = c("Prestador/Vendedor" = "Profesional")) %>%
  mutate(
    necesita_apoyo = suma_positivos < Minimo,
    apoyo_económico = pmax(Minimo - suma_positivos, 0),          # 0 si no necesita
    total_pagar     = Minimo + suma_negativos                    # lo que se liquida
  )

# 3. Mensajes de control en consola ----------------------------------
cat("\014")  # limpia consola
invisible(
  resumen %>% rowwise() %>% 
    do({
      if (!.$necesita_apoyo) {
        cat("- ", .$`Prestador/Vendedor`, 
            " no necesita Apoyo Económico; facturó ",
            formatC(.$suma_positivos, format = "f", big.mark = ",", digits = 2), ".\n", sep = "")
      } else {
        cat("- ", .$`Prestador/Vendedor`, 
            " necesita Apoyo Económico de ",
            formatC(.$apoyo_económico, format = "f", big.mark = ",", digits = 2), 
            ". Con descuentos/anticipos se le debe pagar ",
            formatC(.$total_pagar, format = "f", big.mark = ",", digits = 2), ".\n", sep = "")
      }
      data.frame()  # devuelve algo sin importancia
    })
)

# 4. Construir las filas “Apoyo” que harán falta ----------------------
filas_apoyo <- resumen %>%
  filter(necesita_apoyo) %>%
  transmute(
    `Nombre cliente`      = "Apoyo",
    `Servicio/Producto`   = "Apoyo",
    `Prestador/Vendedor`  = `Prestador/Vendedor`,
    Tipo                  = "Apoyo",
    Part_profesional      = apoyo_económico
  )

# 5. Añadir las filas a Data y dejar las columnas limpias ------------
Data <- bind_rows(Data, filas_apoyo)

# Si en tu Data todavía sobreviven las columnas temporales con puntos,
# elimínalas de una vez:
Data <- Data %>% 
  select(-matches("Servicio\\.Producto|Nombre\\.cliente|Prestador\\.Vendedor"), 
         everything())

# 6. Ajustar la parte del salón para las filas “Apoyo” ---------------
Data <- Data %>% 
  mutate(Part_salon = if_else(Tipo == "Apoyo", -Part_profesional, Part_salon))

rm(filas_apoyo, profes_activos, resumen)
#-------------------------------------------------------------------------------
# Descargar los soportes de Pago por Profesional
#-------------------------------------------------------------------------------

# Filtrar y ajustar las columnas según el tipo de profesional
Data_Spa <- Data %>% select(-costo_tx, -val_prod, -Tipo, -pct_prod, -val_neto, -Part_salon, -Modificado)
Data_Tocador <- Data %>% select(-costo_tx, -pct_prod, -val_neto, -Part_salon, -Modificado)
Data_Alianza <- Data %>% select(-val_prod, -Tipo, -pct_prod, -val_neto, -Part_salon,  -Modificado)

# Concidicional Para val_prod
Data_Tocador$val_prod <- ifelse(Data_Tocador$Tipo == "Colorimetria", 
                                Data_Tocador$val_prod, 0)
Data_Tocador <- Data_Tocador %>% select(-Tipo)

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

rm(header_style,datos_trabajador, Data_Alianza, Data_Spa, Data_Tocador,
   base_datos, accounting_style, wb)
rm(yellow_row_style)
rm(alianza, trabajador, suma_negativos, suma_positivos, ruta_archivo, 
   tocador, spa, revisar, nombre_carpeta, fila, filas_negativas, 
   col_index, cadena_carpeta, monto_min)

