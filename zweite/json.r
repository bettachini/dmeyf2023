# Load your data into a data frame (replace 'your_data' with your data)
your_data <- read.csv("../normanbuck/datasets/competencia_02_3.csv.gz")

# Rename features with special characters
colnames(your_data) <- make.names(colnames(your_data))

# Ensure feature names are valid JSON strings
colnames(your_data) <- paste0('"', colnames(your_data), '"')
