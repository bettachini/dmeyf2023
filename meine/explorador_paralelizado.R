# Modelo de árbol
# Target: clase_binaria

# Tomado de
# https://dmeyf2023.zulip.rebelare.com/#narrow/stream/401-Code/topic/z202.20-.20Multinucleo
# Tomas Elesser


## Apuntes
"
Idea

Entrenar con una fecha pretérita, e.g. 202103
Simular que se hace la prueba en una actual, e.g. 202105
dtrain <- dataset[foto_mes == 202103] # defino donde voy a entrenar
dapply <- dataset[foto_mes == 202105] # defino donde voy a aplicar el modelo


Terminología
- semillas: semillas para el random seed
- ganancia: función de ganancia
- resultados_grid_search: resultados del grid search
"

# Poner sus semillas
semillas <- c(777787, 274837, 874807, 674831, 974821)

# cargo el dataset
dataset <- fread("./datasets/competencia_01.csv")

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

## rpart | Hiperparámetros del árbol
cp_lista <- c(-1) # cp: complejidad del árbol
md_list <- c() # maxdepth: profundidad máxima del árbol
# minsplit: mínimo de observaciones para hacer un split
# minbucket: mínimo de observaciones en una hoja
# xval: cross validation


## Ciclo principal
for (cp in cp_lista) {
  for (md in c(15)) {
    for (ms in c(1500, 2000)) {
      for (mb in c(1, as.integer(ms / 2))) {
        t0 <- Sys.time()
        gan_semillas <- c()
        # for (s in semillas) {
        gan_semillas <- foreach(s = semillas, .combine = "c") %dopar% {
          set.seed(s)
          in_training <- caret::createDataPartition(
            dataset[
              ,
              get("clase_binaria")
            ],
            p = 0.70, list = FALSE
          )
          dtrain <- dataset[in_training, ]
          dtest <- dataset[-in_training, ]

          modelo <- rpart(clase_binaria ~ .,
            data = dtrain,
            xval = 0, # cross validation
            cp = cp, # complejidad del árbol
            minsplit = ms, # mínimo de observaciones para hacer un split
            minbucket = mb, # mínimo de observaciones en una hoja
            maxdepth = md # profundidad máxima del árbol
          )

          pred_testing <- predict(modelo, dtest, type = "prob")
          gan <- ganancia(pred_testing[, "evento"], dtest$clase_binaria) / 0.3

          gan_semillas <- c(gan_semillas, gan)
          return(gan_semillas)
        }
        tiempo <- as.numeric(Sys.time() - t0, units = "secs")

        resultados_grid_search <- rbindlist(
          list(
            resultados_grid_search,
            foreach(
              tiempo = tiempo,
              cp = cp,
              mb = mb,
              ms = ms,
              md = md,
              gan = mean(gan_semillas)
            )
          )
        )
        print(resultados_grid_search)
        stopImplicitCluster()
      }
    }
  }
}