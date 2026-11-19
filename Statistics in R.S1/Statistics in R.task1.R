
# ==========================================
# Task 01 - Descriptive Statistics
# ==========================================

# Step 1: Check and prepare the dataset
library(readxl)
file_path <- file.choose()
homework_fmri_visualization_dataset <- read_excel(file_path)
data_clean <- homework_fmri_visualization_dataset
View(data_clean)
dim(data_clean)
names(data_clean)
str(data_clean)
# Step 2: Identify quantitative variables

numeric_vars <- names(data_clean)[
  vapply(data_clean, is.numeric, logical(1))
]

print(numeric_vars)


# Step 3: Select one quantitative variable

variable_name <- numeric_vars[1]

# Extract the selected variable
x_raw <- data_clean[[variable_name]]

# Remove missing values
x <- x_raw[!is.na(x_raw)]


# Step 4: Calculate descriptive statistics

descriptive_stats <- data.frame(
  Variable = variable_name,
  N = length(x),
  Missing = sum(is.na(x_raw)),
  Mean = mean(x),
  Median = median(x),
  Standard_Deviation = sd(x),
  IQR = IQR(x),
  Minimum = min(x),
  Maximum = max(x)
)

print(descriptive_stats)


# Step 5: Create a histogram

hist(
  x,
  main = paste("Histogram of", variable_name),
  xlab = variable_name,
  ylab = "Frequency",
  col = "lightblue",
  border = "white"
)


# Step 6: Display basic numerical interpretation

cat("\nDescriptive Statistics Interpretation\n")

cat("Variable:", variable_name, "\n")
cat("Mean:", mean(x), "\n")
cat("Median:", median(x), "\n")
cat("Standard Deviation:", sd(x), "\n")
cat("Interquartile Range:", IQR(x), "\n")
