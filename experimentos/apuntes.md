
##  2023-11-13

### Numéro atributos
- crudo 154 -2 (número_cliente, foto_mes) = 152
- baseline (lag1,3,6) = (152 -5 +5) *3 = 456 (drop = -5, indicadores = +5, lags = *3)
- FEH1 152*(6+ 3) = 912 (lags = *6, mín, máx, avg = +3)
- FEH2 152*(6+ 3 + 7) = 2128  (normalización + deltas norm = +7) 



### Ganancia vs semilla: inicio corrida lightgbm
Sin haber terminado la ejecución de la optimización bayesiana `823_all6.r` y `823_all6_a.r` (ver más abajo), copio en directorio local sus parciales
```
gsutil -m cp -r \
  "gs://normanbuck/exp/exp823_all6" \
  "gs://normanbuck/exp/exp823_all6_a" \
  .
```

#### Corridas rápidas con VM 8/256
- Corro `824_all6_zweite.r` con parámetros iteración 18 de `823_all6.r`
  - quito semillas BO
```
  # hiperparametros según corrida de 823_all6.r iteración 18
  PARAM$finalmodel$optim$learning_rate <- 0.0761611024567367
  PARAM$finalmodel$optim$feature_fraction <- 0.0556126596160683
  PARAM$finalmodel$optim$num_leaves <- 218
  PARAM$finalmodel$optim$min_data_in_leaf <- 1231
  envios_opt <- 14148
  PARAM$finalmodel$optim$num_iterations <- 100 #ick!
```



- Corro `824_all6_erste.r` con parámetros iteración 15 de `823_all6.r`
Número de iteraciones ultra corto
```
  PARAM$experimento <- "exp_all6_erste_824"
  PARAM$finalmodel$optim$learning_rate <- 0.06789562889433	
  PARAM$finalmodel$optim$feature_fraction <- 0.0672146950458409
  PARAM$finalmodel$optim$num_leaves <- 334
  PARAM$finalmodel$optim$min_data_in_leaf <- 1711
  envios_opt <- 12146
  PARAM$finalmodel$optim$num_iterations <- 15 #ick!
```

- Corro `824_feh1_eins.r` con parámetros iteración 15 de `823_all6_a.r`
  - quito semillas BO
  - parámetros de iteración 26
```
  # hiperparametros según corrida de 823_all_a.r
  PARAM$finalmodel$optim$learning_rate <- 0.0788030608086094
  PARAM$finalmodel$optim$feature_fraction <- 0.0461101159560178
  PARAM$finalmodel$optim$num_leaves <- 234
  PARAM$finalmodel$optim$min_data_in_leaf <- 1547
  envios_opt <- 12229
  PARAM$finalmodel$optim$num_iterations <- 15 #ick!
```

### Actualización presentación
Escribo sobre #5 FE histórico tanto en 
- Presentación: https://docs.google.com/presentation/d/1ptfmnzmqtBhAam7DEDT-a4HcHWIHroYqhF5cuA3lrsI/edit#slide=id.g1eb3ec8d83d_1_18
- Zulip: https://dmeyf2023.zulip.rebelare.com/#narrow/stream/435-Experimentos-Colaborativos/topic/FE.20hist.C3.B3rico

Retiro la bibliografía actual
```
https://towardsdatascience.com/4-tips-for-advanced-feature-engineering-and-preprocessing-ec11575c09ea
https://towardsdatascience.com/three-approaches-to-feature-engineering-for-time-series-2123069567be
https://shaz13.medium.com/rare-feature-engineering-techniques-for-machine-learning-competitions-de36c7bb418f
Feature Engineering for Machine Learning (1/3) | by Wing Poon | Towards Data Science
Feature Engineering for Machine Learning (2/3) | by Wing Poon | Towards Data Science
https://www.analyticsvidhya.com/blog/2019/12/6-powerful-feature-engineering-techniques-time-series/#h-feature-engineering-for-time-series-3-lag-features
A Dynamic Classification Approach to Churn Prediction in Banking Industry (https://core.ac.uk/download/pdf/326836343.pdf)
```


