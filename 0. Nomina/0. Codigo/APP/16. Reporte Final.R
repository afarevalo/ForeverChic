#===============================================================================
# Limpiar el entorno
rm(list = ls())
#===============================================================================
source("0. Nomina/APP/1. Cargar la Base.R")
source("0. Nomina/APP/2. Nombre del Archivo Base.R")
source("0. Nomina/APP/3. Agregar y Eliminar la Base.R")
source("0. Nomina/APP/4. Clasificacion Tipo de Servicio.R")
source("0. Nomina/APP/5. Manejo Partícipes.R")
source("0. Nomina/APP/6. Costos de transacción.R")
source("0. Nomina/APP/7. Participación Producto.R")
source("0. Nomina/APP/8. Generar la Base de Color.R")
source("0. Nomina/APP/9. Completar Base con Color.R")
source("0. Nomina/APP/10. Porcentaje de los Profesionales.R")
source("0. Nomina/APP/11. Participación Salón.R")
source("0. Nomina/APP/12. Generar la Base de Descuentos.R")
source("0. Nomina/APP/13. Descuento Ajuste Producto.R")
source("0. Nomina/APP/14. Descuentos Varios a Profesionales.R")
source("0. Nomina/APP/15. Exportar Resultados.R")
#===============================================================================
# Reporte Final
#===============================================================================

rm(yellow_style, yellow_row_style)

# Data
Data$Precio <- ifelse(Data$Modificado == 1, 0,Data$Precio)
Data <- Data %>% select(-Modificado)

# Exportar Data del Consolidado
write_xlsx(Data, file.path("3. Resultados", nombre_carpeta, "0. Consolidado.xlsx"))

# Crear el reporte agrupando por trabajador y sumando la variable "Part_profesional"
reporte <- Data %>%
  group_by(`Prestador/Vendedor`) %>%
  summarise(Total_a_pagar = sum(Part_profesional, na.rm = TRUE)) %>%
  arrange(desc(Total_a_pagar)) # Ordenar por el total a pagar de mayor a menor

# Calcula el total de la nomina
total_nomina <- sum(Data$Part_profesional, na.rm = TRUE)

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