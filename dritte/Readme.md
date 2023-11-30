# Orden de ejecución
Códigos utilizados para generar el archivo entregado `dritte824_1129_nullSeeds_9500.csv` con lo que logré mi mejor puntaje público en la competencia.   
Todos los códigos están alojados en el directorio `dritte/` en [mi repositorio en GitHub para la asignatura](https://github.com/bettachini/dmeyf2023/).

1. Creación de variable objetivo, catastrophe analysis y feature engineering histórico    
- Cuaderno Jupyter con código Python que a través de la extensión JupySQL opera sobre implementación SQL DuckDB `sql_eng_all6cat.ipynb`.
- Parte de csv de datos en crudo `competencia_03_crudo.csv.gz` (708.3 MB).
- Genera `competencia_03_all6cat.csv.gz` (12.6 GB).

2. Optimización Bayesiana de hiperparámetros de lightgbm  
- Código en lenguaje R `823_1127null.r`.
- Parte de `competencia_03_all6cat.csv.gz`.
- Genera, entre otros, `BO_log.txt` del que se leen los hiperparámetros con mayor puntaje ensayados para foto_mes = 202106.

3. Entrenamiento de modelo lightgbm con hiperparametros optimizados
- Código en lenguaje R `824_1129null.r`.
- Parte de `competencia_03_all6cat.csv.gz`.
- Genera predicciones de probabilidad de BAJA+2 en foto_mes = 202109 de cada número_de_cliente en archivos `predicción_##.txt` con ## = 01 a 18 numerando distintas semillas utilizadas.

4. Ensamble de predicciones
- Código en lenguaje R (markdown) `1129null_sm.rmd`.
- Parte de los archivos `predicción_##.txt` con ## = 01 a 18.
- Genera archivos `dritte824_1129_nullSeeds_######.csv` con la predicción final binarizada (BAJA+2 o no) para foto_mes = 202109 para el número de envíos indicado por ###### en el nombre del archivo.