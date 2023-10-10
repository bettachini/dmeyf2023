require("data.table")

# Aqui se debe poner la carpeta de la computadora local
# setwd("../normanbuck/") # Establezco el Working Directory
setwd("~/buckets/b1/") # Establezco el Working Directory

PARAM <- list()
PARAM$input$dataset <- "./datasets/competencia_02_engineered_vm.csv.gz"

# cargo el dataset donde voy a entrenar el modelo
dataset <- fread(PARAM$input$dataset)

# Assuming you have already read your CSV data into a data.table called 'dataset'


# Change column names based on your criteria
setnames(dataset, old = grep("_d1$", names(dataset), value = TRUE), new = sub("_d1$", "_l1", grep("_d1$", names(dataset), value = TRUE)))
setnames(dataset, old = grep("_d1:1$", names(dataset), value = TRUE), new = sub("_d1:1$", "_d1", grep("_d1:1$", names(dataset), value = TRUE)))

names(dataset)

# save dataset
fwrite(dataset, file="./datasets/competencia_02_eng.csv.gz", compress="gzip")