# Grid search con clase binaria

# Limpiamos el entorno
rm(list = ls())
gc(verbose = FALSE)

# Poner sus semillas
semillas <- c(777787, 274837, 874807, 674831, 974821)

# Cargamos el dataset
if (!require("data.table")) {
  install.packages("data.table")
}
library("data.table")

# Aqui se debe poner la carpeta de la materia de SU computadora local
setwd(
  "/home/vbettachini/documents/universitet/FCEyN/maestríaDatos/economíaFinanzas/dmeyf2023/meine"
) # Establezco el Working Directory

# cargo el dataset
dataset <- fread("../../datasets/competencia_01.csv")

# Nos quedamos solo con el 202101
dataset <- dataset[foto_mes == 202103]

# Creamos una clase binaria
dataset[
  ,
  clase_binaria := ifelse(
    clase_ternaria == "BAJA+2",
    "evento",
    "noevento"
  )
]

# Borramos el target viejo
dataset[, clase_ternaria := NULL]

# Armamos una función que nos calcule la ganancia, usando el punto de corte de
# 0.025
ganancia <- function(probabilidades, clase) {
  return(
    sum(
      (probabilidades >= 0.025) *
        ifelse(clase == "evento", 273000, -7000)
    )
  )
}

# Corrida

# Paralelización
## Bibliotecas
if (!require("foreach")) {
  install.packages("foreach")
}
library("foreach")
if (!require("doParallel")) {
  install.packages("doParallel")
}
require("doParallel")
## Parámetros
registerDoParallel(3) # SIH has 4 cores, use 3 for the cluster



if (!require("rpart")) {
  install.packages("rpart")
}
library("rpart")

# data.table de resultados
resultados_grid_search <- data.table()

# Complete los valores que se van a combinar para cada parámetro a explorar
for (cp in c(-7)) {
  for (md in c(8, 9)) {
    for (ms in c(350, 400, 450)) {
      for (mb in c(as.integer(ms / 2))) {
        t0 <- Sys.time()
        gan_semillas <- c()
        for (s in semillas) {
          set.seed(s)
          in_training <- caret::createDataPartition(
            dataset[, get("clase_binaria")],
            p = 0.70,
            list = FALSE
          )
          dtrain <- dataset[in_training, ]
          dtest <- dataset[-in_training, ]
          modelo <- rpart(
            clase_binaria ~ .,
            data = dtrain,
            xval = 0,
            cp = cp,
            minsplit = ms,
            minbucket = mb,
            maxdepth = md
          )
          pred_testing <- predict(modelo, dtest, type = "prob")
          gan <- ganancia(pred_testing[, "evento"], dtest$clase_binaria) / 0.3
          gan_semillas <- c(gan_semillas, gan)
        }
        tiempo <-  as.numeric(Sys.time() - t0, units = "secs")
        resultados_grid_search <- rbindlist(
          list(
            resultados_grid_search,
            data.table(
              tiempo = tiempo,
              cp = cp,
              mb = mb,
              ms = ms,
              md = md,
              gan = mean(gan_semillas)
            ) # se puede agregar el sd?
          )
        )
      }
    }
  }
}

# Los ordena por ganancia
resultados_grid_search <- setorder(resultados_grid_search, -gan)
# resultados_grid_search

# Graba un archivo
saveRDS(object = resultados_grid_search, file = "./rGSdva.rds")

# Visualizo los parámetros de los mejores parámetros
print(resultados_grid_search)
# print(resultados_grid_search[gan == max(gan), ])
