# Journal

## 2023-11-16
`dritte/823_1217.r`



`dritte/824_1217.r`
No necesita cambiar el dataset pues lo generado para el experimento debe funcionar.

Cambié
- mes objetivo de 202107 a 202109

Hay que cambiar
- rango de meses de entrenamiento
  - agregué 202107 y 202108 
- bagging
- promediado de probabilidades por semilerio



## Error número de predicciones para enviar a Kaggle
Al intentar hacer un envío a Kaggle me da el error de que está incorrecto el número de predicciones.

En competencias
- [Anteriores](https://www.kaggle.com/competitions/dmeyf-2023-segunda)
  - El período [201901, 202105] es donde se debe entrenar
  - El período 202107 es donde se debe aplicar el modelo.
  - El objetivo es predecir que clientes de Paquete Premium de la foto al 31-jul-2021 se darán de baja durante agosto-2021, es decir predecir las BAJA+2 de la foto de 202107
  - Se deben entregar 164682 predicciones, que es la cantidad de clientes de paquete premium de 202107
- En esta [tercera](https://www.kaggle.com/competitions/dmeyf-2023-ultima/overview)
  - El período [201901, 202107] es donde se debe entrenar
  - El período 202109 es donde se debe aplicar el modelo.
  - El objetivo es predecir que clientes de Paquete Premium de la foto al 31-sep-2021 se darán de baja durante noviembre-2021, es decir predecir las BAJA+2 de la foto de 202109
  - Se deben entregar 165237 predicciones, que es la cantidad de clientes de paquete premium de 202109

Con lo que vengo usando genero predicciones para 164682, el número de 202107.  
Parece cuestión de simplemente actualizar en z824 a
``` 
PARAM$input$future <- c(202109) # meses donde se aplica el modelo
```

## De experimentos

### Que hacer
De la clase del 2023-11-12 me quedaron estos puntos:
- no usar undersampling
- usar bagging (ver lo que hizo Malena)
- usar promediado de probabilidades por semilerio (ídem. Vanesa)
- sería razonable hacer unos ~1000 variables por feature engineering histórico (llegué a ~2200 en FEH2)



### Reciclando lo hecho para los experimentos
2023-11-13

Corté la optimización para el modelo más eleborado por ingeneriá de características históricas (FEH2). En la curva de validación se ve un mejor desempeño para 11500 envios.  
Descargué `https://storage.cloud.google.com/normanbuck/exp/all6_zweite_824/all6_zweite_824_10_11500.csv`.

```
cd ~/downloads
source ~/bin/jupyter/bin/activate
kaggle competitions submit -c dmeyf-2023-ultima -f ./exp_all6_zweite_824_all6_zweite_824_10_11500.csv -m "824_all6_zweite_824_10_11500.csv"
```
Pidió cambiar el permiso de la llave de la API de Kaggle: `chmod 600 /home/vbettachini/.kaggle/kaggle.json`


## Envios Kaggle
```
kaggle competitions submit -c dmeyf-2023-ultima -f submission.csv -m "Message"
```

