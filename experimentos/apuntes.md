
## Clase ternaria
Código `dritte/ternaire.jl` de Juan Raman con agregado de Federico Idoeta.  


## Clase plenaria Denicolay
20231102 (resumen)

### Semillerío
El modelo debe
- hacerse con semillerío, un centenar (125) de corridas con semillas distintas
    - Esto para el modelo final, no para la optimización
    - Promediar la salida, es decir, votar por mayoría entre continua y alternativa
- Meses: una decena, sino un año
- Feature engineering: con ganas
- Quality & drifting: limpieza y corrección por inflación de datos primarios
- No dejar de hacer optimización Bayesiana, que puede hacerse sobre una sola semilla

- Para el análisis de los experimentos
- Utilizar los resultados del semillerío medidos sobre test
    - Histograma de ganancias no del centenar de semillas, sino de una submuestra
    - Se comparan contra la distribución del baseline (modelo malo)
    - El objetivo es mostrar que hay una distribución (modelo que se supone una mejora) separable de aquella del del baseline


### Espacio para optimización Bayesiana
Estos son valores medios que dió Bolaños. Si no tengo otro mejor obtenido por optimización, usarle.
- min data in leaf: 40 a 5000
- feature fraction: 0.2 a 0.8
- min leaves = 15 a 300



## Baseline
[2023-11-03 Bolaños](https://dmeyf2023.zulip.rebelare.com/#narrow/stream/435-Experimentos-Colaborativos/topic/Baseline.20-.20Modelo.20colaborativo.20final)  
> El pueblo voto. Sobre los scripts base z82*:
> Testing 202107, 1 mes de validación, 6 meses de train
> Sin undersampling.
> Agregar las variables Lags 1, 3 y 6 


### Optimización Bayesiana
No tendría sentido "quemar" el mes de test que se usará con el modelo final al momento de optimizar hiperparámetros.
Entonces sería más razonable usar 202106 como test.


## Enlaces
- [ Nuestra Presentación | Google Docs](https://docs.google.com/presentation/d/10rIRzFYEmKURCz5yBybp4ohgJqjXpc4H8l5JDIgfYC4/edit?usp=sharing)
- [Cohorte B | Google Docs](https://docs.google.com/presentation/d/1ptfmnzmqtBhAam7DEDT-a4HcHWIHroYqhF5cuA3lrsI/edit)


## Bibliografía
Ver zotero

Problema #16 sobre feature enginering histórico

Grupo A

__Hipótesis__
La planificación para "bajarse" de un banco no es de largo plazo. Si hay cambios de comportamiento no se ven más allá de un trimestre.

__Diseño experimental__
Puesto que el interrogante no apunta a nada estacional no quiero confundir el efecto con nada estacional.
Por esa razón no me extiendo más de un semestre.
Tendré una conclusión si puedo responder a si ¿difiere la ganancia de un feature engineering histórico con lag hasta 3 meses que con 6?

Compararé la ganancia resultante de haber incorporado estos features:
- min, max, avg, lags = 1 a 3 o 6 meses atrás, (actual - lags), actual/ avg
- Para datos monetarios (m)
    - cuentas = ['mcuenta_corriente_adicional','mcuenta_corriente','mcaja_ahorro','mcaja_ahorro_adicional','mcaja_ahorro_dolares','mcuentas_saldo']
    - actividad = suma de abs(monetarios, no tarjetas)
    - sueldos = ['mpayroll',] # casi no hay mpayroll2
    - consumos_tarjetas = ['mautoservicio', 'mtarjeta_consumo',] # debito, crédito
    - débitos_automaticos = ['mdebitos_automaticos']
- Para datos enteros (c) unos indicadores de saldos negativos:
    - mcuentas_saldo_neg < 0
    - mcuenta_otras_neg < 0


