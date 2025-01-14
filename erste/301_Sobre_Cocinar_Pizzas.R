##
## Sobre como cocinar Pizzas
##
## ---------------------------
## Step 1: Cargando los datos y las bibliotecas
## ---------------------------
##
## Success is a lousy teacher. It seduces smart people into thinking they can't  lose.
## --- Bill Gates

# Limpiamos el entorno
rm(list = ls())
gc(verbose = FALSE)


# Bibliotecas necesarias -> les cargo donde se necesiten
#require("data.table")
#require("rpart")
#require("ROCR")
#require("ggplot2")
#require("lubridate")
#require("lhs")
#require("DiceKriging")
#require("mlrMBO")
# require("rgenoud")

#if (!require("ggplot2")) {
#  #install.packages("ggplot2")
#  install.packages("ggplot2", dependencies=TRUE)
#  # needed previous
#  # - install.package("lazyeval"
#  # - sudo apt install libudunits2-dev as stated in [configuration failed for package ‘units’](https://community.rstudio.com/t/configuration-failed-for-package-units/76417)
#}
#require("ggplot2")



# Poner la carpeta de la materia de SU computadora local
base <- "/home/vbettachini/documents/universitet/FCEyN/maestríaDatos/economíaFinanzas/dmeyf2023/meine/"
setwd(base)

# Poner sus semillas
semillas <- c(777787, 274837, 874807, 674831, 974821)

# Cargamos el dataset
if (!require("data.table")) {
  install.packages("data.table")
}
library("data.table")
dataset <- fread("../../competencia_01.csv")

# Nos quedamos solo con el 202101
dataset <- dataset[foto_mes == 202103]
# Creamos una clase binaria
dataset[, clase_binaria := ifelse(
  clase_ternaria == "BAJA+2",
  "evento",
  "noevento"
)]

# Borramos el target viejo
dataset[, clase_ternaria := NULL]

# Seteamos nuestra primera semilla
set.seed(semillas[1])

# Particionamos de forma estratificada
in_training <- caret::createDataPartition(
  dataset$clase_binaria,
  p = 0.70,
  list = FALSE
)
dtrain  <-  dataset[in_training, ]
dtest   <-  dataset[-in_training, ]


## ---------------------------
## Step 2: Nuestra pizza: Un modelo
## ---------------------------

if (!require("rpart")) {
  install.packages("rpart")
}
library("rpart")

# Calculamos cuanto tarda un modelo "promedio" entrenar.
start_time <- Sys.time()
modelo <- rpart(clase_binaria ~ .,
  data = dtrain,
  xval = 0,
  cp = 0,
  minsplit = 20,
  minbucket = 10,
  maxdepth = 10
)
pred_testing <- predict(modelo, dtest, type = "prob")
end_time <- Sys.time()
model_time <- end_time - start_time
print("Tiempo de ajuste en train y predict en test")
print(model_time)

ganancia <- function(probabilidades, clase) {
  return(sum(
    (probabilidades >= 0.025) * ifelse(clase == "evento", 273000, -7000)
  )
  )
}

print("La ganancia NORMALIZADA de nuestro modelo es:")
print(ganancia(pred_testing[, "evento"], dtest$clase_binaria) / 0.3)

## Preguntas
## - ¿Es acaso este el mejor modelo posible?
# No, pues no se ha buscado el mejor modelo posible.

## - ¿Dónde lo buscamos el mejor modelo?
#  En el espacio de búsqueda.

## - ¿Qué parámetros conoce para un árbol de decisión?
# profundidad (maxdepth, mindepth), minsplit, minbucket, cp, etc.

## - ¿Qué espacios de búsqueda tienen los parámetros *maxdepth* y *minsplit*?
# maxdepth: 4 a 30

## - ¿Cómo se imagina la interacción entre esto dos últimos parámetros?
# A mayor maxdepth, mayor minsplit.



## ---------------------------
## Step 3: There Ain't No Such Thing As A Free Lunch
## ---------------------------

# Supongamos que sólo vamos a buscar sobre los parámetros *maxdepth* y
# *minsplit*

# Tamaño del espacio de búsqueda de *maxdepth*
n_md <- 30 - 4
# Tamaño del espacio de búsqueda de *minsplit*
n_ms <- 200 - 2
# Cantidad de semillas
n_seeds <- 5

