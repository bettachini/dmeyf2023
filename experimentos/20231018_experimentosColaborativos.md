# 2023-10-23

## Estratégias para la competencia
- Imputación de datos 
- Catastrophe analyisis
- Feature engineering intra-mes
- Feature engineering históricos
 
Opciones
- cross validation
- desfasar todo hacia el pasado dejando meses para validar y test al final


## Metamodelo


### Work forward validation
El modelo de Denicolay es train + 1 val + 1 mes test

Hacer tabla con todos los modelos para ensayar
Modelo    fotomes #cliente    probabilidad

Para un mes, tenemos la predicción de una multitud de modelos, ¿cómo elegir resultado?
- promedio (esto anda bien, no gastarse en hacer un stacking)
- votación
- número mínimo de modelos que tienen que estar de acuerdo para enviar


### Bibliotecas ML
"Metan modelos con distintas semillas y los juntan"
 
- Orange
- Vertex AI
- kmime
- Big Query -> AutoML
- H2O





## Experimento colaborativo

### Deadline
11-06


### Semillerío
100 veces... ¿qué?

### Carga de hipótesis en Zulip
Hay que escribir un hilo para empezar la discusión sobre la hipótesis.


# 2023-10-18

## Hacer una sola prueba
-Error: tomar una decisión en base a un único ensayo no capta
    - algo que depende del azar devuelve una distribución
        - con una sola muestra no puede determinarse



## Modelo 3.a competencia
- Vale todo
- Dataset tiene unos meses más
- Experimentos colaborativos
    - que hacen 2 o tres personas (hace uno y hay una contraparte)
    - ensayar posibles soluciones a problemas
        - probar estatégias de combinación de meses
        - semillas
            - medir la disribución: ensamblar salida de múltiples semillas (semillería)
                - modelo con varianza baja y usualmente mayor ganancia (media de ensamble mejor que media distribución)
            -xgboost (gradient boosting): un árbol corrige el anterior
                - el parámetro num_parallel_tree genera N árboles (es la opción por defecto) -> reduce la varianza
                - es más lento que lightGBM (y se multiplica por N el tiempo de procesamiento)
    - baja+N
    - ensembles
        - stacking
            - metamodelo: N modelos los ensamblo con otro modelo
            - trampa: correr todos los modelos con el mismo train y ensayando (test) sobre un conjunto en el futuro cross-vaidation para hacer validación en dos meses más adelante


### Experimentos e hipótesis
- Completar PPT con estructura del experimento
- ver en  2023-10-18-210317_1920x1080_scrot.png y 2023-10-18-211006_1920x1080_scrot.png

### Mi tarea
Libro maestría
    Experimentos colaborativos
        hipótesis
            features historicos (este es mi tema)
    ¿Porque van a generar más ganancia? Se comparará contra un base-line y la conclusión puede ser que no puede mejorarse
        Pensar más de una estratégia

