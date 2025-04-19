#===============================================================================
# Limpiar el entorno
rm(list = ls())
cat("\014")
#===============================================================================
# Librerias del Proyecto
#===============================================================================
tryCatch({
  source("0. Codigo/Codigo por Partes/01. Cargar la Base.R")
  source("0. Codigo/Codigo por Partes/02. Nombre del Archivo Base.R")
  source("0. Codigo/Codigo por Partes/03. Agregar y Eliminar la Base.R")
  source("0. Codigo/Codigo por Partes/04. Clasificacion Tipo de Servicio.R")
  source("0. Codigo/Codigo por Partes/05. Manejo Partícipes.R")
  source("0. Codigo/Codigo por Partes/06. Costos de transacción.R")
  source("0. Codigo/Codigo por Partes/07. Participación Producto.R")
  source("0. Codigo/Codigo por Partes/08. Generar la Base de Retardos.R")
  source("0. Codigo/Codigo por Partes/09. Generar la Base de Descuentos.R")
  source("0. Codigo/Codigo por Partes/10. Generar la Base de Color.R")
  source("0. Codigo/Codigo por Partes/11. Completar Base con Color.R")
  source("0. Codigo/Codigo por Partes/12. Completar Base de Retardos.R")
  source("0. Codigo/Codigo por Partes/13. Completar Descuentos Fondo.R")
  source("0. Codigo/Codigo por Partes/14. Porcentaje de los Profesionales.R")
  source("0. Codigo/Codigo por Partes/15. Participación Salón.R")
  source("0. Codigo/Codigo por Partes/16. Descuento Ajuste Producto.R")
  source("0. Codigo/Codigo por Partes/17. Descuentos Varios a Profesionales.R")
  source("0. Codigo/Codigo por Partes/18. Ajuste Partícipes.R")
  source("0. Codigo/Codigo por Partes/19. Exportar Resultados.R")
  source("0. Codigo/Codigo por Partes/20. Reporte Final.R")
  source("0. Codigo/Codigo por Partes/21. Consolidado.R")
}, error = function(e) {
  cat("\n⛔ Se ha detectado un error. Deteniendo ejecución.\n")
  stop(e)  # Detiene toda la ejecución
})
#===============================================================================
# Filtrar por retardos
retardos <- consolidado %>%
  filter(str_starts(`Servicio/Producto`, "Llegaste tarde los días:"))

# Borrar variables
retardos <- retardos %>% select(-`Nombre cliente`)
colnames(retardos)
