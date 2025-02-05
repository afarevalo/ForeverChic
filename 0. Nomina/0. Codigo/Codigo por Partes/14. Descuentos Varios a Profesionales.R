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
#source("0. Codigo/Codigo por Partes/10. Completar Base con Color.R")
#source("0. Codigo/Codigo por Partes/11. Porcentaje de los Profesionales.R")
#source("0. Codigo/Codigo por Partes/12. Participación Salón.R")
#source("0. Codigo/Codigo por Partes/13. Descuento Ajuste Producto.R")
#===============================================================================
# Incluir los Descuentos
#===============================================================================

# Exportar Excel de la ruta previamente establecida
archivos_descuento <- list.files(ruta_descuento)
ultimo_descuento <- archivos_descuento[length(archivos_descuento)]
Descuentos <- read_excel(file.path(ruta_descuento, ultimo_descuento))
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

# Elminina la variable
Descuentos <- Descuentos %>% select(-Concepto, -Observación)

# Cambia el formato de la Fecha para usar Full join
Descuentos$`Fecha de Pago` <- as.character(Descuentos$`Fecha de Pago`)

# Convertir la columna 'Fecha de Pago' al formato DD/MM/AAAA y mantenerla como chr
Descuentos <- Descuentos %>%
  mutate(`Fecha de Pago` = format(as.Date(`Fecha de Pago`, format = "%Y-%m-%d"), "%d/%m/%Y"))

# Unir las base de datos
Data <- full_join(Data, Descuentos)

#===============================================================================
Data <- Data %>%
  mutate(across(c(`Precio de Lista`, `Precio`, `Total`, `Nequi Nambad`, 
                  `Daviplata Nambad`, `Modificado`, `costo_tx`, 
                  `pct_prod`, `val_prod`, `val_neto`, `Part_profesional`, 
                  `Part_salon`), ~replace(., is.na(.), 0)))
#===============================================================================

# Hay pagos por Nequi y DaviPlata de Nydia
nuevas <- sum(Data$`Nequi Nambad`,Data$`Daviplata Nambad`)

if(nuevas > 0) {
  # Descuento de Nequi y DaviPlata de Nydia - Alianza
  # Filtrar las filas donde "Nequi Nambad" o "Daviplata Nambad" son mayores a 0
  filas_a_duplicar <- Data %>% 
    filter(`Nequi Nambad` > 0 | `Daviplata Nambad` > 0)
  
  # Crear las nuevas filas con las modificaciones requeridas
  nuevas_filas <- filas_a_duplicar %>%
    mutate(
      `Servicio/Producto` = ifelse(`Prestador/Vendedor` != "Nydia Gamba", paste("Ajuste por Pago Anticipado"), `Servicio/Producto`),
      `Prestador/Vendedor` = ifelse(`Prestador/Vendedor` != "Nydia Gamba", "Nydia Gamba", `Prestador/Vendedor`),
      `Nombre cliente` = paste(`Nombre cliente`, "(Pago Anticipado)"),
      Part_profesional = -1 * (`Nequi Nambad` + `Daviplata Nambad`),
      Modificado = 1,
      `Precio de Lista` = ifelse(`Prestador/Vendedor` == "Nydia Gamba", NA, `Precio de Lista`),
      Precio = ifelse(`Prestador/Vendedor` == "Nydia Gamba", 0, Precio),
      Total = ifelse(`Prestador/Vendedor` == "Nydia Gamba", NA, Total),
      Tipo = ifelse(`Prestador/Vendedor` == "Nydia Gamba", "Ajuste", Tipo),
      costo_tx = ifelse(`Prestador/Vendedor` == "Nydia Gamba", 0, costo_tx),
      pct_prod = ifelse(`Prestador/Vendedor` == "Nydia Gamba", 0, pct_prod),
      val_prod = ifelse(`Prestador/Vendedor` == "Nydia Gamba", 0, val_prod),
      Ayuda = ifelse(`Prestador/Vendedor` == "Nydia Gamba", 0, Ayuda),
      val_neto = ifelse(`Prestador/Vendedor` == "Nydia Gamba", 0, val_neto),
      Part_salon = ifelse(`Prestador/Vendedor` == "Nydia Gamba", 0, Part_salon)
    )
  
  # Añadir las nuevas filas a la base de datos original
  Data <- bind_rows(Data, nuevas_filas)
  
  rm(filas_a_duplicar, nuevas_filas, Descuentos)
  
}

#===============================================================================

# Condicional para no cobrarle a Ines Torres
Data$Part_profesional <- ifelse(Data$`Nombre cliente` == "Ajuste de Producto" & 
                                  Data$`Prestador/Vendedor` == "Ines Torres" & 
                                  Data$`Precio de Lista` > 0, 0, 
                                Data$Part_profesional)

#===============================================================================

# Elimina las columnas de Nequi Y Daiplata Nydia - Alianza
Data <- Data %>% select(-`Nequi Nambad`, -`Daviplata Nambad`, -`Precio de Lista`, -Total, -Ayuda)

#===============================================================================

Data$Modificado <- ifelse(Data$`Nombre cliente` == "Ajuste de Producto", 1, Data$Modificado)

# Ajuste Boletas Rifa
Data$Tipo <- ifelse(Data$`Servicio/Producto` == "Boletas rifa", "Revisar", Data$Tipo)
Data$`Prestador/Vendedor` <- ifelse(Data$`Servicio/Producto` == "Boletas rifa", "Revisar", Data$`Prestador/Vendedor`)
Data$Part_profesional <- ifelse(Data$`Servicio/Producto` == "Boletas rifa", 0, Data$Part_profesional)
Data$Part_salon <- ifelse(Data$`Servicio/Producto` == "Boletas rifa", 0, Data$Part_salon)
#===============================================================================

# Ajuste Compañeros
Data$Part_profesional <- ifelse(Data$`Servicio/Producto` %in% companeros & Data$Modificado == 0 & Data$val_neto > 0,
                                Data$val_neto *  Parte_Alianza, Data$Part_profesional)

Data$Part_salon <- ifelse(Data$Precio > 0 & Data$Modificado == 0,
                          Data$Precio - 
                            suppressWarnings(as.numeric(Data$val_prod)) - 
                            suppressWarnings(as.numeric(Data$costo_tx)) - 
                            suppressWarnings(as.numeric(Data$Part_profesional)),
                          NA)

#===============================================================================

# Ajuste Bonos
Data$Part_profesional <- ifelse(Data$Tipo == "Bonos", 0, Data$Part_profesional)
Data$Part_salon <- ifelse(Data$Tipo == "Bonos", 0, Data$Part_salon)
