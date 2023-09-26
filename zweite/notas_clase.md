# Notas de clases

## 2023-09-25

### Chisme
- recordar que se puede seleccionar con que meses entrenar
- sacar la pandemia
- sacar dos meses finales y primeros


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
 