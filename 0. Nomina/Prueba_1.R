#===============================================================================
# Nomina Version 1.0
#===============================================================================

# Limpiar el entorno
rm(list = ls())

#===============================================================================

# Librerias del Proyecto
library(readxl)
library(dplyr)
library(writexl)
library(rio)

#===============================================================================

# Cargar los Datos
# Reporte de ventas
archivo_original <- "~/GitHub/Problem_Set_1/ForeverChic/1. Ventas Mensuales/1. reporte_de_ventas_OCT_1_15.xlsx"
Reporte <- read_excel(archivo_original, sheet = "Produccion v2", range = "A2:BG318")

# Visualizar los Datos
# View(Reporte)

# Lista de servicios por Tipo
Base_Tocador <- read_excel("Info.xlsx", sheet = "1. Tocador")
Base_Spa <- read_excel("Info.xlsx", sheet = "2. Spa")
Base_Depilacion <- read_excel("Info.xlsx", sheet = "3. Depilacion")
Base_Bac <- read_excel("Info.xlsx", sheet = "4. Bac")
Base_Colorimetria <- read_excel("Info.xlsx", sheet = "5. Colorimetria")
Base_Venta <- read_excel("Info.xlsx", sheet = "6. Venta")
Base_Maquillaje <- read_excel("Info.xlsx", sheet = "7. Maquillaje")
Base_Maquillaje_Salon <- read_excel("Info.xlsx", sheet = "8. Maquillaje Salon")
Base_Accesorios <- read_excel("Info.xlsx", sheet = "9. Accesorios")

# Lista de Profesionales
Base_Profesionales <- read_excel("Info.xlsx", sheet = "0. Profesionales")

#===============================================================================

# Limpiar datos
Data <- Reporte %>% select("Identificador","Fecha de Pago","Nombre cliente","Servicio/Producto",
                           "Prestador/Vendedor","Precio de Lista","Precio","Descuento","Efectivo",
                           "Tarjeta de Crédito","Tarjeta de Débito","Cheque","Otro",
                           "Giftcard","Transferencia Bancaria","Nequi Carlos","Daviplata Carlos","Nequi Nambad",
                           "Daviplata Nambad","Bold")

# Eliminar espacios múltiples
Data$`Nombre cliente` <- gsub("\\s+", " ", Data$`Nombre cliente`)
Data$`Prestador/Vendedor` <- gsub("\\s+", " ", Data$`Prestador/Vendedor`)

# Eliminar espacios al inicio y al final, si los hubiera
Data$`Nombre cliente` <- trimws(Data$`Nombre cliente`)
Data$`Prestador/Vendedor` <- trimws(Data$`Prestador/Vendedor`)

#===============================================================================

# Inicalización de la Variable Tipo
Data$Tipo <- NA

# Condicional Para Clasificar el Tipo de Servicio
Data$Tipo <- ifelse(Data$`Prestador/Vendedor` == "Nydia Gamba", "Alianza",
              ifelse(Data$`Servicio/Producto` %in% Base_Tocador[[1]], "Tocador",
              ifelse(Data$`Servicio/Producto` %in% Base_Spa[[1]], "Spa",
              ifelse(Data$`Servicio/Producto` %in% Base_Depilacion[[1]], "Depilacion",
              ifelse(Data$`Servicio/Producto` %in% Base_Bac[[1]], "Bac",
              ifelse(Data$`Servicio/Producto` %in% Base_Colorimetria[[1]], "Colorimetria",
              ifelse(Data$`Servicio/Producto` %in% Base_Venta[[1]], "Venta",
              ifelse(Data$`Servicio/Producto` %in% Base_Maquillaje[[1]], "Maquillaje",
              ifelse(Data$`Servicio/Producto` == "Propina desde", "Propina",
              ifelse(Data$`Servicio/Producto` %in% Base_Maquillaje_Salon[[1]], "Maquillaje_S",
              ifelse(Data$`Servicio/Producto` %in% Base_Accesorios[[1]], "Accesorios",
                     NA)))))))))))

