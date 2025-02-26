library(dplyr)

# Define directory containing the CSV files
data_dir <- "path/to/your/csv/files"  # Change this to your actual directory

# Get a list of all resting state CSV files
file_list <- list.files(data_dir, pattern = "*_RestingState.csv", full.names = TRUE)

# Read all CSVs into a list
all_data <- lapply(file_list, read.csv, header = FALSE)

# Convert list of data frames into an array (3D: electrodes x time x participants)
data_array <- simplify2array(all_data)

# Compute the mean across the third dimension (participants)
averaged_data <- apply(data_array, c(1, 2), mean, na.rm = TRUE)

# Save the averaged data as a new CSV file
write.csv(averaged_data, file = file.path(data_dir, "Averaged_RestingState.csv"), row.names = FALSE)
