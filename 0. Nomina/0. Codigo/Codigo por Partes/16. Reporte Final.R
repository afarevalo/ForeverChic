#===============================================================================
# Limpiar el entorno
rm(list = ls())
#===============================================================================
source("0. Codigo/Codigo por Partes/1. Cargar la Base.R")
source("0. Codigo/Codigo por Partes/2. Nombre del Archivo Base.R")
source("0. Codigo/Codigo por Partes/3. Agregar y Eliminar la Base.R")
source("0. Codigo/Codigo por Partes/4. Clasificacion Tipo de Servicio.R")
source("0. Codigo/Codigo por Partes/5. Manejo Partícipes.R")
source("0. Codigo/Codigo por Partes/6. Generar la Base de Color.R")
source("0. Codigo/Codigo por Partes/7. Generar la Base de Descuentos.R")
source("0. Codigo/Codigo por Partes/8. Costos de transacción.R")
source("0. Codigo/Codigo por Partes/9. Participación Producto.R")
source("0. Codigo/Codigo por Partes/10. Completar Base con Color.R")
source("0. Codigo/Codigo por Partes/11. Porcentaje de los Profesionales.R")
source("0. Codigo/Codigo por Partes/12. Participación Salón.R")
source("0. Codigo/Codigo por Partes/13. Descuento Ajuste Producto.R")
source("0. Codigo/Codigo por Partes/14. Descuentos Varios a Profesionales.R")
source("0. Codigo/Codigo por Partes/15. Exportar Resultados.R")
#===============================================================================
# Reporte Final
#===============================================================================

rm(yellow_row_style)

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
