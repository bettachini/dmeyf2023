# Arbol elemental con la biblioteca rpart
# Debe tener instaladas las biblioteca: data.table, rpart y rpart.plot

# cargo las bibliotecas que necesito
if (!require("data.table")) {
  install.packages("data.table")
}
library("data.table")

# Aqui se debe poner la carpeta de la materia de SU computadora local
setwd("/home/vbettachini/documents/universitet/FCEyN/maestríaDatos/economíaFinanzas/dmeyf2023/meine") # Establezco el Working Directory
# cargo el dataset
dataset <- fread("../../datasets/competencia_01.csv")

dtrain <- dataset[foto_mes == 202103] # defino donde voy a entrenar
dapply <- dataset[foto_mes == 202105] # defino donde voy a aplicar el modelo

# genero el modelo,  aqui se construye el arbol
if (!require("rpart")) {
  install.packages("rpart")
}
library("rpart")

# quiero predecir clase_ternaria a partir de el resto de las variables
modelo <- rpart(
  formula = "clase_ternaria ~ .", # esto es clase_ternaria = f( todas las demas variables )
  data = dtrain, # los datos donde voy a entrenar
  xval = 5, # no hago cross validation
  cp = -7, # esto significa no limitar la complejidad de los splits
  minsplit = 400, # minima cantidad de registros para que se haga el split
  minbucket = 200, # tamaño minimo de una hoja
  maxdepth = 9 # profundidad maxima del arbol
)


# grafico el arbol
if (!require("rpart.plot")) {
  install.packages("rpart.plot")
}
library("rpart.plot")

#prp(modelo,
#  extra = 101, digits = -5,
#  branch = 1, type = 4, varlen = 0, faclen = 0
#)
#

# aplico el modelo a los datos nuevos
prediccion <- predict(
  object = modelo,
  newdata = dapply,
  type = "prob"
)

# prediccion es una matriz con TRES columnas,
# llamadas "BAJA+1", "BAJA+2"  y "CONTINUA"
# cada columna es el vector de probabilidades

# agrego a dapply una columna nueva que es la probabilidad de BAJA+2
dapply[, prob_baja2 := prediccion[, "BAJA+2"]]

# solo le envio estimulo a los registros
#  con probabilidad de BAJA+2 mayor  a  corte
corte <- 1/40
dapply[, Predicted := as.numeric(prob_baja2 > corte)]

# genero el archivo para Kaggle
# primero creo la carpeta donde va el experimento
# dir.create("./exp/")
# dir.create("./exp/KA2001")

# solo los campos para Kaggle
fwrite(dapply[, list(numero_de_cliente, Predicted)],
  file = "./exp/HT3440/k20230909_07.csv",
  sep = ","
)