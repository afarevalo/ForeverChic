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
#===============================================================================

# Inicalización de la Variable Porcentaje de Transacción
Data$indicador_costo <- NA

# Calcular la suma de las primeras variables y las segundas variables
suma_costo <- rowSums(Data[, c("Tarjeta de Crédito", "Tarjeta de Débito", "Cheque", 
                                "Transferencia Bancaria", "Bold")], na.rm = TRUE)

suma_efectivo <- rowSums(Data[, c("Efectivo", "Otro", "Gift card", "Nequi Carlos", 
                                "Daviplata Carlos", "Nequi Nambad", 
                                "Daviplata Nambad")], na.rm = TRUE)

# Condicional para Asignar la categoria del % de Transacción
# Variable categorica:
# 0 <- Pago solo en efectivo
# 1 <- Pago solo con tarjeta
# 2 <- Pago con ambos medios
Data$indicador_costo <- ifelse(suma_costo >= 10 & suma_efectivo >=10, 2, 
                               ifelse(suma_costo >= 2, 1, 
                                ifelse(suma_efectivo >= 10, 0, NA)))

#===============================================================================

# Rellenar los valores NA en indicador_costo utilizando el valor existente del mismo Identificador
Data <- Data %>%
  group_by(Identificador) %>%
  mutate(indicador_costo = ifelse(
    is.na(indicador_costo),
    ifelse(all(is.na(indicador_costo)), NA, max(indicador_costo, na.rm = TRUE)),
    indicador_costo
  )) %>%
  ungroup()

# Correccion de para profesionales y participes del Salon
Data$indicador_costo <- ifelse(Data$indicador_costo == "-Inf", 0, Data$indicador_costo)
Data$indicador_costo <- ifelse(is.na(Data$indicador_costo), 0, Data$indicador_costo)

#===============================================================================

# Cambiar los valores en Giftcard o Bono utilizando el valor existente del mismo Identificador
Data <- Data %>%
  group_by(Identificador) %>%
  mutate(`Gift card` = ifelse(any(`Gift card` == 1, na.rm = TRUE), 1, `Gift card`)) %>%
  ungroup()

# El precio sera modificado 
Data$Modificado <- ifelse(Data$`Gift card` == 1 & Data$Precio == 0, 1, Data$Modificado)
Data$Precio <- ifelse(Data$`Gift card` == 1 & Data$Precio == 0, Data$`Precio de Lista`, Data$Precio)

#===============================================================================

# Suma el pago en Tarjetas
Data$sum_tarjeta <- NA
Data <- Data %>% mutate(sum_tarjeta = Bold + `Tarjeta de Crédito` + `Tarjeta de Débito` + 
                          `Transferencia Bancaria` + Cheque)

# Eliminar las columnas especificadas de la base de datos Data
Data <- Data %>% select(-Descuento, -Efectivo, -Otro, -`Gift card`, -`Nequi Carlos`,
                        -`Daviplata Carlos`, -`Tarjeta de Crédito`, -`Tarjeta de Débito`,
                        -Cheque, -`Transferencia Bancaria`, -Bold)

#===============================================================================

# Inicalización de la Variable % del Costo de la Transacción
Data$pct_trans <- NA

# Condicional Para Agregar el % del Costo de la Transacción
Data$pct_trans <- ifelse(Data$indicador_costo == 1 & Data$`Prestador/Vendedor` == "Nydia Gamba", 0.07,
                    ifelse(Data$indicador_costo == 1, 0.036,
                    ifelse(Data$indicador_costo == 2 & Data$`Prestador/Vendedor` == "Nydia Gamba", 0.07, 
                    ifelse(Data$indicador_costo == 2, 0.036, 0))))

# Condicional para las boletas de la rifa
Data$pct_trans <- ifelse(Data$`Servicio/Producto`== "Boletas rifa", 0.07, Data$pct_trans)

#===============================================================================

# Rellenar los valores de TOTAL
# Si la Columna TOTAL esta en formato Texto, entonces es is.na(Total) en lugar de Total == 0
Data <- Data %>%
  group_by(Identificador) %>%
  mutate(Total = ifelse(Total == 0, max(Total, na.rm = TRUE), Total)) 

# Rellenar los valores de sum_tarjeta
Data <- Data %>%
  group_by(Identificador) %>%
  mutate(sum_tarjeta = ifelse(sum_tarjeta == 0, max(sum_tarjeta, na.rm = TRUE), sum_tarjeta))

#===============================================================================

# Inicalización de la Variable Costo de la Transacción
Data$costo_tx <- 0

# Calculo del Costo de la Transacción
Data$costo_tx <- ifelse(Data$indicador_costo == 1, Data$Precio * Data$pct_trans,
                  ifelse(Data$indicador_costo == 0, 0, 
                  ifelse(Data$indicador_costo == 2, 
                        (Data$sum_tarjeta*(Data$Precio/Data$Total)*Data$pct_trans), 
                         NA)))

#===============================================================================

# Eliminar las columnas especificadas de la base de datos Data
Data <- Data %>% select(-sum_tarjeta, -indicador_costo, -pct_trans)

#===============================================================================

# Cambiar los valores en ´Total´ utilizando el valor existente del mismo Identificador
#Data <- Data %>%
#  group_by(Identificador) %>%
#  mutate(`Otro` = ifelse(any(`Otro` == 1, na.rm = TRUE), 1, `Otro`)) %>%
#  ungroup()