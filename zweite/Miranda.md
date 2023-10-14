# Notas para el video de Miranda

## Parla
Estimada Wintour, le habla Bettachini del equipo de datos.


? Objetivo: Para los clientes premium buscamos indicadores que anticipen su intención de dejar de ser clientes de esa cartera.



## ¿Cómo se hace lo del clustering?
`801_Sobre_Interpretabilidad.ipynb`



## ¿Quienes?
- Miranda Wintour ... es la directora de Marketing del banco.
- Ich: pinche del área de datos, una dirección que depende de la gerencia de Miranda

## Video

### Motivación

¿Donde encuentro los datos de la posible campaña de marketing?
- Costo
  - Clientes que recibirán incentivo 10k
  - Incentivo (envíos)
    - costo individual 7k$
    - durante meses 12
  - 10k * 7k * 12 = 840M$

- La pérdida por cliente perdido es de 560000, pero como la probabilidad de perderle sin estímulo es de 0.5, la pérdida esperada es de 280000
  - Si se va a pesar del estímulo de 7000 se pierde 7000
  - Si se queda gracias al estímulo de la ganancia potencial de 280000, pero aún se pierden 7000 del estímulo, por lo que la ganancia es 273000 

- ¿Qué son las cantidad de estímulos enviados?
  


### Estudio
- Buscamos tener indicadores dos meses previos a que un cliente se dará de baja
  - Da tiempo para hacer la campaña en el interín.
  - Fuente de esto:
    - El futuro donde se ensaya el entrenamiento es 202107 según `524_lightbm_final.r`
    - Potencialmente se entrena desde 201901 hasta 202105, pues baja+2 implica que solo puede utilizarse hasta dos meses atrás.