#===============================================================================
# Base de Color
#===============================================================================

# Limpiar datos
Data_Color <- Data %>% select("Identificador","Fecha de Pago","Prestador/Vendedor","Nombre cliente","Servicio/Producto",
                         ,"Precio de Lista","Precio", "Tipo")

# Filtrar las filas donde Part_profesional es "Descuento"
Data_Color <- Data_Color %>% filter(Tipo == "Colorimetria")

# Inicalización de la Variable Valor Producto
Data_Color$Valor_producto <- NA

# Obtener el nombre del archivo original sin la ruta ni la extensión
nombre_original <- tools::file_path_sans_ext(basename(archivo_original))

# Crear el nombre del archivo de salida añadiendo " - Color" al nombre original
nombre_archivo_salida <- paste0(nombre_original, " - Color.xlsx")

# Escribir el archivo con el nuevo nombre en la carpeta destino
#write_xlsx(Data_Color, file.path("C:/Users/windows/Documents/GitHub/Problem_Set_1/ForeverChic/1. Ventas Mensuales", nombre_archivo_salida))

#===============================================================================

# Manejo del directorio
getwd()
directorio <- "C:/Users/windows/Documents/GitHub/Problem_Set_1/ForeverChic/1. Ventas Mensuales"
setwd(directorio)

# Chequeo de los archivos del directorio
dir()
list.files()

# Importacion de los datos
install_formats() # Cuestiones de importacion de archivos del paquete rio
Data_Color <- import(nombre_archivo_salida)

#View(Data_Color)

#===============================================================================
# ***************************** Verificar la Data ***************************** 
#===============================================================================

# Manejor Servicio de los Socios
# Concicional Para recalificar a los socios
Data$Precio <- ifelse(
                      (Data$`Nombre cliente` %in% c("Carlitos Arevalo", 
                      "Sandra Mogollon", "Sandra Mogollón", "Carlos Arévalo")) & 
                      Data$Precio == 0, Data$`Precio de Lista`, Data$Precio
                      )

#===============================================================================

# Inicalización de la Variable Porcentaje de Transacción
Data$Dummy_trans <- NA

# Calcular la suma de las primeras variables y las segundas variables
suma_grupo1 <- rowSums(Data[, c("Efectivo", "Otro", "Giftcard", "Nequi Carlos", 
                                "Daviplata Carlos", "Nequi Nambad", "Daviplata Nambad")], na.rm = TRUE)
suma_grupo2 <- rowSums(Data[, c("Tarjeta de Crédito", "Tarjeta de Débito", "Cheque", 
                                "Transferencia Bancaria", "Bold")], na.rm = TRUE)

# Condicional para Asignar la dummy del % de Transacción
Data$Dummy_trans <- ifelse(suma_grupo2 >= 2, 1,
                    ifelse(suma_grupo1 >= 1, 0, NA))

#===============================================================================

# Eliminar las columnas especificadas de la base de datos Data
Data <- Data %>% select(-Descuento, -Efectivo, -Otro, -Giftcard, 
                        -`Nequi Carlos`, -`Daviplata Carlos`, -`Nequi Nambad`, 
                        -`Daviplata Nambad`, -`Tarjeta de Crédito`, 
                        -`Tarjeta de Débito`, -Cheque, -`Transferencia Bancaria`, 
                        -Bold)

#===============================================================================

# Rellenar los valores NA en Dummy_trans utilizando el valor existente del mismo Identificador
Data <- Data %>%
  group_by(Identificador) %>%
  mutate(Dummy_trans = ifelse(is.na(Dummy_trans), max(Dummy_trans, na.rm = TRUE), Dummy_trans)) %>%
  ungroup()

#===============================================================================

# Inicalización de la Variable % del Costo de la Transacción
Data$Porc_trans <- NA

# Condicional Para Agregar el % del Costo de la Transacción

Data$Porc_trans <- ifelse(Data$`Prestador/Vendedor` == "Nydia Gamba" 
                         & Data$Dummy_trans == 1, 0.07, 
                         ifelse(Data$Dummy_trans == 0, 0, 0.036))

