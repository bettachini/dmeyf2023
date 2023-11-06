## Clase ternaria
## par Juan Raman
using Pkg
Pkg.add("GZip")

using CSV,  DataFrames, GZip

periodo_anterior(x::Integer) =  x % 100 > 1  ?  x-1  : 12 + (div(x,100) -1) * 100

df = CSV.read("../normanbuck/datasets/competencia_03_crudo.csv.gz", DataFrame)
sort!(df, [:numero_de_cliente, :foto_mes])

global periodo_ultimo = maximum( df.foto_mes )
global periodo_anteultimo = periodo_anterior( periodo_ultimo)

# assign most common class values
df.clase_ternaria = @. ifelse( df.foto_mes < periodo_anteultimo, "CONTINUA", missing )

# pre compute sequential time
periodo = @. div(df.foto_mes,100)*12 + df.foto_mes%100

global last = nrow(df)

for i in 1:last
  if df.foto_mes[i] <= periodo_anteultimo &&  i < last && df.numero_de_cliente[i] != df.numero_de_cliente[i+1]
          df.clase_ternaria[i] = "BAJA+1"
  end

  if df.foto_mes[i] < periodo_anteultimo &&  i+1 < last && df.numero_de_cliente[i] == df.numero_de_cliente[i+1] &&  periodo[i+1] == periodo[i] +1 &&
        ( df.numero_de_cliente[i+1] != df.numero_de_cliente[i+2]  || df.numero_de_cliente[i+1] == df.numero_de_cliente[i+2] && periodo[i+2]  > periodo[i+1] +2)
          df.clase_ternaria[i] = "BAJA+2"
  end
end


## Coloca CONTINUA para aquellos clientes que dejan de estar en el paquete premium y vuelven despues varios meses
## par Federico Idoeta

for i in 1:last
  if coalesce(df.clase_ternaria[i], "")=="BAJA+2" &&  (i+1 < last) && (coalesce( df.clase_ternaria[i+1], "")=="CONTINUA") && (df.numero_de_cliente[i] == df.numero_de_cliente[i+1])
        df.clase_ternaria[i] = "CONTINUA"
  end
  if (coalesce(df.clase_ternaria[i], "")=="BAJA+1") &&  (i+1 < last) && (coalesce( df.clase_ternaria[i+1], "")=="CONTINUA") && (df.numero_de_cliente[i] == df.numero_de_cliente[i+1])
      df.clase_ternaria[i] = "CONTINUA"
  end
end


# guarda csv comprimido con GZip
archivo_salida = "../normanbuck/datasets/competencia_03_julia.csv.gz"
CSV.write(GZip.open(archivo_salida, "w"), df)
# CSV.write( "competencia_03_julia.csv.gz", df )
