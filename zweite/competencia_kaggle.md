# ¿Qué se anuncia en Kaggle
[Kaggle | DMEyF 2023 Segunda](https://www.kaggle.com/competitions/dmeyf-2023-segunda/overview)



## Overview 
Overview

Competencia

Esta es la SEGUNDA competencia de la materia Data Mining en Economia y Finanzas, edición 2023, de la Maestría en Explotación de Datos y Descubrimiento del Conocimiento, Universidad de Buenos Aires

La competencia finaliza el domingo 15-octubre-2023 23:59:59 , hora de Buenos Aires
Dataset

Para acceder al dataset , consultar el stream #cartelera en Zulip -> [Zulip | cartelera > Kaggle 02](https://dmeyf2023.zulip.rebelare.com/#narrow/stream/389-cartelera/topic/Kaggle.2002)

>Gustavo Denicolay: @everyone
>Se ha lanzado la SEGUNDA competencia Kaggle de la asignatura

    >El link invitacion es https://www.kaggle.com/t/c35d05ad538b44ef81f443bc32efd720 , deben presionar el boton negro que dice Join Competition
    >El dataset de la competencia, que contiene los 31 periodos [201901, 201907 ] se encuentra en https://storage.googleapis.com/open-courses/dmeyf2023-8a1e/competencia_02_crudo.csv.gz

>Gustavo Denicolay: El dataset de la SEGUNDA competencia posee 31 periodos, con lo cual no les sera posible procesarlo desde sus laptops
>Para ello, dentro de unas horas se disponibilzara un instructivo para se den de alta en la plataforma Google Cloud y trabajen en maquinas virtuales en la nube
>En Google Cloud trabajaran con la Segunda Compentencia y tambien con La Competencia Final , haganse amig@s de Google Cloud !


El período [201901, 202105] es donde se debe entrenar

El período 202107 es donde se debe aplicar el modelo.
Ganancia en el leaderboard

La ganancia en el leaderboard está expresada en MILLONES de pesos argentinos.
Objetivo

El objetivo es predecir que clientes de Paquete Premium de la foto al 31-jul-2021 se darán de baja durante agosto-2021, es decir predecir las BAJA+2 de la foto de 202107
Funcion Ganancia

La ganancia, la misma de la primera competencia, está definida como

ganancia = 273000 * "BAJA+2" - 7000 * ( "BAJA+1" + "CONTINUA" )
Objetivos Pedagógicos

    Aprender a trabajar con "grandes" volumenes de datos : millones de registros y miles de columnas, ganar destreza con la plataforma Google Cloud
    Análisis Exploratorio de los datos históricos
    Detectar catástrofes en los datos, y resolverlas
    Enfrentarse al Data Drifting en todo su esplendor, y resolverlo razonablmente
    Aprender el arte de crear variables históricas
    Entender el poder de entrenar en la union de varios periodos
    Aprender a desarrollar una Training Strategy razonable
    Utilizar la historia para generar workflows que generen modelos estables


## Data
Dataset Description
Descripcion de los datos

La Primera Competencia es una competencia fácil, se dispone solamente de 1 mes de datos para entrenar y solo se puede utilizar los arboles de decisión de la librería rpart

En El Libro de la Asignatura se encuentra el link para bajar el dataset y el diccionario de datos




Campos del archivo de salida

    numero_de_cliente el id del cliente
    Predicted un 0 o un 1 que indica si se le debe hacer el estimulo al cliente


## Rules
Rules

    Se podrá utilizar todos los meses de la historia que se deseen.
    Se podrán utilizar las librerías de rpart, ranger, XGBoost, LightGBM
    Se podrá y deberá utilizar optimización de hiperparámetros, ya sea grid search u optimización bayesiana.
    Se podrá utilizar feature engineering hasta donde su ingenio alcance., tanto intra mes como histórico
    No se podrán utilizar ensembles de modelos.
    El modelo final tiene que ser un solo rpart/ranger/xgboost/lightgbm entrenado sobre la unión de varios meses al que se le hizo feature engineering histórico y dentro del mismo mes.
