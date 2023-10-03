# Notas de clases


## 2023-10-02

## Interpretación de modelos (monday/z801 -> zweite/801_Sobre_Intepretabilidad.ipynb)
- Hasta ahora con interpretación de variables
- SHAP values, basado en teória de juegos cooperativos
  - No se ve el modelo en su conjunto
  - Se ven casos individuales


## Video de Miranda
- Hay que encontrar la "estructura" de la gente que se va (deja de ser cliente del banco)
  - Sería una interpretación de los features con más importancia que inciden en el BAJA+2
- < 5'
  - hay que ser muy limitado
  - muy coherente 
  - repetir varias veces
- Básicamente es verbalizar
  - Solo se muestra gráfico si es más difícil expresarle en palabras
- Mitad izquierda de pantalla: bullet points
  - derecha: cámara
- Es la directora de Marketing
  - De ella dependen gerencias.
  - Nosotros dependendemos de una de ellas con otros 20 colegas.

- Ir rápido al hueso y mostrar que lo hecho resuelve los problemas del interlocutor
- Demostar confianza.
- Convencer al interlocutor, llevar o convencer.
- Tener la capacidad de entender lo que está pasando para poder transmitir la escencia con claridad.

- Objetivo
  - Transmitir los descubrimientos hechos que sirvan para marketing

- Costo
  - Clientes que recibirán incentivo 10k
  - Incentivo (envíos) 7k$
  - durante meses 12
  - 10k * 7k * 12 = 840M$
    - Hay que convencer a alguién que invierta esa cantidad en la estratégia que propongo


### ¿Qué se puede ajustar?
1. features -> enfocarse en generarles, e.g.
  - ctrx_active -> media, diferencia, etc.
2. cantidad de meses que se ponen en el entrenamiento
  - Ojo que muchos meses lleva a corridas muy largas
  - Hay por ahí un archivo que comenta meses que funcionaron en competencias pasadas.
  - En la optimizacinón Bayesiana se hace undersampling (se toman menos meses), pero el entrenamiento final es con todos los meses.
3. parámetros
  - lightgbm más allá de los que ya trabajamos  -> no tocar
  - modificar los que veníamos trabajando, e.g.
    - feature_fraction



## 2023-09-25

### Chisme
- recordar que se puede seleccionar con que meses entrenar
- sacar la pandemia
- sacar dos meses finales y primeros
- si vacía cuenta es un indicador fuerte



### Información histórica
Crear variables "a lo pavo". Hay varias alternativas:
- Variable delta
  - alternativa: ratio \(\frac{m_0 - m_{-1}}{m_0}\)
- Media móvil
- Lags: (autocorrelacinón) correr 3, 6, 9 o 12 meses la serie
- mínimo o máximo de una variable
- Tendencia
  - \(\beta\) la pendiente (SQL tiene SLOPE)
  - RFM (?)
  - actual sobre promedio semestre \(\frac{m_0}{m_{1-6}}\)
  - \(\frac{m_0 + m_1 + m_2}{ m_3 + m_4 + m_5}\) promedio trimestral actual vs anterior
- Auto feature engineering (auto ML)


### Overfitting
- Evitar modelos complejos (e.g. en árboles -> prunning)
  - elección de hiper-parámetros, entrenando muchas veces con (alternativas)
      - partición train/test 
      - montecarlo
      - k-fold CV
      - N repeat k-fold
      - leave one out
- Combatir data drifting (¿Qué es?)
- Poda (prunning) con variable "canarito"
  - distribución uniforme en [0,1], no correlaciona con nada en el conjunto de datos
  - se inyectan cientos de estas en el dataset
  - se obtiene el árbol con hiper-parámetros conocidos
  - Si el árbol funciona bien una variable "canarito"
    - **solo** debiera aparecer en nodos terminales, o anidados,
    - **no** debe tener precedencia sobre otras variables en el árbol (que aparezca la decisión por una de estas cerca de la raíz)
    - esto es **corta por un canarito** (mal)
  - Propuesta **matar** toda rama debajo de un canarito, dejando que el árbol no tenga limitación para crecer
    - Se hace feature-engineering mucho más rápido
    - No usa train/test
    - Ver código z487
    - Sólo requiere optimizar parámetros que no regulan el crecimiento del árbol (estos hacen )

False Discovery Rate
    Emanuel Candes

- **Bottom line** 
  - Usar **canaritos asesinos** (de la primer competencia)
  - Determinar cuales son las variables/features con mayor relevancia
  - **Matar** las que no aportan
  - Poner a prueba los **cientos** que uno puede inventar 


  ### MLOps
  LLevar de un modelo a un proceso de producción
  - E.g. no usar un notebook -> scripts completos ejecutable de corrido
  - Raíz del término: DevOps que automatizó el procesos
  - Con la misma idéa surgió el término DataOps
    - Y de allí MLOps referido a machine learning
      - produccinón
        - ETL (Exctract Transform Load) origen - transformación - destino : data warehouse 
        - ELT: ídem. pero procesando in situ (en el warehouse)
      - feature engineering
        - primero las calculadas
        - luego las históricas
        - si se quiere hacer imputación, sería en este paso
      - data quality (que no aparezcan nuevos atributos)

- Tendría que ser capaz de replicar este esquema en la competencia
  - E.g. utilizar otra forma de validar que no sea cross-validation
    - E.g. Probar estrategia de validación en el futuro parandome en 201905 y viendo hacia 202105 (fin de la serie)

- **Competencia** sugerencias
  - Ver que una ventana de algunos meses es útil, e.g. no más de 5 meses