#===============================================================================

# Inicalización de la Variable Costo de la Transacción
Data$Cost_trans <- NA

# Calculo del Costo de la Transacción
Data$Cost_trans <- Data$Precio * Data$Porc_trans

#===============================================================================

# Inicalización de la Variable % de Participación Producto
Data$Porc_producto <- NA
Producto_tocador <- 4081

# Condicional Para Agregar % de Participación Producto
Data$Porc_producto <- ifelse(Data$Tipo == "Spa", 0.26,
                        ifelse(Data$Tipo == "Bac", 0.25,
                        ifelse(Data$Tipo == "Depilacion", 0.15, 
                        ifelse(Data$Tipo == "Maquillaje", 0,
                        ifelse(Data$Tipo == "Alianza", 0,
                        ifelse(Data$Tipo == "Tocador" & Data$Precio > 0, 
                               Producto_tocador/Data$Precio,
                        ifelse(Data$Tipo == "Tocador" & Data$Precio == 0,
                               Producto_tocador/Data$`Precio de Lista`,
                        ifelse(Data$Tipo == "Venta", 0.56, 
                        ifelse(Data$Tipo == "Maquillaje_S", 0, NA)))))))))

#===============================================================================

# Inicalización de la Variable Valor Producto
Data$Valor_producto <- NA

# Condicional
Data$Valor_producto <- ifelse(Data$Precio > 0, Data$Porc_producto * Data$Precio, 
                        ifelse(Data$Precio == 0, Data$Porc_producto * Data$`Precio de Lista`,
                               NA)) 

#===============================================================================

# Completar Data con la información de Colorimetria

# Realizar un left join para combinar Data con Data_Color usando "Identificador" y "Servicio/Producto"
Data_actualizada <- Data %>%
  left_join(Data_Color %>% select(Identificador, Tipo, `Servicio/Producto`, Valor_producto), 
            by = c("Identificador", "Servicio/Producto"), suffix = c("", "_color"))

# Rellenar los valores faltantes de "Valor_producto" solo donde "Tipo" es "Colorimetria"
Data_actualizada <- Data_actualizada %>%
  mutate(Valor_producto = ifelse(is.na(Valor_producto) & Tipo == "Colorimetria" & Tipo_color == "Colorimetria", 
                                 Valor_producto_color, Valor_producto)) %>%
  select(-Tipo_color, -Valor_producto_color)  # Eliminar las columnas auxiliares

# Asignar la base de datos actualizada a "Data" si se desea
Data <- Data_actualizada

Data$Porc_producto <- ifelse(Data$Tipo == "Colorimetria",Data$Valor_producto/Data$Precio,Data$Porc_producto)

#===============================================================================

# Inicalización de la Variable Valor Neto
Data$Valor_Neto <- NA

# Reemplazar NA en Valor_producto con 0 para evitar problemas en la operación
Data$Valor_producto <- ifelse(is.na(Data$Valor_producto), 0, Data$Valor_producto)

# Condicional para Calcular la variable Valor_Neto con las condiciones requeridas
Data$Valor_Neto <- ifelse(Data$Tipo == "Propina", Data$Precio - Data$Cost_trans,
                    ifelse(Data$Precio > 0, Data$Precio - Data$Valor_producto - Data$Cost_trans,
                    ifelse(Data$Precio == 0, 0, NA)))

#===============================================================================

# Inicalización de la Variable Participación Profesional
Data$Part_profesional <- NA

# Inicalización Porcentajes de Profesionales
Parte_Alianza <- 0.8
Parte_Spa <- 0.45
Parte_Bac <- 0.4
Parte_Tocador <- 0.55
Parte_Depilacion <- 0.6
Parte_Venta <- 0.08
Parte_Color <- 0.55
Parte_Maquillaje_S <- 0.58

