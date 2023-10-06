# Journal

## Pendientes

### **Pendiente** Features históricos
[Zulip | Instrucciones de Alejandro Bolaños para generarles en SQL](https://dmeyf2023.zulip.rebelare.com/#narrow/stream/401-Code/topic/.5Btip.5D.20features.20historicos.20usando.20SQL)

### **Pendiente** Meseta
Graficar score público vs predictedPositives 

### **Pendiente** Cantidad de envíos
?
[Zulip | cantidad de envíos](https://dmeyf2023.zulip.rebelare.com/#narrow/stream/430-Kaggle-02/topic/cantidad.20de.20env.C3.ADos)

### **Pendiente** Revisar bibliografía:
- Lags?
- rank?


## 2023-10-06

### Búsqueda 
- Para explorar hiperparámetros creo `523_lightgbm_binaria_BO_20231006_01.r` a partir de `523_lightgbm_binaria_BO.r`.
- undersampling
```
PARAM$trainingstrategy$undersampling <- 0.1
```
- pandemia ASPO: elimino 2020-03 a 2020-11 inclusive, pero incluyo resto
```
PARAM$input$training <- c(
  201901, 201902, 201903, 201904, 201905, 201906,
  201907, 201908, 201909, 201910, 201911, 201912,
  202001, 201902,
  202012,
  202101, 202102, 202103, 202104, 202105
)
```
- Rango hiperparámetros  
Veo de última optimización bayesiana los rangos en que oscilaron los valores en `lee_bayesiana.ipynb`, un cuaderno que ejecuta Julia
```
  makeNumericParam("learning_rate", lower = 0.01, upper = 0.15),
  makeNumericParam("feature_fraction", lower = 0.4, upper = 0.8),
```
**ME ARREPIENTO**, son muy variables en mi corrida y spione muestra que valores que iba a descartar son útiles.
- Hay que laburar features

### Features



## 2023-10-04

### Quitar meses pandemia entrenamiento
- ¿Entrenamiento u optimización de hiperparámetros?

- ASPO en CABA desde 2020-03-20 hasta 2020-11-09 [wikipedia | Medidas sanitarias por la pandemia de COVID-19 en Argentina](https://es.wikipedia.org/wiki/Medidas_sanitarias_por_la_pandemia_de_COVID-19_en_Argentina)



#### Me intriga si está prediciendo solo para clientes_vip
¡Solo 0.004415699974357906 son cliente_vip



#### Explorar dataset
Excelente...no tengo idea siquiera de que hay en el dataset -> `exploro_dataset.jl` 
- ¿Qué meses cubre?
  - 201901 a 202107
- ¿Qué atributos tiene?
  - Sé que existe una planilla de cálculo que los describe -> `economíaFinanzas/datasets/Diccionario de datos.ods`
  - 154 atributos
    - 1 a 110 : cosas
    - 111 a 132 (21): master(card)
    - 133 a 154 (21): visa
- `exploro_dataset.jl`
  - 4562810 registros x 155 columnas
-
Bueno... Estoy en el horno... Juguemos con Julia a ver cuanto tardo en aprender a leer el daset y entender su timespan.
- creo `exploro_dataset.jl`
- instalo en sih Extension: Julia
- `import Pkg; Pkg.add("CSV")`
- `import Pkg; Pkg.add("DataFrames")`



## 2023-09-25

### Primer optimización bayesiana | Kaggle submit
T1300Z-3 | Descarga de resultados 
1. Al directorio local de corridas `cd ~/documents/universitet/FCEyN/maestríaDatos/economíaFinanzas/normanbuck/exp/`
1. Descargo resultados de ejecucion con `gsutil -m cp -r "gs://normanbuck/exp/KA5240"`

Instalación de CLI de Kaggle
1. Sigo instrucciones en [Kaggle | How to Use Kaggle](https://www.kaggle.com/docs/api) que apuntan a [GitHub | Kaggle API](https://github.com/Kaggle/kaggle-api)
1. Instale con `pip install kaggle` el En el environment python en `~/bin/jupyter/bin/` jupyter para 
1. Creo kaggle.json token en [Kaggle | account](https://www.kaggle.com/settings/account) en la opción `Create new token`
1. Muevo el `kaggle.json` descargado a `~/.kaggle`
1. En [Kaggle | Submissions](https://www.kaggle.com/competitions/dmeyf-2023-segunda/submissions) muestra cada vez que se hace un submit el comando

T1330Z-3 | Carga en Kaggle de resultados 
1. `cd ~/documents/universitet/FCEyN/maestríaDatos/economíaFinanzas/normanbuck/exp/KA5240_20230925T1404Z-3`
1. `kaggle competitions submit -c dmeyf-2023-segunda -f KA5240_12500.csv -m "KA5240_12500_20230925T1404Z-3"` siendo `KA340_xxxxxx.csv` todos desde el 8k al 13k5 en saltos de 500
1. ¿Qué hacer con .RData? Es 0.5 GB y no sé que uso puede tener
  1. @sih `mkdir ~/storage/grandes_normanbuck/exp`
  1. `mv ~/documents/universitet/FCEyN/maestríaDatos/economíaFinanzas/normanbuck/exp/KA5240_20230925T1404Z-3/.RData ~/storage/grandes_normanbuck/exp/KA5240_20230925T1404Z-3/`



### `524_lightgbm_final.r` | ejecución
1. copia de `dmeyf2023/src/z524_lightgbm_final.r` a `dmeyf2023/zweite/524_lightgbm_final.r`
1. Hiperparámetros tomados de última línea de `/normanbuck/exp/HT5230_20230925T0024Z-3/HT5230.txt` copiados en fuente
```
PARAM$finalmodel$semilla <- 274837  # UNSERE 2.a semilla

PARAM$finalmodel$num_iterations <- 895
PARAM$finalmodel$learning_rate <- 0.112605189048028
PARAM$finalmodel$feature_fraction <- 0.458278684659049 
PARAM$finalmodel$min_data_in_leaf <- 633
PARAM$finalmodel$num_leaves <- 868
```
No hay cambios de `PARAM$finalmodel$max_bin <- 31`
1. git push
1. T1324Z-3 | activación VM desktop
1. `cd dmeyf2023/zweite`
1. T1327Z-3 | `R CMD BATCH 524_lightgbm_final.r` 



## 2023-09-24

###  `z523_lightgbm_binaria_BO.r` | ejecución detenida
1. VM suspendida 0315Z-3
1. Descargo 0633Z-3 lo que se encuentra en `normanbuck/exp/HT5230`
```
gsutil -m cp -r \
  "gs://normanbuck/exp/HT5230" \
  .
```
1. start/resume 0638Z-3
1. Copia de resguardo de `normanbuck/exp/HT5230` -> `normanbuck/exp/back_HT5230` (o back2)
1. Verifiqué que se realiza append a registro (log) de hiperparámetros/ganancia en archivo `normanbuck/exp/HT5230/HT5230.TXT` 
1. VM suspendida 1439Z-3
1. Copia de resguardo de `normanbuck/exp/HT5230` -> `normanbuck/exp/HT5230_20230924T1603Z-3`
1. start/resume 1603Z-3




## 2023-09-23

###  `z523_lightgbm_binaria_BO.r` | ejecución [?]
1. copio `src/lightgbm/z523_lightgbm_binaria_BO.r` a `zweite/523_lightgbm_binaria_BO.r`
1. única modificación
```
PARAM$trainingstrategy$semilla_azar <- 777787 # Aqui poner su  primer  semilla
``` 
1. push para que esté disponible en `desktop`. No es necesario el pull, siempre le encuentro actualizado tras iniciar la máquina (no sé si será una revisión períodica o solo al iniciar)
1. inicio ejecución 1752Z-3. 
1. Generó `normanbuck/exp/HT5230`
1. **ERRROR** Olvidé 2.a semilla -> **LEER TODO EL CÓDIGO ANTES DE ENVIAR A EJECUTAR**
```
# Aqui poner su segunda semilla
PARAM$hyperparametertuning$semilla_azar <- 274837
# PARAM$hyperparametertuning$semilla_azar <- 200177
```
1. Interrumpí ejecución 1907Z-3
1. Tras cambiar fuente le hice push y manualmente en desktop el correspondiete pull.
1. Borré `~/bucket/b1/exp/HT5230`
1. Inicio ejecución 19010Z-3
1. Verifico en [Google Cloud | Cloud Storage | Buckets](https://console.cloud.google.com/storage/browser/normanbuck/exp) que se generó nuevamente `~/bucket/b1/exp/HT5230`


### z521_ArbolesAzarosos | ejecución -> normanbuck/exp/KA5210 [~ 1 h]
En `z521_ArbolesAzarosos.r` figura este encabezado
```
# Ensemble de arboles de decision
# utilizando el naif metodo de Arboles Azarosos
# entreno cada arbol utilizando un subset distinto de atributos del dataset
```

Estos fueron los pasos para la ejecución y subida de resultados a Kaggle:  

1. Conecté con la máquina virtual `desktop` a través de RDP (con el software Remmina) pues no pude conectar vía ssh al IP externo (indicó que se rechazada conexión en puerto 22)
1. cd ~/dmeyf2023/zweite
1. `./R CMD BATCH 521_arboles_azarosos.r &`
1. Cerré la conexión
1. Monitoree la actividad en la [Compute engine / VM Instances / desktop / observability](https://console.cloud.google.com/compute/instancesDetail/zones/southamerica-east1-b/instances/desktop?project=dmeyf2023&tab=monitoring)
1. Al bajar a cero la utilización de la CPU estaban las salidas listas para bajar
1. En `cloud storage / buckets / normanbuck / exp` podían bajarse los archivos en forma individual. Para bajar todos instalé google cloud CLI (ver notasGoogleCloud.md)
1. Creeado `~/documents/universitet/FCEyN/maestríaDatos/economíaFinanzas/normanbuck/` que mantendrá un espejo de lo que está en Google Cloud
1. `cd ~/documents/universitet/FCEyN/maestríaDatos/economíaFinanzas/normanbuck/exp` 
1. Utilicé gsutil para transferir los resultados guardados en directorio KA5210
```
gsutil -m cp -r \
  "gs://normanbuck/exp/KA5210" \
  .
Copying gs://normanbuck/exp/KA5210/.RData...
Copying gs://normanbuck/exp/KA5210/KA5210_010.csv...                            
Copying gs://normanbuck/exp/KA5210/KA5210_001.csv...                            
Copying gs://normanbuck/exp/KA5210/KA5210_005.csv...                            
Copying gs://normanbuck/exp/KA5210/KA5210_100.csv...                            
Copying gs://normanbuck/exp/KA5210/KA5210_200.csv...                            
Copying gs://normanbuck/exp/KA5210/KA5210_050.csv...                            
Copying gs://normanbuck/exp/KA5210/KA5210_500.csv...
```
1. Cargué un Kaggle manualmente las siete salidas.
1. Mejor puntaje    `KA5210_200.csv  Score: 135.10165`
Copio debaje los parámetros que figuran en el fuente
```
PARAM$semilla <- 777787

PARAM$feature_fraction <- 0.5

PARAM$num_trees_max <- 500

  "cp" = -1,
  "minsplit" = 250,
  "minbucket" = 100,
  "maxdepth" = 14

    xval = 0,

    umbral_corte <- (1 / 40) * arbolito
```
el `_200` se refiere al tamaño de ensemble grabado en disco, aunque se hayan generado 500 en la corrida.


## 2023-09-22
Tuve que recurrir a una consulta de un compañero en WA para saber donde empezar:
Instrucciones en [Zulip | Cartelera](https://dmeyf2023.zulip.rebelare.com/#narrow/stream/389-cartelera)  
> Gustavo Denicolay: @everyone
>Se ha lanzado la SEGUNDA competencia Kaggle de la asignatura
>
>    El link invitacion es https://www.kaggle.com/t/c35d05ad538b44ef81f443bc32efd720 , deben presionar el boton negro que dice Join Competition
>    El dataset de la competencia, que contiene los 31 periodos [201901, 201907 ] se encuentra en https://storage.googleapis.com/open-courses/dmeyf2023-8a1e/competencia_02_crudo.csv.gz
>
>Gustavo Denicolay: El dataset de la SEGUNDA competencia posee 31 periodos, con lo cual no les sera posible procesarlo desde sus laptops
>Para ello, dentro de unas horas se disponibilzara un instructivo para se den de alta en la plataforma Google Cloud y trabajen en maquinas virtuales en la nube
>En Google Cloud trabajaran con la Segunda Compentencia y tambien con La Competencia Final , haganse amig@s de Google Cloud !


### Unirse a la competencia 
Al unirme a [Kaggle | DMEyF 2023 Segunda](https://www.kaggle.com/competitions/dmeyf-2023-segunda) se me indicaron estas Condiciones  
>    Se podrá utilizar todos los meses de la historia que se deseen.
>    Se podrán utilizar las librerías de rpart, ranger, XGBoost, LightGBM
>    Se podrá y deberá utilizar optimización de hiperparámetros, ya sea grid search u optimización bayesiana.
>    Se podrá utilizar feature engineering hasta donde su ingenio alcance., tanto intra mes como histórico
>    No se podrán utilizar ensembles de modelos.
>    El modelo final tiene que ser un solo rpart/ranger/xgboost/lightgbm entrenado sobre la unión de varios meses al que se le hizo feature engineering histórico y dentro del mismo mes.


### Descarga dataset
El [dataset en crudo](https://storage.googleapis.com/open-courses/dmeyf2023-8a1e/competencia_02_crudo.csv.gz)
lo descargué en `/home/vbettachini/documents/universitet/FCEyN/maestríaDatos/economíaFinanzas/datasets/`


No intento utilizar para esto el repositorio git para mantener el .gitignore original que no permite subir .csv o .csv.gz


### Clase ternaria
WA | Maxi Beckel 
> Yo ando medio trabado con el calculo de la clase ternaria. Me tirarían un centro? 😬 Vi lo que subio Alejantro a Zulip pero todo lo que hago da error o devuelve algo raro

Alejandro Bolaño proveyó en [Zulip | Code > [tip] Ayuda para crear el target ](https://dmeyf2023.zulip.rebelare.com/#narrow/stream/401-Code/topic/.5Btip.5D.20Ayuda.20para.20crear.20el.20target) una solución basada en SQL.


WA | Cele  
> hola! yo usé un código de zulip que creo subio juan raman (?). está en julia, yo ni idea de julia pero lo calcula perfecto

La extensión de un código fuente de Julia es `.jl` Por tanto volqué [Zulip | Code > clase_ternaria en JULIA ](https://dmeyf2023.zulip.rebelare.com/#narrow/stream/401-Code/topic/clase_ternaria.20en.20JULIA) a `clase_ternaria_juan_raman.jl`


### Let's run Julia
`sudo apt install julia` threw a `No Debian install candidate`, so let's download the installer from the [Julia website](https://julialang.org/downloads/).
Downloaded the 64 bit Generic Linux on x86 for glibc version as I read that [musl is still somewhat flunky](https://www.reddit.com/r/voidlinux/comments/muoqis/what_are_the_advantages_of_using_musl_in_place_of/)

Descomprimí en `~/bin/` con lo que el sendero al ejecutable `~/bin/julia-1.9.3/bin/julia`
VSCode: instalé la extensión y establecí el sendero. 

Al ejecutar el .jl indica que no tiene el paquete CSV y el como instalarle. En terminal abrí el interprete de Julia y comandé `import Pkg; Pkg.add("CSV")`.
Ídem con DataFrames, `import Pkg; Pkg.add("DataFrames")`

Hice una corrida primero con el dataset de la primer competencia cambiando el sendero relativo. Verifique que en la salida se agregó la columna de clase ternaria con `head competencia_01_julia.csv`

Modifiqué
- sendero para que apunte al nuevo crudo `df = CSV.read("../../datasets/competencia_02_crudo.csv.gz", DataFrame)

`
Con cd al directorio donde está el script de Julia (para ahorrarse el problema de los senderos relativos) ejecuté
```
~/documents/universitet/FCEyN/maestríaDatos/economíaFinanzas/dmeyf2023/zweite$ ~/bin/julia-1.9.3/bin/julia ./clase_ternaria_juan_raman.jl 
```

### subir el dataset a la máquina virtual
1. Abro el [bucket el sendero normanbuck/datasets](https://console.cloud.google.com/storage/browser/normanbuck/datasets) en la interfaz web de Google Cloud 
1. Uso la opción `Upload files` para subir el archivo `competencia_02.csv.gz` generado en el paso anterior.



### z521_ArbolesAzarosos | establecer parámetros
WA | Verónica Lombardo
> sos del lunes no se si es lo mismo que nosotros, son dos mundos distintos, pero en nuestro caso para poder subir un intento primero tuvimos que armar la clase ternaria, después el camino más rápido es usar árboles azarosos, te arma 6 salidas rapidamente, sino optimización bayesiana que tarda una banda

WA | Ismael Marchesini
> Buenas! consulta, los que corrieron z521_ArbolesAzarosos en google cloud, les corrió de una o les tiró algun error?

1. Copié de /src a /zweite `z521_ArbolesAzarosos.r` 
1. le renombre quitándole el z
1. Semilla
```
# Establezco la semilla aleatoria, cambiar por SU primer semilla
PARAM$semilla <- 777787
```

A través de git le hice un pull en la máquina virtual `desktop`
