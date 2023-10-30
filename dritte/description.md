# DMEyF 2023 Ultima
finaliza 29-nov

## Overview
### Competencia

Esta es la ULTIMA competencia de la materia Data Mining en Economia y Finanzas, edición 2023, de la Maestría en Explotación de Datos y Descubrimiento del Conocimiento, Universidad de Buenos Aires

La competencia finaliza el miércoles 29-noviembre-2023 23:59:59 , hora de Buenos Aires
## Dataset

Para acceder al dataset , consultar el stream #cartelera en Zulip

El período [201901, 202107] es donde se debe entrenar

El período 202109 es donde se debe aplicar el modelo.
## Ganancia en el leaderboard

La ganancia en el leaderboard está expresada en MILLONES de pesos argentinos.
## Objetivo

El objetivo es predecir que clientes de Paquete Premium de la foto al 31-sep-2021 se darán de baja durante noviembre-2021, es decir predecir las BAJA+2 de la foto de 202109
## Funcion Ganancia

La ganancia, la misma de la primera competencia, está definida como

ganancia = 273000 * "BAJA+2" - 7000 * ( "BAJA+1" + "CONTINUA" )

## Objetivos Pedagógicos

-    Aprender a trabajar con "grandes" volumenes de datos : millones de registros y miles de columnas, ganar destreza con la plataforma Google Cloud
-    Análisis Exploratorio de los datos históricos
-    Detectar catástrofes en los datos, y resolverlas
-    Enfrentarse al Data Drifting en todo su esplendor, y resolverlo razonablmente
-    Aprender el arte de crear variables históricas
-    Entender el poder de entrenar en la union de varios periodos
-    Aprender a desarrollar una Training Strategy razonable
-    Utilizar la historia para generar workflows que generen modelos estables
-    Crear ENSEMBLES de modelos

## Evaluation
### Leaderboard publico y privado

El leaderboard publico contiene apenas el 10% de los registros, y el privado el 90% .

La evaluación de la competencia se hace sobre el leaderboard privado, que solo será visible una vez finalizada la competencia.

Se debe tener cuidado con no hacer overfitting en el leaderboard público.

### ¿Qué se ve en el Public Leaderboard?

De todas las predicciones subidas por un usuario a Kaggle, en el Public Leaderboard siempre se muestra la mayor ganancia pública, independientemente de la predicción elegida.


### Selección manual de una predicción

Por default, Kaggle elige como predicción final a la que performa mejor en el Public Leaderboard. Paradojicamente esta no es siempre la mejor elección, ya que en el caso de haber subido muchas predicciones se puede estar "overfiteando el Public Leaderboard". Esto causará gran sorpresa y desazón entre los alumnos, realmente el fenómeno del overfitting es complejo y contraintuitivo.

Para elegir manualmente una opcion, dentro de la competencia Kaggle se debe ir a la solapa My Submissions, y elegir manualmente en la columna Use for Final Score la opción que se desea. En caso que ya tuviera una opcion seleccionada manualmente, deberá primero desmarcarla antes de marcar la nueva.

Es muy importante notar que esta elección manual NO alterará lo que se muestra en el Public Leaderboard, ya que Kaggle siempre muestra la ganancia del mejor submit público, y ahora acabamos de elegir otro submit.

### Formato del archivo

Para cada numero_de_cliente del periodo 202109, los submits deben tener dos columnas separadas por una coma : numero_de_cliente y Predicted.

numero_de_cliente toma los valores de los numero_de_cliente de los clientes de paquete premium del periodo 202109

Predicted toma solamente los valores {0,1} e indica si ese cliente participa de la campaña de retención proactiva de clientes

Se deben entregar 165237 predicciones, que es la cantidad de clientes de paquete premium de 202109

La primer linea del archivo tiene los títulos, con lo cual el archivo debe tener 165237 + 1 lineas

Este es un ejemplo de formato:

numero_de_cliente,Predicted
31124994,1
56656802,0
194088156,0

## Citation
UBA DM EyF. (2023). DMEyF 2023 Ultima. Kaggle. https://kaggle.com/competitions/dmeyf-2023-ultima
