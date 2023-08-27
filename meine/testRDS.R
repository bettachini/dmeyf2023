# Limpiamos el entorno
rm(list = ls())
gc(verbose = FALSE)


## carga datos
copla <- readRDS(file= './datos.rds')

##
copla

## datos
INDICE  <- c( 286.4,	262.1,	248.5,
              285.7,	263.5,	250.2,
              285.1,	264.9,	249.0 )


FECHA  <-  c("Mar-20", "Mar-20", "Mar-20",
             "Abr-20", "Abr-20", "Abr-20",
             "May-20", "May-20", "May-20")

GRUPO  <-  c("Privado_Registrado","Público","Privado_No_Registrado",
             "Privado_Registrado","Público","Privado_No_Registrado",
             "Privado_Registrado","Público","Privado_No_Registrado")

Datos <- data.frame(INDICE, FECHA, GRUPO)

## guarda datos
saveRDS(object= Datos, file= './datos.rds')

Datos