### 


##  2023-11-12

### Optimización bayesiana: inicio de corrida
- `823_baseline.r` baseline (terminada fecha anterior) -> `buckets/b1/exp823_a`

Usando los mismos rangos para los parámetros que para el baseline (puedo haber subestimado la complejidad, estaría bueno contabilizar el número de atributos generados en los casos)
- `823_all6.r` variante 1 sin normalización -> `buckets/b1/exp/823_all6_a`
- `823_all6_a.r` con normalización -> `buckets/b1/exp/exp_823_all6`



### feature engineering
`sql_eng_all6.ipynb` produce con SQL.

Cambios comunes
- Redundantes
  - Tanto `Visa_mconsumospesos` y `Visa_mconsumototal` como `Master_mconsumospesos` y `Master_mconsumototal` son equivalentes. -> drop `Visa_mconsumospesos` y `Master_mconsumospesos`
  - Son iguales la suma de `catm_trx` y `catm_trx_other` que `cextraccion_autoservicio` -> drop `cextraccion_autoservicio` 
- Indicadores booleanos
  - saldo negativo: `mcuentas_saldo_neg` = mcuentas_saldo < 0
  - saldo negativo todas: `mcuenta_otras_neg` = (mcuenta_corriente + mcuenta_corriente_adicional + mcaja_ahorro + mcaja_ahorro_adicional + mcaja_ahorro_dolares) < 0 
  - Uso de ATM de otro banco más que el propio: `catm_mayor_oth` = (catm_trx_other - catm_trx) < 0
- Coalesce tarjetas de crédito
  - consumo conjunto: mtarjeta_consumo = mtarjeta_master_consumo + mtarjeta_visa_consumo -> drop `mtarjeta_master_consumo` y `mtarjeta_visa_consumo`
- Proxy actividad
  - actividad = abs(matm_other) + abs(matm) +
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
    abs(mtarjeta_consumo) + 
    abs(mcaja_ahorro_dolares) + abs(mcaja_ahorro_adicional) + abs(mcaja_ahorro) +
    abs(mcuenta_corriente) + abs(mcuenta_corriente_adicional)

