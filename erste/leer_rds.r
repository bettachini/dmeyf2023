

copla <- readRDS(file= './301_iter.rds')

copla <- readRDS(file= './resultados_grid_search.rds')
setorder(copla, cols = -"gan")
head(copla)