#Condicional
# Crear la variable Part_profesional en Data con los valores requeridos
Data$Part_profesional <- ifelse(Data$`Nombre cliente` %in% Base_Profesionales$Profesional, "Descuento", 
                          ifelse(Data$Tipo == "Alianza" & Data$Precio > 0, Data$Valor_Neto *  Parte_Alianza, 
                          ifelse(Data$Tipo == "Spa" & Data$Precio > 0, Data$Precio * Parte_Spa, 
                          ifelse(Data$Tipo == "Bac" & Data$Precio > 0, Data$Precio * Parte_Bac, 
                          ifelse(Data$Tipo == "Tocador" & Data$Precio > 0, Data$Precio * Parte_Tocador,
                          ifelse(Data$Tipo == "Depilacion" & Data$Precio > 0, Data$Valor_Neto * Parte_Depilacion,
                          ifelse(Data$Tipo == "Venta" & Data$Precio > 0, Data$Precio * Parte_Venta, 
                          ifelse(Data$Tipo == "Propina" & Data$Precio > 0, Data$Valor_Neto, 
                          ifelse(Data$Tipo == "Colorimetria" & Data$Precio > 0, 
                                Data$Precio * Parte_Color - Data$Valor_producto, 
                          ifelse(Data$Tipo == "Maquillaje_S" & Data$Precio > 0, 
                                Data$Precio * Parte_Maquillaje_S - Data$Valor_producto, NA))))))))))

# Manejo Corte y Limpieza Termocut
Parte_Maquillaje_S <- 0.45

# Condicional para arreglar el %
Data$Part_profesional <- ifelse(
                                (Data$`Servicio/Producto` %in% c("Promoción Corte y Limpieza termocut", 
                                "Corte y Limpieza termocut")), Data$Precio * 0.45, Data$Part_profesional
)

# Condicional para revisar errores
Data$Part_profesional <- ifelse(is.na(Data$Tipo), "Revisar", Data$Part_profesional)
  
# Reemplazar NA en Part_profesional con 0 para evitar problemas en la operación
Data$Part_profesional <- ifelse(is.na(Data$Part_profesional), 0, Data$Part_profesional)

#===============================================================================

# Inicalización de la Variable Participación Salón
Data$Part_salon <- NA

# Condicional
# Convertir los valores no numéricos en NA y sumar solo los valores numéricos
Data$Part_salon <- ifelse(Data$Precio > 0,
                          Data$Precio - 
                            suppressWarnings(as.numeric(Data$Valor_producto)) - 
                            suppressWarnings(as.numeric(Data$Cost_trans)) - 
                            suppressWarnings(as.numeric(Data$Part_profesional)),
                          NA)

#===============================================================================
# Manejo de Descuentos - Profesionales
#===============================================================================

# Condicional para que el Cliente se vuelva profesional
Data$`Prestador/Vendedor` <- ifelse(Data$Part_profesional == "Descuento", 
                                    Data$`Nombre cliente`,Data$`Prestador/Vendedor`)
Data$`Prestador/Vendedor` <- ifelse(Data$`Prestador/Vendedor` == 
                                    "Johanna Jinely Quimbay Perez", "Johana Quimbay", Data$`Prestador/Vendedor`)
Data$`Prestador/Vendedor` <- ifelse(Data$`Prestador/Vendedor` == 
                                      "Olga Arango Aristizábal", "Olga Arango", Data$`Prestador/Vendedor`)
Data$`Prestador/Vendedor` <- ifelse(Data$`Prestador/Vendedor` == 
                                      "Marinela Olaya Cifuentes", "Marinela Olaya", Data$`Prestador/Vendedor`)
Data$`Prestador/Vendedor` <- ifelse(Data$`Prestador/Vendedor` == 'Jose Vicente Molina" Elvis"', 
                                    "Elvis", Data$`Prestador/Vendedor`)
Data$`Prestador/Vendedor` <- ifelse(Data$Tipo == "Accesorios", 
                                    "Accesorios", Data$`Prestador/Vendedor`)
Data$`Prestador/Vendedor` <- ifelse(is.na(Data$`Prestador/Vendedor`), 
                                    "Revisar", Data$`Prestador/Vendedor`)
