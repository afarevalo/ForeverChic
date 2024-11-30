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
  library(openxlsx)
  library(stringr)
  
  #===============================================================================
  
  # Cargar los Datos
  # Reporte de ventas
  # Ruta del archivo
  ruta_archivo <- "~/GitHub/Problem_Set_1/ForeverChic/1. Ventas Mensuales/2. reporte_de_ventas_NOV_16_25.xlsx"
  
  # Leer el archivo
  Reporte <- read_excel(ruta_archivo, sheet = "Produccion v2")
  
  colnames(Reporte) <- Reporte[1, ]
  Reporte <- Reporte[-c(1:1),]
  rownames(Reporte) <- NULL
  
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
  
  # Lista de Descuentos 
  Descuentos <- read_excel("~/GitHub/Problem_Set_1/ForeverChic/2. Descuentos/2. NOV_16_25.xlsx")
  
  #===============================================================================
  
  # Limpiar datos
  Data <- Reporte %>% select("Identificador","Fecha de Pago","Nombre cliente",
                             "Servicio/Producto","Prestador/Vendedor","Precio de Lista",
                             "Precio","Descuento","Efectivo","Tarjeta de Crédito",
                             "Tarjeta de Débito","Cheque","Otro","Giftcard",
                             "Transferencia Bancaria","Nequi Carlos","Daviplata Carlos",
                             "Nequi Nambad","Daviplata Nambad","Bold")
  
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
  nombre_original <- tools::file_path_sans_ext(basename(ruta_archivo))
  
  # Crear el nombre del archivo de salida añadiendo " - Color" al nombre original
  nombre_archivo_salida <- paste0(nombre_original, " - Color.xlsx")
  
  # Escribir el archivo con el nuevo nombre en la carpeta destino
  write_xlsx(Data_Color, file.path("C:/Users/windows/Documents/GitHub/Problem_Set_1/ForeverChic/1. Ventas Mensuales", nombre_archivo_salida))
  
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
  
  #===============================================================================
  # ***************************** Verificar la Data ***************************** 
  #===============================================================================
  
  # Manejor Servicio de los Socios
  
  Data$`Nombre cliente` <- ifelse(Data$`Nombre cliente`== "Andres Arevalo" & Data$Precio == 0,
                                  "Carlitos Arevalo",Data$`Nombre cliente` )
  
  Data$`Nombre cliente` <- ifelse(Data$`Nombre cliente`== "Elsa Arevalo" & Data$Precio == 0,
                                  "Carlitos Arevalo",Data$`Nombre cliente` )
  
  # Concicional Para recalificar a los socios
  Data$Precio <- ifelse(
                        (Data$`Nombre cliente` %in% c("Carlitos Arevalo", 
                        "Sandra Mogollon", "Sandra Mogollón", "Carlos Arévalo")) & 
                        Data$Precio == 0, Data$`Precio de Lista`, Data$Precio
                        )
  
  #===============================================================================
  
  # Vector con los nombres de las columnas que deseas convertir
  columnas_a_convertir <- c( "Efectivo", "Otro", "Giftcard", "Nequi Carlos", 
                             "Daviplata Carlos", "Nequi Nambad", "Daviplata Nambad",
                             "Tarjeta de Crédito", "Tarjeta de Débito", "Cheque",
                             "Transferencia Bancaria", "Bold", "Precio",
                             "Precio de Lista")
  
  # Convertir las columnas seleccionadas a numéricas y reemplazar NA por 0
  Data[columnas_a_convertir] <- lapply(Data[columnas_a_convertir], function(columna) {
    as.numeric(replace(columna, is.na(columna), 0))
  })
  
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
  Data <- Data %>% select(-Descuento, -Efectivo, -Otro, -Giftcard, -`Nequi Carlos`,
                          -`Daviplata Carlos`, -`Tarjeta de Crédito`, -`Tarjeta de Débito`
                          , -Cheque, -`Transferencia Bancaria`, -Bold)
  
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
  Parte_Maquillaje_Lina <- 0.58
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
                                  Data$Precio * Parte_Maquillaje_S - Data$Valor_producto, 
                            ifelse(Data$Tipo == "Maquillaje" & Data$Precio > 0, Data$Valor_Neto * Parte_Maquillaje_Lina, 
                            ifelse(Data$Tipo == "Accesorios" & Data$Precio > 0, Data$Valor_Neto, NA))))))))))))
  
  # Manejo Corte y Limpieza Termocut
  Parte_Maquillaje_S <- 0.45
  
  # Condicional para arreglar el %
  Data$Part_profesional <- ifelse(
                                  (Data$`Servicio/Producto` %in% c("Promoción Corte y Limpieza termocut", 
                                  "Corte y Limpieza termocut","Limpieza termocut( No Incluye Corte Diseñado)")), 
                                  Data$Precio * 0.45, Data$Part_profesional
                                  )
  
  # Correción Para las Queratinas 
  # Inicializar el valor de Parte_Color
  Parte_Color <- 0.55
  
  # Verificar si se cumple la condición para duplicar observaciones
  if ("Queratina caballero - Desde" %in% Data$`Servicio/Producto`) {
    # Identificar las filas donde se cumple la condición
    filas_a_duplicar <- which(Data$`Servicio/Producto` == "Queratina caballero - Desde")
    
    # Crear las nuevas filas basadas en las filas identificadas
    nuevas_filas <- Data[filas_a_duplicar, ] # Duplicar las filas originales
    nuevas_filas$`Prestador/Vendedor` <- "Marinela Olaya" # Cambiar el prestador/vendedor
    nuevas_filas$Part_profesional <- 20000 # Asignar el nuevo valor a Part_profesional
    
    # Actualizar las filas originales en Data
    Data$Part_profesional[filas_a_duplicar] <- 
      (Data$Precio[filas_a_duplicar] - Data$Valor_producto[filas_a_duplicar] - 20000) * Parte_Color
    
    # Agregar las nuevas filas a Data
    Data <- rbind(Data, nuevas_filas)
  }
  
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
                              ifelse(Data$Tipo == "Tocador", -Producto_tocador,
                              ifelse(Data$Tipo == "Depilacion", -Data$Precio * Des_Depilacion,
                              ifelse(Data$Tipo == "Venta", -Data$Precio * Des_Venta,
                              ifelse(Data$Tipo == "Color", -Data$Precio * Des_Color, Data$Part_profesional)))))))
                            ,Data$Part_profesional)
  # Verificar
  # Nuevo <- Data %>% filter(`Nombre cliente` == "Ajuste de Producto")
  
  #===============================================================================
  
  # Crear la carpeta de Resultados
  nombre_carpeta <- paste0(nombre_original, " - NOMINA")
  dir.create(file.path("C:/Users/windows/Documents/GitHub/Problem_Set_1/ForeverChic/3. Resultados", nombre_carpeta))
  
  #===============================================================================
  
  # Nueva variable para asegurar la revisión
  Data$Revisar <- NA
  Data$Revisar <- ifelse(Data$Part_profesional == "Revisar", "Revisar", NA)
  
  # Corregir el formato de la variable Part_profesional
  Data$Part_profesional <- ifelse(Data$Part_profesional == "Revisar", 0, Data$Part_profesional)
  Data$Part_profesional <-as.numeric(Data$Part_profesional)
  
  # Eliminar las columnas especificadas de la base de datos Data
  Data <- Data %>% select(-Identificador,-`Part_salon`)
  
  # Reescribe los NAs de los profesionales
  Data$`Prestador/Vendedor` <- ifelse(is.na(Data$`Prestador/Vendedor`), "Revisar", Data$`Prestador/Vendedor`)
  
  #===============================================================================
  # Incluir los Descuentos
  #===============================================================================
  
  Descuentos <- Descuentos %>%
    mutate(
      Tipo_Concepto = apply(
        select(., Tipo, Concepto, Observación), 
        1, 
        function(fila) paste(na.omit(fila), collapse = " - ")
      )
    )
  
  # Descuentos de los profesionales
  Descuentos$Valor <- ifelse(Descuentos$Profesional == "Ines Torres" & 
                             Descuentos$Tipo == "Apoyo", Descuentos$Valor,
                             Descuentos$Valor * (-1))
  
  # Cambiar nombre de las variabes para usar Full join
  Descuentos <- Descuentos %>% rename(`Fecha de Pago` = Fecha)
  Descuentos <- Descuentos %>% rename(`Prestador/Vendedor` = Profesional)
  Descuentos <- Descuentos %>% rename(`Servicio/Producto` = Tipo_Concepto)
  Descuentos <- Descuentos %>% rename(`Part_profesional` = Valor)
  str(Descuentos$`Fecha de Pago`)
  # Elminina la variable
  Descuentos <- Descuentos %>% select(-Concepto, -Observación)
  
  # Cambia el formato de la Fecha para usar Full join
  Descuentos$`Fecha de Pago` <- as.character(Descuentos$`Fecha de Pago`)
  
  # Convertir la columna 'Fecha de Pago' al formato DD/MM/AAAA y mantenerla como chr
  Descuentos <- Descuentos %>%
    mutate(`Fecha de Pago` = format(as.Date(`Fecha de Pago`, format = "%Y-%m-%d"), "%d/%m/%Y"))
  
  #===============================================================================
  
  # Condicional para no cobrarle a Ines Torres
  Data$Part_profesional <- ifelse(Data$`Nombre cliente` == "Ajuste de Producto" & 
                                  Data$`Prestador/Vendedor` == "Ines Torres", 0, 
                                  Data$Part_profesional)
  
  #===============================================================================
  
  # Unir las base de datos
  Data <- full_join(Data, Descuentos)
  
  #===============================================================================
  
  # Descuento de Nequi y DaviPlata de Nydia - Alianza
  # Filtrar las filas donde "Nequi Nambad" o "Daviplata Nambad" son mayores a 0
  filas_a_duplicar <- Data %>% 
    filter(`Nequi Nambad` > 0 | `Daviplata Nambad` > 0)
  
  # Crear las nuevas filas con las modificaciones requeridas
  nuevas_filas <- filas_a_duplicar %>%
    mutate(
      `Nombre cliente` = "Pago Anticipado", # Cambiar "Tipo" a "Pago Anticipado"
      Part_profesional = -1 * (`Nequi Nambad` + `Daviplata Nambad`) # Calcular "Part_profesional"
    )
  
  # Añadir las nuevas filas a la base de datos original
  Data <- bind_rows(Data, nuevas_filas)
  
  #===============================================================================
  
  # Elimina las columnas de Nequi Y Daiplata Nydia - Alianza
  Data <- Data %>% select(-`Nequi Nambad`, -`Daviplata Nambad`, -`Precio de Lista`, -`Dummy_trans`)
  
  #===============================================================================
  # Descargar los soportes de Pago por Profesional
  #===============================================================================
  
  # Filtrar y ajustar las columnas según el tipo de profesional
  Data_Spa <- Data %>% select(-`Cost_trans`, -Valor_producto, -Tipo , -`Porc_trans`, -Porc_producto, -Valor_Neto, -Revisar)
  Data_Tocador <- Data %>% select(-`Cost_trans`, -`Porc_trans`, -Porc_producto, -Valor_Neto, -Revisar)
  Data_Alianza <- Data %>% select(-`Valor_producto`, -Tipo , -`Porc_trans`, -Porc_producto, -Valor_Neto, -Revisar)
  
  # Concidicional Para Valor_producto
  
  Data_Tocador$Valor_producto <- ifelse(Data_Tocador$Tipo == "Colorimetria", 
                                        Data_Tocador$Valor_producto, 0)
  Data_Tocador <- Data %>% select(-Tipo)
  
  # Vectores de profesionales
  tocador <- c("Beto Garcia", "Elvis Molina", "Nataly Caro", "Olga Arango", "Marinela Olaya")
  alianza <- c("Nydia Gamba", "Accesorios", "Lina")
  spa <- c("Ivonne Mancipe", "Paola Pinzon", "Johana Quimbay", "Johana Matute", "Ines Torres")
  revisar <- c("Revisar")
  
  # Crear la carpeta de resultados (si no existe)
  ruta_resultados <- file.path("C:/Users/windows/Documents/GitHub/Problem_Set_1/ForeverChic/3. Resultados", nombre_carpeta)
  dir.create(ruta_resultados, recursive = TRUE, showWarnings = FALSE)
  
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
    
    # Identificar filas con valores negativos en "Part_profesional"
    filas_negativas <- which(datos_trabajador$Part_profesional < 0)
    
    # Pintar las celdas de amarillo para filas con valores negativos
    if (length(filas_negativas) > 0) {
      yellow_style <- createStyle(fgFill = "#FFFF00")
      addStyle(
        wb, 
        sheet = "Datos", 
        style = yellow_style, 
        rows = filas_negativas + 1, # +1 porque la primera fila son los encabezados
        cols = 1:ncol(datos_trabajador), 
        gridExpand = TRUE
      )
    }
    
    # Definir la ruta de guardado del archivo Excel
    ruta_archivo <- file.path(ruta_resultados, paste0(trabajador, ".xlsx"))
    
    # Guardar el archivo
    saveWorkbook(wb, ruta_archivo, overwrite = TRUE)
    
    # Mensaje de confirmación
    cat("Archivo guardado para:", trabajador, "en", ruta_archivo, "\n")
  }
  
  #===============================================================================
  # Armar Consolidado
  Data$Porcentaje <- ifelse(is.na(Data$`Nombre cliente`)== FALSE & Data$Part_profesional > 0, 
                            Data$Part_profesional/Data$Precio, NA)
  
  Data <- Data %>% select(-Revisar)
  
  #===============================================================================
  # Reporte Final
  #===============================================================================
  
  # Crear el reporte agrupando por trabajador y sumando la variable "Part_profesional"
  reporte <- Data %>%
    group_by(`Prestador/Vendedor`) %>%
    summarise(Total_a_pagar = sum(Part_profesional, na.rm = TRUE)) %>%
    arrange(desc(Total_a_pagar)) # Ordenar por el total a pagar de mayor a menor
  
  # Calcular el total de nómina
  total_nomina <- sum(reporte$Total_a_pagar)
  
  # Imprimir el reporte en la consola
  cat("Reporte de Nómina\n")
  cat("=================\n")
  for (i in 1:nrow(reporte)) {
    cat(
      paste0(
        "- ", reporte$`Prestador/Vendedor`[i], 
        ": Se le debe pagar ", 
        formatC(reporte$Total_a_pagar[i], format = "f", big.mark = ",", digits = 2), "\n"
      )
    )
  }
  cat("=================\n")
  cat(paste0("En total de nómina se deben pagar: ", 
             formatC(total_nomina, format = "f", big.mark = ",", digits = 2), "\n"))
  
  #===============================================================================
  
  # Filtrar los datos de "Marinela Olaya"
  datos_marinela <- Data %>% filter(`Prestador/Vendedor` == "Marinela Olaya")
  
  # Sumar los valores positivos de "Part_profesional"
  suma_positivos <- sum(datos_marinela$Part_profesional[datos_marinela$Part_profesional > 0], na.rm = TRUE)
  
  # Sumar los valores negativos de "Part_profesional"
  suma_negativos <- sum(datos_marinela$Part_profesional[datos_marinela$Part_profesional < 0], na.rm = TRUE)
  
  apoyo_economico <- 0
  
  # Condicional según el valor de los positivos
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
    
    # Recalcular el total de nómina considerando el ajuste para Marinela Olaya
    suma_mari <- sum(datos_marinela$Part_profesional)  
    total_nomina <- sum(Data$Part_profesional, na.rm = TRUE) + total_pagar_marinela - suma_mari
    
    cat("- En total de nómina se deben pagar: ", 
        formatC(total_nomina, format = "f", big.mark = ",", digits = 2), ".\n")
  }
  
  #===============================================================================
  
  # Verificar si apoyo_economico es mayor que 0
  if (apoyo_economico > 0) {
    # Crear una nueva fila con los nombres exactos de las columnas
    nueva_fila <- Data[1, ]  # Copiar la estructura de la base de datos
    nueva_fila[] <- NA  # Limpiar los valores
    
    # Asignar los valores deseados a las columnas específicas
    nueva_fila$`Prestador/Vendedor` <- "Marinela Olaya"
    nueva_fila$Part_profesional <- apoyo_economico
    nueva_fila$`Servicio/Producto` <- "Apoyo Económico"

    # Agregar la nueva fila a la base de datos
    Data <- bind_rows(Data, nueva_fila)
  }
  
  #===============================================================================
  
  # Exportar Data del Consolidado
  write_xlsx(Data, file.path("C:/Users/windows/Documents/GitHub/Problem_Set_1/ForeverChic/3. Resultados", 
                             nombre_carpeta, "0. Consolidado.xlsx"))

  #===============================================================================
  
  Data_marinela <- Data %>% filter(`Prestador/Vendedor` == "Marinela Olaya")
  Data_marinela <- Data_marinela %>% select(-"Prestador/Vendedor", -Tipo, -Porc_trans, -Cost_trans,
                          -Porc_producto, -Valor_producto, -Valor_Neto, -Porcentaje)

  
  # Verificar la condición de apoyo_economico
  if (apoyo_economico > 0) {
    # Crear y configurar el archivo Excel
    wb <- createWorkbook()
    addWorksheet(wb, "Marinela Olaya")
    writeData(wb, "Marinela Olaya", Data_marinela)
    
    # Crear estilo amarillo
    estilo_amarillo <- createStyle(fgFill = "#FFFF00")
    
    # Aplicar estilo a las filas donde Part_profesional es negativo
    filas_amarillas <- which(Data_marinela$Part_profesional < 0)
    if (length(filas_amarillas) > 0) {
      addStyle(wb, "Marinela Olaya", style = estilo_amarillo, 
               rows = filas_amarillas + 1, cols = 1:ncol(Data_marinela), gridExpand = TRUE)
    }
    
    # Guardar el archivo
    saveWorkbook(wb, file.path("C:/Users/windows/Documents/GitHub/Problem_Set_1/ForeverChic/3. Resultados", 
                               nombre_carpeta, "Marinela Olaya.xlsx"), overwrite = TRUE)
    
    cat("Archivo Excel exportado correctamente.\n")
  } else {
    cat("No se ejecutó el código porque apoyo_economico es menor o igual a 0.\n")
  }
  