"get BO_log.txt into a data.frame
sort by 
save to file
"

library("data.table")
getwd()
bo_log_dt <- fread("./exp/HT3440/BO_log.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)
class(bo_log_dt)
setorder(bo_log_dt, -ganancia)

# write to file
fwrite(bo_log_dt, "./exp/HT3440/BO_log_sorted.dat", sep = "\t", row.names = FALSE)
