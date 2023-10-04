# Install and load the necessary packages
library(haven)
library(readr)

# Set the path to the directory where the data resides
path <- "/mnt/data/ADAM"

# Get the list of all .sas7bdat files in the directory
files <- list.files(path, pattern = "\\.sas7bdat$", full.names = TRUE)

# Read each file and store them in a list
data_list <- lapply(files, read_sas)

# Save the data_list to an R data file in the same directory
save(data_list, file = file.path(path, "combined_data.RData"))

cat("Data saved to", file.path(path, "combined_data.RData"), "\n")

# Load the .RData file
load(file.path(path, "combined_data.RData"))

# Specify the output directory
output_dir <- "/mnt/artifacts/results"

# Check if the output directory exists; if not, create it
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Export each dataset from data_list as a CSV file
for(i in seq_along(data_list)) {
  write_csv(data_list[[i]], file = file.path(output_dir, paste0("data_", i, ".csv")))
}

cat("Data exported to", output_dir)