Data$`Prestador/Vendedor` <- ifelse(Data$Tipo == "Maquillaje", 
                                    "Lina", Data$`Prestador/Vendedor`)

# Condicional para que el precio pase de ser 0 al Precio de Lista
Data$Precio <- ifelse(Data$Part_profesional == "Descuento", Data$`Precio de Lista`,Data$Precio)

# Condicional para cambiar el nombre del cliente por la descripción del descuento
Data$`Nombre cliente` <- ifelse(Data$Part_profesional == "Descuento", "Ajuste de Producto" ,Data$`Nombre cliente`)

# Descuentos por Area
Des_Alianza <- 0
Des_Spa <- 0.26
Des_Bac <- 0.25
Des_Tocador <- 0
Des_Depilacion <- 0.15
Des_Venta <- 0.08
Des_Color <- 0

Data$Part_profesional <- ifelse(Data$Part_profesional == "Descuento",
                            ifelse(Data$Tipo == "Alianza", -Data$Precio * Des_Alianza,
                            ifelse(Data$Tipo == "Spa", -Data$Precio * Des_Spa,
                            ifelse(Data$Tipo == "Bac", -Data$Precio * Des_Bac, 
                            ifelse(Data$Tipo == "Tocador", -Data$Precio * Des_Tocador, # y LOS 4.800????
                            ifelse(Data$Tipo == "Depilacion", -Data$Precio * Des_Depilacion,
                            ifelse(Data$Tipo == "Venta", -Data$Precio * Des_Venta,
                            ifelse(Data$Tipo == "Color", -Data$Precio * Des_Color, Data$Part_profesional)))))))
                          ,Data$Part_profesional)
# Verificar
# Nuevo <- Data %>% filter(`Nombre cliente` == "Ajuste de Producto")

#===============================================================================

# Crear la carpeta de Resultados
nombre_carpeta <- paste0(nombre_original, " - NOMINA")
dir.create(file.path("C:/Users/windows/Documents/GitHub/Problem_Set_1/ForeverChic/2. Resultados", nombre_carpeta))

#===============================================================================

# Nueva variable para asegurar la revisión
Data$Revisar <- NA
Data$Revisar <- ifelse(Data$Part_profesional == "Revisar", "Revisar", NA)

# Corregir el formato de la variable Part_profesional
Data$Part_profesional <- ifelse(Data$Part_profesional == "Revisar", 0, Data$Part_profesional)
Data$Part_profesional <-as.numeric(Data$Part_profesional)

# Eliminar las columnas especificadas de la base de datos Data
Data <- Data %>% select(-Identificador,-`Part_salon`)

# Exportar Data
write_xlsx(Data, file.path("C:/Users/windows/Documents/GitHub/Problem_Set_1/ForeverChic/2. Resultados", nombre_carpeta, "0. Consolidado.xlsx"))

# Eliminar las columnas especificadas de la base de datos Data
Data <- Data %>% select(-`Precio de Lista`, -Tipo, -`Dummy_trans`, -`Porc_trans`)

# Verificar los profesionales
valores_unicos <- unique(Data$`Prestador/Vendedor`)
valores_unicos

# Crear la carpeta de resultados (si no existe)
ruta_resultados <- file.path("C:/Users/windows/Documents/GitHub/Problem_Set_1/ForeverChic/2. Resultados", nombre_carpeta)
dir.create(ruta_resultados, recursive = TRUE, showWarnings = FALSE)

# Iterar sobre cada trabajador para crear y guardar un archivo individual
for (trabajador in valores_unicos) {
  # Filtrar los datos para el trabajador actual
  datos_trabajador <- Data %>% filter(`Prestador/Vendedor` == trabajador)
  
  # Definir la ruta de guardado del archivo Excel con el nombre del trabajador
  ruta_archivo <- file.path(ruta_resultados, paste0(trabajador, ".xlsx"))
  
  # Exportar los datos filtrados a un archivo Excel
  write_xlsx(datos_trabajador, ruta_archivo)
}

write_xlsx(Data, ruta_archivo)