Con dos variantes
1. **all6**: min, max, promedio, lag# con # 1 a 6
2. **all6_a**: + normalización (col/ promedio), diferencia normalizada ((col - lag#)/ promedio)


##  2023-11-11

### Tengo que: hacer dataset con mi feature engineering

### Tengo que: correr 824 para los parámetros que salen

### Baseline: optimización bayesiana
823_baseline.r 

Fechas y semillas
```{r}
PARAM$experimento <- "exp823_a"

PARAM$input$dataset <- "./datasets/competencia_03_baseline.csv.gz"

# los meses en los que vamos a entrenar
#  mucha magia emerger de esta eleccion
PARAM$input$testing <- c(202106)
PARAM$input$validation <- c(202105)
PARAM$input$training <- c(2020111, 202012, 202101, 202102, 202103, 202104)

# un undersampling de 0.1  toma solo el 10% de los CONTINUA
PARAM$trainingstrategy$undersampling <- 1.0 # sin undersampling
PARAM$trainingstrategy$semilla_azar <- 777787 # Aqui poner su primer semilla

PARAM$hyperparametertuning$POS_ganancia <- 273000
PARAM$hyperparametertuning$NEG_ganancia <- -7000

# Aqui poner su segunda semilla
PARAM$lgb_semilla <- 274837
```

Rango de parámetros
```{r}
PARAM$bo_lgb <- makeParamSet(
  makeNumericParam("learning_rate", lower = 0.06, upper = 0.1),
  makeNumericParam("feature_fraction", lower = 0.03, upper = 0.07),
  makeIntegerParam("num_leaves", lower = 200L, upper = 350L),
  makeIntegerParam("min_data_in_leaf", lower = 1200L, upper = 1800L)
)
```

### Generación baseline
`sql_eng_baseline.ipynb`
- SQL via DuckDB en Python
- a partir de `competencia_03_crudo.csv.gz` 
- generó el dataset `competencia_03_baseline.csv.gz` que se usó en el experimento 823.

Agrega atributos
- `clase_ternaria`
- features de lag 1, 3 y 6 meses para todos los atributos de la base (excepto `numero_de_cliente`, `foto_mes` y `clase_ternaria`)

## Clase ternaria
Código `dritte/ternaire.jl` de Juan Raman con agregado de Federico Idoeta.  


## Clase plenaria Denicolay
20231102 (resumen)

### Semillerío
El modelo debe
- hacerse con semillerío, un centenar (125) de corridas con semillas distintas
    - Esto para el modelo final, no para la optimización
    - Promediar la salida, es decir, votar por mayoría entre continua y alternativa
- Meses: una decena, sino un año
- Feature engineering: con ganas
- Quality & drifting: limpieza y corrección por inflación de datos primarios
- No dejar de hacer optimización Bayesiana, que puede hacerse sobre una sola semilla

- Para el análisis de los experimentos
- Utilizar los resultados del semillerío medidos sobre test
    - Histograma de ganancias no del centenar de semillas, sino de una submuestra
    - Se comparan contra la distribución del baseline (modelo malo)
    - El objetivo es mostrar que hay una distribución (modelo que se supone una mejora) separable de aquella del del baseline


### Espacio para optimización Bayesiana
Estos son valores medios que dió Bolaños. Si no tengo otro mejor obtenido por optimización, usarle.
- min data in leaf: 40 a 5000
- feature fraction: 0.2 a 0.8
- min leaves = 15 a 300



## Baseline
[2023-11-03 Bolaños](https://dmeyf2023.zulip.rebelare.com/#narrow/stream/435-Experimentos-Colaborativos/topic/Baseline.20-.20Modelo.20colaborativo.20final)  
> El pueblo voto. Sobre los scripts base z82*:
> Testing 202107, 1 mes de validación, 6 meses de train
> Sin undersampling.
> Agregar las variables Lags 1, 3 y 6 


### Optimización Bayesiana
No tendría sentido "quemar" el mes de test que se usará con el modelo final al momento de optimizar hiperparámetros.
Entonces sería más razonable usar 202106 como test.


## Enlaces
- [ Nuestra Presentación | Google Docs](https://docs.google.com/presentation/d/10rIRzFYEmKURCz5yBybp4ohgJqjXpc4H8l5JDIgfYC4/edit?usp=sharing)
- [Cohorte B | Google Docs](https://docs.google.com/presentation/d/1ptfmnzmqtBhAam7DEDT-a4HcHWIHroYqhF5cuA3lrsI/edit)


## Bibliografía
Ver zotero

Problema #16 sobre feature enginering histórico

Grupo A

__Hipótesis__
La planificación para "bajarse" de un banco no es de largo plazo. Si hay cambios de comportamiento no se ven más allá de un trimestre.

__Diseño experimental__
Puesto que el interrogante no apunta a nada estacional no quiero confundir el efecto con nada estacional.
Por esa razón no me extiendo más de un semestre.
Tendré una conclusión si puedo responder a si ¿difiere la ganancia de un feature engineering histórico con lag hasta 3 meses que con 6?

Compararé la ganancia resultante de haber incorporado estos features:
- min, max, avg, lags = 1 a 3 o 6 meses atrás, (actual - lags), actual/ avg
- Para datos monetarios (m)
    - cuentas = ['mcuenta_corriente_adicional','mcuenta_corriente','mcaja_ahorro','mcaja_ahorro_adicional','mcaja_ahorro_dolares','mcuentas_saldo']
    - actividad = suma de abs(monetarios, no tarjetas)
    - sueldos = ['mpayroll',] # casi no hay mpayroll2
    - consumos_tarjetas = ['mautoservicio', 'mtarjeta_consumo',] # debito, crédito
    - débitos_automaticos = ['mdebitos_automaticos']
- Para datos enteros (c) unos indicadores de saldos negativos:
    - mcuentas_saldo_neg < 0
    - mcuenta_otras_neg < 0