# Estimación de cuanto tardaría en buscar el mejor modelo con 2 parámetros.
if (!require("lubridate")) {
  install.packages("lubridate")
}
require("lubridate")
print(seconds_to_period(n_md * n_ms * n_seeds * model_time))

# Tamaño del espacio de búsqueda de *minbucket*
n_mb <- 100 - 2

# Estimación de cuanto tardaría en buscar el mejor modelo con 3 parámetros.
print(seconds_to_period(n_md * n_ms * n_seeds * model_time * n_mb))

## Preguntas
## - ¿Dispone del tiempo para realizar esta búsqueda?
# Evidentemente no, ni 4 días ni mucho menos 445 si se toma en cuenta n_mb, el tamaño del ninbucket.
# Por eso se usan técnicas de optimización bayesiana.

## - ¿Qué hacemos cuándo un parámetro tiene valores continuos?
# Se discretiza el espacio de búsqueda.

## ---------------------------
## Step 4: Empezando a probar con menos casos
## ---------------------------

set.seed(semillas[1])
dist_uni <- matrix(runif(20), 10, 2)

# LHS Latin hypercube sampling
if (!require("lhs")) {
  install.packages("lhs")
}
require("lhs")

set.seed(semillas[1])
dist_lhs <- optimumLHS(10, 2)

par(mfrow = c(1, 2))
plot(dist_uni)
plot(dist_lhs)


## Preguntas
## - ¿Cuál distribución considera mejor? Justifique
# La "latin hypercube sampling" pues cubre mejor el espacio de búsqueda.
# En la uniforme pparecen concentrarse los casos para en la coordenada 2 < 0.5.
# Cito ["...so the points are as spread out as possible."](https://www.rdocumentation.org/packages/lhs/versions/1.1.6/topics/optimumLHS)
# alt (https://search.r-project.org/CRAN/refmans/lhs/html/optimumLHS.html)


## ---------------------------
## Step 5: Tomando una muestra de sangre
## ---------------------------

# Armamos una función para modelar con el fin de simplificar el código futuro
if (!require("ROCR")) {
  install.packages("ROCR")
}
require("ROCR")

modelo_rpart <- function(train, test, cp =  0, ms = 20, mb = 1, md = 10) {
  modelo <- rpart(clase_binaria ~ ., data = train,
    xval = 0,
    cp = cp,
    minsplit = ms,
    minbucket = mb,
    maxdepth = md
  )

  test_prediccion <- predict(modelo, test, type = "prob")
  roc_pred <-  ROCR::prediction(test_prediccion[, "evento"],
    test$clase_binaria,
    label.ordering = c("noevento", "evento")
  )
  auc_t <-  ROCR::performance(roc_pred, "auc")

  unlist(auc_t@y.values)
}

# Función para tomar un muestra dejando todos los elementos de la clase BAJA+2
tomar_muestra <- function(datos, resto = 10000) {
  t <- datos$clase_binaria == "evento"
  r <- rep(FALSE, length(datos$clase_binaria))
  r[!t][sample.int(resto, n = (length(t) - sum(t)))] <- TRUE
  t | r
}

set.seed(semillas[1])
ds_sample <- tomar_muestra(dataset)
table(dataset[ds_sample]$clase_binaria)

## Preguntas
## - ¿Qué tipo de muestreo se tomó?
# ?

## - ¿Hay mejores formas de muestrear?
##Tratar de preservar la clase más valiosa y descartar el resto.

## - ¿Es bueno muestrear?
##No. Pero no me queda otra, por falta de tiempo.
##Jamás se hace muestreo de los conjuntos de validación o prueba (test).

## - ¿Qué efectos en las métricas va a producir el muestreo?
## Nada, pues una vez establecido el árbol, los limitantes
## (min bucket size) eran aplicados al entrenar (generar el árbol)

## - ¿Por qué se eligió usar el AUC?
## Todas las proporciones se verán afectadas, por eso se eligo área bajo la curva que no lo será.

## - ¿Qué hay que cambiar en la función de ganancia para poder utilizarla?
# ?


## ---------------------------
## Step 6: Comparando tiempos con o sin muestras
## ---------------------------

t0 <- Sys.time()
r1 <- modelo_rpart(dtrain, dtest)
t1 <- Sys.time()
print("Train entero")
print(t1 - t0)
print(r1)

