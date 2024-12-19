#===============================================================================
# Limpiar el entorno
#rm(list = ls())
#===============================================================================
#source("0. Nomina/APP/1. Cargar la Base.R")
#source("0. Nomina/APP/2. Nombre del Archivo Base.R")
#source("0. Nomina/APP/3. Agregar y Eliminar la Base.R")
#source("0. Nomina/APP/4. Generar la Base de Descuentos.R")
#source("0. Nomina/APP/5. Clasificacion Tipo de Servicio.R")
#source("0. Nomina/APP/6. Generar la Base de Color.R")
#source("0. Nomina/APP/7. Manejo Partícipes.R")
#source("0. Nomina/APP/8. Costos de transacción.R")
#source("0. Nomina/APP/9. Participación Producto.R")
#source("0. Nomina/APP/10. Completar Base con Color.R")
#source("0. Nomina/APP/11. Porcentaje de los Profesionales.R")
#source("0. Nomina/APP/12. Participación Salón.R")
#===============================================================================
# Manejo de Descuentos - Profesionales
#===============================================================================

Data$Modificado <- ifelse(is.na(Data$Modificado), 0, Data$Modificado)

companeros <- c("producto hifu compañeros", "producto pestañas compañeros")

# Filtrar las filas que cumplen la condición
filas_a_duplicar <- Data[Data$`Servicio/Producto` %in% companeros, ]

# Modificar la columna "Modificado" en las filas duplicadas
filas_a_duplicar$Modificado <- 1

# Combinar las filas originales con las duplicadas
Data <- rbind(Data, filas_a_duplicar)
rm(filas_a_duplicar)

# Condicional para que el Cliente se vuelva profesional
Data$`Prestador/Vendedor` <- ifelse(Data$`Nombre cliente` %in% Base_Profesionales & Data$Precio == 0, 
                                    Data$`Nombre cliente`,Data$`Prestador/Vendedor`)
Data$`Prestador/Vendedor` <- ifelse(Data$`Nombre cliente` %in% Base_Profesionales & Data$Modificado == 1, 
                                    Data$`Nombre cliente`,Data$`Prestador/Vendedor`)
Data$`Prestador/Vendedor` <- ifelse(Data$`Nombre cliente` %in% Base_Profesionales & is.na(Data$Modificado) &
                                      Data$`Servicio/Producto` %in% companeros, 
                                    "Nydia Gamba",Data$`Prestador/Vendedor`)

Data$`Prestador/Vendedor` <- ifelse(Data$Tipo == "Accesorios", 
                                    "Accesorios", Data$`Prestador/Vendedor`)
Data$`Prestador/Vendedor` <- ifelse(Data$Tipo == "Maquillaje", 
                                    "Lina", Data$`Prestador/Vendedor`)

Data$Modificado <- ifelse(is.na(Data$Modificado), 0, Data$Modificado)

# Condicional para que el precio pase de ser 0 al Precio de Lista
Data$Precio <- ifelse(Data$`Nombre cliente` %in% Base_Profesionales & Data$Precio == 0,
                      Data$`Precio de Lista`,Data$Precio)

# Condicional para cambiar el nombre del cliente por la descripción del descuento
Data$`Nombre cliente` <- ifelse(Data$`Nombre cliente` %in% Base_Profesionales & 
                                Data$Precio == Data$`Precio de Lista` & 
                                !(Data$`Servicio/Producto` %in% companeros),
                                "Ajuste de Producto" ,Data$`Nombre cliente`)


Data$`Nombre cliente` <- ifelse(Data$`Nombre cliente` %in% Base_Profesionales & 
                                Data$`Servicio/Producto` %in% companeros & 
                                Data$Modificado == 1,
                                "Ajuste de Producto" ,Data$`Nombre cliente`)

# Descuentos por Area
Des_Alianza <- 1
Des_Spa <- 0.26
Des_Bac <- 0.25
Des_Tocador <- 0
Des_Depilacion <- 0.15
Des_Venta <- 0.08
Des_Color <- 0
Des_TermoCut <- 0.10

Data$Part_profesional <- ifelse(Data$`Nombre cliente` == "Ajuste de Producto",
                                ifelse(Data$Tipo == "Alianza", -Data$Precio * Des_Alianza,
                                       ifelse(Data$Tipo == "Spa", -Data$Precio * Des_Spa,
                                              ifelse(Data$Tipo == "Bac", -Data$Precio * Des_Bac, 
                                                     ifelse(Data$Tipo == "Tocador", -Producto_tocador,
                                ifelse(Data$Tipo == "Depilacion", -Data$Precio * Des_Depilacion,
                                ifelse(Data$Tipo == "Venta", -Data$Precio * Des_Venta,
                                ifelse(Data$Tipo == "Colorimetria", -Data$Precio - Data$pct_prod,
                                ifelse(Data$Tipo == "Queratina", -Data$Precio - Data$pct_prod,
                                ifelse(Data$Tipo == "TermoCut", -Data$Precio * Des_TermoCut, 
                                       Data$Part_profesional))))))))),
                                Data$Part_profesional)

# Verificar
#Nuevo <- Data %>% filter(`Nombre cliente` == "Ajuste de Producto")

Data$Part_salon <- ifelse(Data$`Prestador/Vendedor` %in% Base_Profesionales & Data$Modificado == 1 &
                          Data$`Servicio/Producto` %in% companeros, 0, Data$Part_salon)

