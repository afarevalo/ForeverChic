#===============================================================================

# Librerias del Proyecto
library(readxl)
library(dplyr)

#===============================================================================

# Cargar los Datos
# Reporte de ventas
Reporte <- read_excel("~/GitHub/Problem_Set_1/ForeverChic/Ventas Mensuales/reporte_de_ventas_Oct_1_15.xlsx", 
                                         sheet = "Produccion v2", range = "A2:BG318")
# Visualizar los Datos
View(Reporte)

# Lista de servicios por Tipo
Base_Tocador <- read_excel("Info.xlsx", sheet = "1. Tocador")
Base_Spa <- read_excel("Info.xlsx", sheet = "2. Spa")
Base_Depilacion <- read_excel("Info.xlsx", sheet = "3. Depilacion")
Base_Bac <- read_excel("Info.xlsx", sheet = "4. Bac")
Base_Colorimetria <- read_excel("Info.xlsx", sheet = "5. Colorimetria")
Base_Venta <- read_excel("Info.xlsx", sheet = "6. Venta")
Base_Maquillaje <- read_excel("Info.xlsx", sheet = "7. Maquillaje")

#===============================================================================

# Limpiar datos
Data <- Reporte %>% select("Fecha de Pago","Nombre cliente","Servicio/Producto",
                           "Prestador/Vendedor","Precio de Lista","Efectivo",
                           "Tarjeta de Crédito","Tarjeta de Débito","Otro",
                           "Nequi Carlos","Daviplata Carlos","Nequi Nambad",
                           "Daviplata Nambad","Bold")

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
                     NA))))))))

#===============================================================================

# Inicalización de la Variable Participación Transacción
Data$Participacion <- NA

#===============================================================================

# Inicalización de la Variable Participacion
Data$Participacion <- NA

# Condicional Para Agregar el % de Participación

Data$Participacion <- ifelse(Data$Tipo == "Alianza", 0.8, 
                        ifelse(Data$Tipo == "Tocador", 0.8))