set.seed(semillas[1])
dtrain_sample <- tomar_muestra(dtrain)

t0 <- Sys.time()
r2 <- modelo_rpart(dtrain[dtrain_sample, ], dtest)
t1 <- Sys.time()
print("Muestra train")
print(t1 - t0)
print(r2)

## Preguntas
## - ¿Por qué sólo se muestrea train?
# Obviamente porque es donde se entrena, pero sospecho algo sobre contaminación si lo hago sobre test.


## ---------------------------
## Step 7: Buscando el mejor modelo con muestras aleatorias LHS
## ---------------------------

# Una función auxiliar para los experimentos
experimento_rpart <- function(ds, semillas, cp = 0, ms = 20, mb = 1, md = 10) {
  auc <- c()
  for (s in semillas) {
    set.seed(s)
    in_training <- caret::createDataPartition(
      ds$clase_binaria,
      p = 0.70,
      list = FALSE
    )
    train  <-  ds[in_training, ]
    test   <-  ds[-in_training, ]
    train_sample <- tomar_muestra(train)
    r <- modelo_rpart(train[train_sample, ], test,
      cp = cp, ms = ms, mb = mb, md = md
    )
    auc <- c(auc, r)
  }
  mean(auc)
}

# Haremos 25 experimentos aleatorios, armamos las muestras de acuerdo a como
# son las entradas de nuestro experimento.

set.seed(semillas[1])
cantidad_puntos <- 25
espacio_busqueda_1 <- optimumLHS(cantidad_puntos, 2)

# la primera columna es para el maxdepth, y la segunda para el minsplit
espacio_busqueda_1[, 1] <- floor(15 * espacio_busqueda_1[, 1]) + 4
espacio_busqueda_1[, 2] <- floor(200 * espacio_busqueda_1[, 2]) + 2

resultados_random_search <- data.table()
for (e in 1:cantidad_puntos) {
  r <- experimento_rpart(dataset, semillas,
    ms = espacio_busqueda_1[e, 2],
    md = espacio_busqueda_1[e, 1]
  )
  resultados_random_search <- rbindlist(list(resultados_random_search,
    data.table(
      md = espacio_busqueda_1[e, 1],
      ms = espacio_busqueda_1[e, 2],
      auc = r
    )
  ))
}

print(resultados_random_search)
saveRDS(object = resultados_random_search,
  file = "./301_resultados_random_search.rds"
)

if (!require("ggplot2")) {
  install.packages("ggplot2")
}
require("ggplot2")
ggplot2::ggplot(resultados_random_search,
  ggplot2::aes(x = md, y = ms, color = auc)
) +
  ggplot2::scale_color_gradient(low = "blue", high = "red") +
  ggplot2::geom_point(ggplot2::aes(size = auc))


## Preguntas
## - ¿Hay alguna zona dónde parece que hay más ganancia?
# Por la escala cromática del area bajo la curva (AUC) evitar:
# - mínimo de observaciones por nodo o rama (minsplits, ms) < 25
# - profundidad máxima del árbol (maxdepth, md) < 10
# - mínimo de observaciones por nodo terminal u hoja (minbucket, mb)

## - ¿Cómo podemos continuar nuestra búsqueda?
# Restan el otro hiperparámetro: minbucket (mb)


## ---------------------------
## Step 8: Trabajando con herramientas más profesionales
## ---------------------------
if (!require("mlrMBO")) {
  install.packages("mlrMBO")
}
require("mlrMBO")

# Veamos un ejemplo
set.seed(semillas[1])
obj_fun <- makeSingleObjectiveFunction(
  name = "Sine",
  fn = function(x) sin(x),
  par.set = makeNumericParamSet(lower = 3, upper = 13, len = 1)
)

ctrl <- makeMBOControl()
ctrl <- setMBOControlTermination(ctrl, iters = 10L)
ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritEI(),
  opt = "focussearch"
)

if (!require("DiceKriging")) {
  install.packages("DiceKriging")
}
require("DiceKriging")
lrn <- makeMBOLearner(ctrl, obj_fun)
design <- generateDesign(6L, getParamSet(obj_fun), fun = lhs::maximinLHS)

if (!require("rgenoud")) {
  install.packages("rgenoud")
}
require("rgenoud")
run <- exampleRun(obj_fun, design = design, learner = lrn,
  control = ctrl, points.per.dim = 100, show.info = TRUE
)

