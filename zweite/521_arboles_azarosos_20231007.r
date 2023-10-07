# Ensemble de arboles de decision
# utilizando el naif metodo de Arboles Azarosos
# entreno cada arbol utilizando un subset distinto de atributos del dataset

# limpio la memoria
rm(list = ls()) # Borro todos los objetos
gc() # Garbage Collection

require("data.table")
require("rpart")

# parmatros experimento
PARAM <- list()
PARAM$experimento <- 5210

# Establezco la semilla aleatoria, cambiar por SU primer semilla
PARAM$semilla <- 777787
# PARAM$semilla <- 102191

# parametros rpart
PARAM$rpart_param <- list(
  "cp" = -1,
  "minsplit" = 250,
  "minbucket" = 100,
  "maxdepth" = 14
)

# parametros  arbol
# entreno cada arbol con solo 50% de las variables variables
PARAM$feature_fraction <- 0.5
# voy a generar 500 arboles,
#  a mas arboles mas tiempo de proceso y MEJOR MODELO,
#  pero ganancias marginales
PARAM$num_trees_max <- 500

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# Aqui comienza el programa

setwd("~/buckets/b1/") # Establezco el Working Directory

# cargo los datos
dataset <- fread("./datasets/competencia_02.csv.gz")


# creo la carpeta donde va el experimento
dir.create("./exp/", showWarnings = FALSE)
carpeta_experimento <- paste0("./exp/KA", PARAM$experimento, "/")
dir.create(paste0("./exp/KA", PARAM$experimento, "/"),
  showWarnings = FALSE
)

setwd(carpeta_experimento)

# que tamanos de ensemble grabo a disco, pero siempre debo generar los 500
grabar <- c(1, 5, 10, 50, 100, 200, 500)





# El feature engineering tardará mucho y no tiene sentido ningún dato previo a 202105-6 = 202011, por lo que elimino los registros anteriores en dataset
dataset <- dataset[foto_mes >= 202011]

#------------------------------------------------------------------------------
# Feature Engineering
#------------------------------------------------------------------------------

# Saldo negativo
## creates a column mcuentas_saldo_neg if mcuentas_saldo < 0
dataset[, mcuentas_saldo_neg := mcuentas_saldo < 0]
## idem. sum of other balances
dataset[,
  mcuentas_otras_neg :=
    (mcuenta_corriente_adicional + mcuenta_corriente +
     mcaja_ahorro + mcaja_ahorro_adicional + mcaja_ahorro_dolares) < 0
]

# abs sum como proxy actividad
dataset[,
  actividad := abs(matm_other) + abs(matm) +
    abs(mcheques_emitidos_rechazados) + abs(mcheques_depositados_rechazados) +
    abs(mcheques_emitidos) + abs(mcheques_depositados) +
    abs(mextraccion_autoservicio) + abs(mautoservicio) +
    abs(mtransferencias_emitidas) + abs(mtransferencias_recibidas) +
    abs(mforex_sell) + abs(mforex_buy) +
    abs(mpagomiscuentas) + abs(mpagodeservicios) +
    abs(mttarjeta_master_debitos_automaticos) + abs(mttarjeta_visa_debitos_automaticos) +
    abs(mcuenta_debitos_automaticos) + abs(mpayroll2) + abs(mpayroll) +
    abs(minversion2) + abs(minversion1_pesos) + abs(minversion1_dolares) +
    abs(mplazo_fijo_pesos) + abs(mplazo_fijo_dolares) +
    abs(mprestamos_hipotecarios) + abs(mprestamos_prendarios) + abs(mprestamos_personales) +
    abs(mtarjeta_master_consumo) + abs(mtarjeta_visa_consumo) +
    abs(mcaja_ahorro_dolares) + abs(mcaja_ahorro_adicional) + abs(mcaja_ahorro) +
    abs(mcuenta_corriente) + abs(mcuenta_corriente_adicional),
  by = .(numero_de_cliente, foto_mes)
]

# lag de todo hasta un semestre
setorder(dataset, numero_de_cliente, foto_mes)
columns_to_shift <- names(dataset)[!names(dataset) %in% c("numero_de_cliente", "foto_mes", "clase_ternaria")]
list_meses_atras <-  c(1, 2, 3, 4, 5, 6) # 202105 - 202011 = 7, un semestre fuera de ASPO posible
for (meses_atras in list_meses_atras) {
  columns_by_shift <- paste0(columns_to_shift, "_lag", meses_atras)
  dataset[,
    (columns_by_shift) := lapply(
      .SD, function(x) shift(x, type = "lag", fill = NA, n = meses_atras)
    ),
    by = numero_de_cliente, .SDcols = columns_to_shift
  ]
}

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------


# defino los dataset de entrenamiento y aplicacion
dtrain <- dataset[foto_mes == 202105]
dapply <- dataset[foto_mes == 202107]

# arreglo clase_ternaria por algun distraido ""
dapply[, clase_ternaria := NA ]

# elimino lo que ya no utilizo
rm(dataset)
gc()

# aqui se va acumulando la probabilidad del ensemble
dapply[, prob_acumulada := 0]

# Establezco cuales son los campos que puedo usar para la prediccion
# el copy() es por la Lazy Evaluation
campos_buenos <- copy(setdiff(colnames(dtrain), c("clase_ternaria")))



# Genero las salidas
set.seed(PARAM$semilla) # Establezco la semilla aleatoria

for (arbolito in 1:PARAM$num_trees_max) {
  qty_campos_a_utilizar <- as.integer(length(campos_buenos)
  * PARAM$feature_fraction)

  campos_random <- sample(campos_buenos, qty_campos_a_utilizar)

  # paso de un vector a un string con los elementos
  # separados por un signo de "+"
  # este hace falta para la formula
  campos_random <- paste(campos_random, collapse = " + ")

  # armo la formula para rpart
  formulita <- paste0("clase_ternaria ~ ", campos_random)

  # genero el arbol de decision
  modelo <- rpart(formulita,
    data = dtrain,
    xval = 0,
    control = PARAM$rpart_param
  )

  # aplico el modelo a los datos que no tienen clase
  prediccion <- predict(modelo, dapply, type = "prob")

  dapply[, prob_acumulada := prob_acumulada + prediccion[, "BAJA+2"]]

  if (arbolito %in% grabar) {
    # Genero la entrega para Kaggle
    umbral_corte <- (1 / 40) * arbolito
    entrega <- as.data.table(list(
      "numero_de_cliente" = dapply[, numero_de_cliente],
      "Predicted" = as.numeric(dapply[, prob_acumulada] > umbral_corte)
    )) # genero la salida

    nom_arch <- paste0(
      "KA", PARAM$experimento, "_",
      sprintf("%.3d", arbolito), # para que tenga ceros adelante
      ".csv"
    )
    fwrite(entrega,
      file = nom_arch,
      sep = ","
    )

    cat(arbolito, " ")
  }
}