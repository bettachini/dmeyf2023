# I try to create a subset of competencia_02.csv.gz

# Adaptación de z523

# Aqui se debe poner la carpeta de la computadora local
working_directory <- "../normanbuck/datasets/"
if (getwd() != working_directory) {
  setwd(working_directory)
}


# load library to read csv.gz
library(data.table)


## Carga micro dataset
PARAM <- list()
PARAM$input$dataset <- "competencia_02_3.csv.gz"
# cargo el dataset donde voy a entrenar el modelo
dataset3 <- fread(PARAM$input$dataset)

## exploratory data analysis
head(dataset3)

## datatypes per column
sapply(dataset3, class)

## get columns that are numeric
numeric_columns <- sapply(dataset3, is.numeric)

## select numeric columns
dataset3_numeric <- dataset3[, numeric_columns, with = FALSE]
dataset3_numeric 

## crea una columna de variación







## Generate subset to perform tests without overloading the computer
#------------------------------------------------------------------------------

## Carga Todo el dataset

PARAM <- list()
PARAM$input$dataset <- "competencia_02.csv.gz"
PARAM$input$training <- c(201901, 201902, 201903) # unos tres por ahora

# select multiple months
dataset <- fread(PARAM$input$dataset)
max(dataset[, foto_mes])


dataset3 <- dataset[foto_mes %in% PARAM$input$training, , ]
nrow(dataset3)
max(dataset3$foto_mes)
# save dataset
fwrite(dataset3, "competencia_02_3.csv.gz")



## Exploratory Data Analysis
#------------------------------------------------------------------------------




## Exploratory Data Analysis
#------------------------------------------------------------------------------

# Reminder data.tables
## DT[i, j, by]
##   R:                 i                 j        by
## SQL:  where | order by   select | update  group by

## data.table also allows wrapping columns with .() instead of list(). It is an alias to list(); they both mean the same. Feel free to use whichever you prefer; we have noticed most users seem to prefer .() for conciseness, so we will continue to use .() hereafter.

# column names
colnames(dataset)[1:4]

# first 10 rows fecha_mes
dataset[foto_mes == 201901, .(foto_mes)][1:10]

# head data.table
head(dataset)


# I want to create an indicator that accounts had been zeroed
#------------------------------------------------------------------------------

# Is mcuentas_saldo a true indicator of whether accounts had been zeroed?

# show all account data
dataset[,
  .(mcuenta_corriente_adicional, mcuenta_corriente,
    mcaja_ahorro, mcaja_ahorro_adicional, mcaja_ahorro_dolares,
    mcuentas_saldo
  )
][1:10]


# show side by side the sum of all accounts and mcuentas_saldo
dataset[,
  .( -(mcuenta_corriente_adicional + mcuenta_corriente +
    mcaja_ahorro + mcaja_ahorro_adicional + mcaja_ahorro_dolares)+
    mcuentas_saldo
  )
][1:10]

# there is something I do not know. Some got negative values, so it is not only a question of a missing column in the sum


## Negative values en mcuentas_saldo
dataset[,
  .(mcuentas_saldo)
][mcuentas_saldo <= 0]

## is negative the sum of all accounts?
sum_accounts <- dataset[,
  .( -(mcuenta_corriente_adicional + mcuenta_corriente +
    mcaja_ahorro + mcaja_ahorro_adicional + mcaja_ahorro_dolares)
  )
]



## ---------------------------
# new column in dataframe if mcuentas_saldo < 0
