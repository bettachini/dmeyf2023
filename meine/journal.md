# Log


## 2023-09-10
`366_aplicar_modelo.r` up and running
Produjo copia de score mejor con 
PARAM$rpart$cp <- -1
PARAM$rpart$minsplit <- 400 
PARAM$rpart$minbucket <- 200
PARAM$rpart$maxdepth <- 9
Score: 56.79288

Intento optimización Bayesiana que justifique hiperparámetros
R CMD BATCH 322_rpart_ternaria_BO_repe_xval.r &
```
  makeNumericParam("cp", lower = -1, upper = -1),
  makeIntegerParam("minsplit", lower = 350L, upper = 450L),
  makeIntegerParam("minbucket", lower = 175L, upper = 225L),
  makeIntegerParam("maxdepth", lower = 8L, upper = 9L),
  forbidden = quote(minbucket > 0.5 * minsplit)
```



No hay tiempo de búsquedas más elegantes
sPodría jugar con el nivel de corte


best ms+= 50
  xval = 0, # no hago cross validation
  cp = -1, # esto significa no limitar la complejidad de los splits
  minsplit = 450, # minima cantidad de registros para que se haga el split
  minbucket = 225, # tamaño minimo de una hoja
  maxdepth = 9 # profundidad maxima del arbol
`./exp/HT3440/k20230910_07`
Score: 53.9229


Al tanteo maxdepth +1
  xval = 0, # no hago cross validation
  cp = -1, # esto significa no limitar la complejidad de los splits
  minsplit = 400, # minima cantidad de registros para que se haga el split
  minbucket = 200, # tamaño minimo de una hoja
  maxdepth = 10 # profundidad maxima del arbol
`./exp/HT3440/k20230910_06`
Score: 48.18295

maxdepth -1
  xval = 0, # no hago cross validation
  cp = -1, # esto significa no limitar la complejidad de los splits
  minsplit = 400, # minima cantidad de registros para que se haga el split
  minbucket = 200, # tamaño minimo de una hoja
  maxdepth = 8 # profundidad maxima del arbol
`./exp/HT3440/k20230910_05`
Score: 54.64623


Ídem. con +1 maxdepth
  xval = 0, # no hago cross validation
  cp = -1, # esto significa no limitar la complejidad de los splits
  minsplit = 350, # minima cantidad de registros para que se haga el split
  minbucket = 175, # tamaño minimo de una hoja
  maxdepth = 9 # profundidad maxima del arbol
`./exp/HT3440/k20230910_04`
Score: 51.61292

Pruebo el primer valor del grid search
Modifico `modelo_k20230910_02.r`
  xval = 0, # no hago cross validation
  cp = -1, # esto significa no limitar la complejidad de los splits
  minsplit = 350, # minima cantidad de registros para que se haga el split
  minbucket = 175, # tamaño minimo de una hoja
  maxdepth = 8 # profundidad maxima del arbol
`./exp/HT3440/k20230910_03`
Score: 51.49625


Hice un grid search en torno al mejor valor de minsplit (400)
eGS.r
- ms \pm 50
- mb = ms/2
- md (depth) el mismo (9) y probé bajar uno a 8
     tiempo cp  mb  ms md      gan
1: 60.29366 -7 175 350  8 61922000
2: 66.24819 -7 175 350  9 60074000
3: 66.09959 -7 200 400  9 58776667
4: 60.08216 -7 200 400  8 58711333
5: 59.35792 -7 225 450  8 57288000
6: 65.23138 -7 225 450  9 56574000


OK! -> diff exp/HT3440/k20230910_01.csv exp/HT3440/k20230910_02.csv -> ¡NADA!
Verificar: cp= -1 es lo mismo que -7
Encontre una fuent sobre que demonios en el [complexity parameter (cp)](https://cran.r-project.org/web/packages/rpart/vignettes/longintro.pdf)  
Pero no hay un joraca claro en la documentación de Rpart.
Solo buscaba el como interpreta valoren negativos y no lo encuentro.
HT3440/k20230910_02
  xval = 0, # no hago cross validation
  cp = -1, # esto significa no limitar la complejidad de los splits
  minsplit = 400, # minima cantidad de registros para que se haga el split
  minbucket = 200, # tamaño minimo de una hoja
  maxdepth = 9 # profundidad maxima del arbol
)
Mismo resultado


OK!  -> Mismo score
Verificar: quitar cross validation no cambia el resultado
HT3440/k20230910_01
  xval = 0, # no hago cross validation
  cp = -7, # esto significa no limitar la complejidad de los splits
  minsplit = 400, # minima cantidad de registros para que se haga el split
  minbucket = 200, # tamaño minimo de una hoja
  maxdepth = 9 # profundidad maxima del arbol
)
Score: 56.79288


## 2023-09-09
BO no sirvió para mejorar


HT3440/k20230909_07
  xval = 5, # no hago cross validation
  cp = -7, # esto significa no limitar la complejidad de los splits
  minsplit = 400, # minima cantidad de registros para que se haga el split
  minbucket = 200, # tamaño minimo de una hoja
  maxdepth = 9 # profundidad maxima del arbol
Score: 56.79288

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