# Ejecutar de a uno
plotExampleRun(run, iters = 1, densregion = TRUE, pause = FALSE)
plotExampleRun(run, iters = 2, densregion = TRUE, pause = FALSE)
plotExampleRun(run, iters = 3, densregion = TRUE, pause = FALSE)
plotExampleRun(run, iters = 5, densregion = TRUE, pause = FALSE)
plotExampleRun(run, iters = 6, densregion = TRUE, pause = FALSE)
plotExampleRun(run, iters = 7, densregion = TRUE, pause = FALSE)
plotExampleRun(run, iters = 8, densregion = TRUE, pause = FALSE)
plotExampleRun(run, iters = 9, densregion = TRUE, pause = FALSE)
plotExampleRun(run, iters = 10, densregion = TRUE, pause = FALSE)


## ---------------------------
## Step 9: Introduciendo la técnica en nuestro conjunto
## ---------------------------

resultados_maxdepth <- data.table()

for (v in 4:20) {
  r <- data.table(
    md = v,
    auc = experimento_rpart(dataset, semillas, md = v)
  )
  resultados_maxdepth <- rbindlist(list(resultados_maxdepth, r))
}

saveRDS(object = resultados_maxdepth,
  file = "./301_resultados_maxdepth.rds"
)

ggplot(resultados_maxdepth, aes(md, auc)) + geom_point()

## ---------------------------
## Step 9: Buscando con una Opt. Bayesiana para 1 parámetro
## ---------------------------

set.seed(semillas[1])
obj_fun_md <- function(x) {
  experimento_rpart(dataset, semillas, md = x$maxdepth)
}

obj_fun <- makeSingleObjectiveFunction(
  minimize = FALSE,
  fn = obj_fun_md,
  par.set = makeParamSet(
    makeIntegerParam("maxdepth",  lower = 4L, upper = 20L)
  ),
  # noisy = TRUE,
  has.simple.signature = FALSE
)

ctrl <- makeMBOControl()
ctrl <- setMBOControlTermination(ctrl, iters = 10L)
ctrl <- setMBOControlInfill(
  ctrl,
  crit = makeMBOInfillCritEI(),
  opt = "focussearch",
  opt.focussearch.points = 2
)

lrn <- makeMBOLearner(ctrl, obj_fun)

surr_km <- makeLearner("regr.km", predict.type = "se", covtype = "matern3_2")

run_md <- mbo(obj_fun, learner = surr_km, control = ctrl)
print(run_md)

saveRDS(object = run_md,
  file = "./301_run_md.rds"
)

## ---------------------------
## Step 10: Buscando con una Opt. Bayesiana para 2 parámetros
## ---------------------------

set.seed(semillas[1])
obj_fun_md_ms <- function(x) {
  experimento_rpart(dataset,
    semillas,
    md = x$maxdepth,
    ms = x$minsplit
  )
}

obj_fun <- makeSingleObjectiveFunction(
  minimize = FALSE,
  fn = obj_fun_md_ms,
  par.set = makeParamSet(
    makeIntegerParam("maxdepth",  lower = 4L, upper = 20L),
    makeIntegerParam("minsplit",  lower = 1L, upper = 200L)
    # makeNumericParam <- para parámetros continuos
  ),
  # noisy = TRUE,
  has.simple.signature = FALSE
)

ctrl <- makeMBOControl()
ctrl <- setMBOControlTermination(ctrl, iters = 16L)
ctrl <- setMBOControlInfill(
  ctrl,
  crit = makeMBOInfillCritEI(),
  opt = "focussearch",
  # sacar parámetro opt.focussearch.points en próximas ejecuciones
  opt.focussearch.points = 20
)

lrn <- makeMBOLearner(ctrl, obj_fun)

surr_km <- makeLearner("regr.km", predict.type = "se", covtype = "matern3_2")

run_md_ms <- mbo(obj_fun, learner = surr_km, control = ctrl, )
print(run_md_ms)

saveRDS(object = run_md_ms,
  file = "./301_run_md_ms.rds"
)

## Visualizamos
iter <- as.data.frame(run_md_ms$opt.path)
ggplot(iter, aes(y = minsplit, x = maxdepth, color = prop.type)) + geom_point(aes(size = y))

saveRDS(object = iter,
  file = "./301_iter.rds"
)