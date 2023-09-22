# Journal

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
- esendero para qu apunte al nuevo crudo `df = CSV.read("../../datasets/competencia_02_crudo.csv.gz", DataFrame)

`
Con cd al directorio donde está el script de Julia (para ahorrarse el problema de los senderos relativos) ejecuté
```
~/documents/universitet/FCEyN/maestríaDatos/economíaFinanzas/dmeyf2023/zweite$ ~/bin/julia-1.9.3/bin/julia ./clase_ternaria_juan_raman.jl 
```

### **PENDIENTE** subir el dataset a la máquina virtual
1. Abro el [bucket el sendero normanbuck/datasets](https://console.cloud.google.com/storage/browser/normanbuck/datasets) en la interfaz web de Google Cloud 
1. Uso la opción `Upload files` para subir el archivo `competencia_02.csv.gz` generado en el paso anterior.



### **PENDIENTE** z521_ArbolesAzarosos
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
