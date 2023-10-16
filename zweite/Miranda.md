# Notas para el video de Miranda

## Parla
Estimada Wintour, le habla Bettachini del Equipo de Datos.

Su dirección comercial nos solicitó un estudio de la cartera de clientes premium.
Es objetivo es determinar a cuales enviarles incentivos para desincentivar su baja.
Maximizar la ganancia que reportaría tal acción requirió calcular para cada cliente la probabilidad de baja dos meses en el futuro. 
Partiendo de datos históricos generamos indicadores con los que entrenamos un modelo numérico.
Logrgamos así identificar cuales de estos indicadores advierten de futuras bajas de clientes individuales.
En este video no comentaré del modelo en si.
Daré una síntesis de los indicadores de comportamiento de los grupos con mayor probabilidad de baja que nuestro modelo identifica.

Para identificar cuales indicadores sobresalen en cada grupo es necesario tener presentes cuales preanuncian bajas en el conjunto de la cartera.
Ninguno sale de lo que podían suponerse a priori, lo que incrementó nuestra confianza en las predicciones que el modelo puede hacer para casos particulares.
- Los indicadores que más preanuncian una posible baja en dos meses son
  - monto y número de transferencias salientes
  - el que no esté adherido a nuestro homebanking, y si lo está, que realice pocas operaciones por el mismo
  - un consistente bajo saldo en cuentas durante un semestre
- En el sentido inverso el modelo también fue capaz de identificar los indicadores más prominentes de continuidad
  - un mayor número de operaciones en el trimestre
  - lo mismo para el número de sueldos percibidos
  - mayor suma del valor monetario de todas las operaciones
Como dije, esto se aplica al conjunto de la cartera.

Paso ahora a individualizar grupos de clientes.
Explicaré que indicadores resaltan por los que se aplican al conjunto de la cartera.
Lo haré para los tres grupos que nuestro modelo muestra con una probabilidad de baja dos meses en el futuro superior al 30%.

El grupo con mayor probabilidad de baja, un 48%, destaca por
- el elevado monto de prestamos personales
- lo que redunda en el monto de rentabilidad que obtenemos de ellos.
Siendo los prestamos personales los de mayor tasa y que el banco está obteniendo una rentabilidad en este grupo por sobre la media, ofrecer una línea de refinanciamiento para estos clientes puede ser una forma de retenerles como clientes.
Para identificarles a cuales clientes dirigir este esfuerzo sugiero emplear el modelo producido por nuestro equipo de datos.
Este ofrece una antelación suficiente para realizar la correspondiente campaña. 

En el segundo grupo, con probabilidad de baja del 43%, no se destacan indicadores de baja particulares de este grupo pero si de continuidad, como
- si se les condedió un acuerdo de descubierto
- montos de consumo con tarjetas de crédito.
Evidentemente a estos clientes les interesa el crédito, pero no a través de prestamos, por lo que ofrecerles líneas de crédito adicionales puede ser una forma de retenerles.
Nuevamente, como sugerí para el grupo anterior, debiera emplearse nuestro modelo para identificar estos clientes y ofrecerles el crédito adicional antes de que se den de baja.

Para el tercer grupo, con una probabilidad de baja del 31%, no sugerimos acción alguna pues muestra indicadores todos coincidentes a la baja
- gran reducción del número y monto total de transacciones en el último trimestre
- reducción del número de sueldos percibidos en el último trimestre
- reducción de consumos en tarjetas de crédito y mora en el pago de las mismas
y todo esto a pesar de contar con acuerdos de descubierto.
Estos serían clientes que ya han decidido darse de baja y no hay nada que podamos hacer para evitarlo.


Este fue un somero análisis de lo que nuestro modelo nos permitió aprender de la cartera premium.
En nombre del Equipo de Datos reitero nuestro interés en trabajar con la Dirección Comercial con el fin de ponerle a su servicio.
Hasta pronto.




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

