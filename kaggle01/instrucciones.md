# Instrucciones para generar archivos de la competencia Kaggle 01
Víctor A. Bettachini
2023-09-10

## Generación del `competencia01.csv`
Lo hice con el código en R en un notebook Jupyter `e101_target_sql.ipynb`

## Busqueda de parámetros para rpart
Los últimos los encontró una búsqueda de optimización bayesiana a partir de la clasificación ternaria:
`e322_rpart_ternaria_BO_repe_xval.r` 
Este buscó en un rango acotado centrados en los que había explorado con un grid search, de lo cual no guardé registro.

## Archivo para Kaggle
En el `e366_aplicar_modelo.r` en este directorio figuran los parámetros de la ante-última iteración de la optimización bayesiana.
Estos resultaron en un mejor puntaje público que el último.
