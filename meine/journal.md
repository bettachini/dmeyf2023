# Log

## 2023-09-09
BO no sirvió para mejorar


HT3440/k20230909_07
  xval = 5, # no hago cross validation
  cp = -7, # esto significa no limitar la complejidad de los splits
  minsplit = 400, # minima cantidad de registros para que se haga el split
  minbucket = 200, # tamaño minimo de una hoja
  maxdepth = 9 # profundidad maxima del arbol


HT3440/k20230909_06
+1 maxdepth
  xval = 0, # no hago cross validation
  cp = -0.3, # esto significa no limitar la complejidad de los splits
  minsplit = 1100, # minima cantidad de registros para que se haga el split
  minbucket = 330, # tamaño minimo de una hoja
  maxdepth = 9 # profundidad maxima del arbol
Score: 51.93958





## 2023-09-05
### Corridas
Con código de salida
`modelo_kaggle.r`

Tomo una al azar entre las mejores que salen en `meine/exp/HT340/BO_log.txt`
fecha	cp	minsplit	minbucket	maxdepth	xval_repeats	xval_folds	ganancia	iteracion
20230905 150340	-0.890784327086904	2202	419	6	10	5	69706700	33
Esto lo convierto en
  xval = 5, # no hago cross validation
  cp = -0.89, # esto significa no limitar la complejidad de los splits
  minsplit = 2202, # minima cantidad de registros para que se haga el split
  minbucket = 419, # tamaño minimo de una hoja
  maxdepth = 6 # profundidad maxima del arbol
score   48.90627
 
Preservo el anterior (Sep  4 16:27)
  xval = 0, # no hago cross validation
  cp = -0.3, # esto significa no limitar la complejidad de los splits
  minsplit = 1100, # minima cantidad de registros para que se haga el split
  minbucket = 330, # tamaño minimo de una hoja
  maxdepth = 8 # profundidad maxima del arbol
score   53.12957


### Correr explorador rpart
Tomo `344_part_binaria1_BO.repe_xval.r` del directorio `.\src`.
Tras romper la ejecución modificando las bibliotecas lo corrí sin modificar los `require` correspondientes, pero indicando 
`PARAM$cores <- 3 # SIH`
para la paralerización.
Al parecer las bibliotecas instaladas operan correctamente,


## 2023-09-04 | notas de clase
tres vías de mejora
- rpart
- feature engineering
- salidas (elegir lo mejores 10000, 9000, )


En el directorio rpart hay optimizaciones bayesianas
- tomar cualquiera de los códigos de allí (solo uno de ellos z3xx) para hacer la búsqueda 

1. feature engineering
- agregar variables que
    - ayuden a árboles 
    - corregir drift

Otra estrategia: buscar una mejor salida
- Ahora se usa un único punto de corte, pero el drifting lo iría cambiando




## 2023-09-04 | No sé que hacer
- En Zulip un compañero publicó [código para explorar hiperparámetros aprovechando la paraleslización](https://dmeyf2023.zulip.rebelare.com/#narrow/stream/401-Code/topic/z202.20-.20Multinucleo)
    - Le copio como `explorador_optimizado.R`
- ¿Es correcto el `competencia_01.csv` generado por `101_target_sql` a partir de  `competencia_01_crudo.csv`?
    - Aún no lo se
- Ideas
    - ¿Cambiar fórmula de particionado del árbol usando una `clase_binaria`?
    - 
