import pandas as pd

ds_train = pd.read_csv("~/buckets/b1/datasets/competencia_02_eng.csv.gz")
# ds_train = pd.read_csv("./datasets/competencia_02_eng.csv.gz")
clase_train = ds_train["clase_ternaria"].map(lambda x: 0 if x == "CONTINUA" else 1)

ds_bajas = ds_train.query("clase_ternaria == 'BAJA+2'")
# ds_bajas = ds_train.query("clase_ternaria != 'CONTINUA'")
ds_train = ds_train.drop(["clase_ternaria", "numero_de_cliente"], axis=1)
# ds_train = ds_train.drop("clase_ternaria", axis=1)
ds_bajas = ds_bajas.drop(["clase_ternaria", "numero_de_cliente"], axis=1)
# ds_bajas = ds_bajas.drop("clase_ternaria", axis=1)

ds_bajas.to_pickle("~/buckets/b1/datasets/competencia_02_eng_bajas.pkl")
ds_train.to_pickle("~/buckets/b1/datasets/competencia_02_eng_train.pkl")