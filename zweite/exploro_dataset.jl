using CSV, DataFrames

3+3

df = CSV.read("../normanbuck/datasets/competencia_02.csv.gz", DataFrame)
# tardó bastante en generar el DataFrame a partir de los 650 MB del archivo comprimido

# lowest and highest foto_mes in df
foto_mes_min = minimum(df.foto_mes)
foto_mes_max = maximum(df.foto_mes)

# Es precioso este intérprete de Julia. Que muestre la salida al costado de la ejecución me recuerda a Smalltalk.


# show first rows of df
first(df, 3)

# count cliente_vip ocurrences
sum(df.cliente_vip)
# so only that number out of
length(df.cliente_vip)
sum(df.cliente_vip) / length(df.cliente_vip)

# list columns
names(df)

# list columns starting with `cliente_`
filter(x -> occursin(r"^cliente_", x), names(df))

println("foto_mes_min: ", foto_mes_min)