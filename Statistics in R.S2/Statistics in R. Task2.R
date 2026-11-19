
# ============================================================
# PRACTICAL TASK
# Detecting and Handling Outliers in Task-Based fMRI Data
#
# Dataset: Task_fMRI_Stroop_Dataset.xlsx
# Sheet: Task_Wide
# Target: Mean_RT_Incongruent
# ============================================================


# ============================================================
# 1. INSTALL AND LOAD PACKAGES
# ============================================================

packages <- c("readxl", "dplyr", "ggplot2", "writexl")

new_packages <- packages[
  !packages %in% installed.packages()[, "Package"]
]

if (length(new_packages) > 0) {
  install.packages(new_packages)
}

library(readxl)
library(dplyr)
library(ggplot2)
library(writexl)


# ============================================================
# 2. SELECT AND IMPORT EXCEL DATASET
# ============================================================

cat("\n========================================\n")
cat("SELECT YOUR EXCEL DATASET\n")
cat("========================================\n")

file_path <- file.choose()

# Import the requested sheet
task_wide <- read_excel(
  path = file_path,
  sheet = "Task_Wide"
)

# Preserve original dataset
task_wide_original <- task_wide

# Create output folder next to original Excel file
output_dir <- file.path(
  dirname(file_path),
  "Outlier_Analysis_Results"
)

dir.create(
  output_dir,
  showWarnings = FALSE,
  recursive = TRUE
)

cat("\nDataset imported successfully!\n")
cat("Participants:", nrow(task_wide), "\n")
cat("Variables:", ncol(task_wide), "\n")


# ============================================================
# 3. CHECK DATASET STRUCTURE AND VARIABLES
# ============================================================

cat("\n--- DATASET STRUCTURE ---\n")

str(task_wide)

required_vars <- c(
  "Subject_ID",
  "Group",
  "Sex",
  "Age",
  "Mean_RT_Incongruent",
  "Mean_ACC_Beta_Incongruent"
)

missing_vars <- setdiff(
  required_vars,
  names(task_wide)
)

if (length(missing_vars) > 0) {
  stop(
    paste(
      "Required variables are missing:",
      paste(missing_vars, collapse = ", ")
    )
  )
}

# Save dataset information
dataset_info <- data.frame(
  Number_of_Participants = nrow(task_wide),
  Number_of_Variables = ncol(task_wide)
)


# ============================================================
# 4. VARIABLE CLASSIFICATION
# ============================================================

variable_classification <- data.frame(
  Variable = c(
    "Group",
    "Sex",
    "Age",
    "Mean_RT_Incongruent",
    "Mean_ACC_Beta_Incongruent"
  ),
  
  Broad_Type = c(
    "Categorical",
    "Categorical",
    "Numerical",
    "Numerical",
    "Numerical"
  ),
  
  Measurement_Level = c(
    "Nominal",
    "Nominal",
    "Ratio",
    "Ratio",
    "Ratio"
  )
)

write.csv(
  variable_classification,
  file.path(output_dir, "01_Variable_Classification.csv"),
  row.names = FALSE
)


# ============================================================
# 5. DATA QUALITY CHECK AND PREPARATION
# ============================================================

# Convert target variable to numeric
rt_raw <- suppressWarnings(
  as.numeric(as.character(
    task_wide$Mean_RT_Incongruent
  ))
)

missing_count <- sum(is.na(rt_raw))

nonfinite_count <- sum(
  !is.na(rt_raw) & !is.finite(rt_raw)
)

valid_rt <- !is.na(rt_raw) & is.finite(rt_raw)

# Preserve original data and create analysis dataset
analysis_data <- task_wide[
  valid_rt,
  ,
  drop = FALSE
]

analysis_data$Mean_RT_Incongruent <- rt_raw[valid_rt]

cat("\n--- DATA QUALITY ---\n")
cat("Original observations:", nrow(task_wide), "\n")
cat("Valid observations:", nrow(analysis_data), "\n")
cat("Missing values:", missing_count, "\n")
cat("Non-finite values:", nonfinite_count, "\n")
cat("Excluded from target analysis:", sum(!valid_rt), "\n")


# ============================================================
# 6. DESCRIPTIVE STATISTICS AND VISUALIZATION
# ============================================================

rt <- analysis_data$Mean_RT_Incongruent

original_stats <- data.frame(
  Dataset = "Original",
  N = length(rt),
  Mean = mean(rt),
  SD = sd(rt),
  Median = median(rt)
)

# Histogram
histogram <- ggplot(
  analysis_data,
  aes(x = Mean_RT_Incongruent)
) +
  geom_histogram(
    bins = 30,
    fill = "steelblue",
    color = "black"
  ) +
  labs(
    title = "Histogram of Mean Reaction Time",
    subtitle = "Incongruent Stroop Condition",
    x = "Mean Reaction Time",
    y = "Frequency"
  ) +
  theme_minimal()

# Boxplot
boxplot <- ggplot(
  analysis_data,
  aes(y = Mean_RT_Incongruent)
) +
  geom_boxplot(
    fill = "orange",
    color = "black"
  ) +
  labs(
    title = "Boxplot of Mean Reaction Time",
    y = "Mean Reaction Time"
  ) +
  theme_minimal()

ggsave(
  file.path(output_dir, "02_Histogram.png"),
  histogram,
  width = 8,
  height = 5,
  dpi = 300
)

ggsave(
  file.path(output_dir, "03_Boxplot.png"),
  boxplot,
  width = 6,
  height = 5,
  dpi = 300
)


# ============================================================
# 7. IQR OUTLIER DETECTION
# ============================================================

Q1 <- quantile(rt, 0.25, names = FALSE)
Q3 <- quantile(rt, 0.75, names = FALSE)

IQR_value <- IQR(rt)

lower_fence <- Q1 - 1.5 * IQR_value
upper_fence <- Q3 + 1.5 * IQR_value

cat("\n--- IQR METHOD ---\n")
cat("Q1:", Q1, "\n")
cat("Q3:", Q3, "\n")
cat("IQR:", IQR_value, "\n")
cat("Lower fence:", lower_fence, "\n")
cat("Upper fence:", upper_fence, "\n")

analysis_data$IQR_Outlier <- (
  rt < lower_fence | rt > upper_fence
)

iqr_outliers <- analysis_data %>%
  filter(IQR_Outlier) %>%
  select(
    Subject_ID,
    Group,
    Mean_RT_Incongruent
  )

write.csv(
  iqr_outliers,
  file.path(output_dir, "04_IQR_Outliers.csv"),
  row.names = FALSE
)


# ============================================================
# 8. Z-SCORE OUTLIER DETECTION
# ============================================================

rt_mean <- mean(rt)
rt_sd <- sd(rt)

if (rt_sd == 0 || !is.finite(rt_sd)) {
  stop("Z-scores cannot be calculated because SD is zero or invalid.")
}

analysis_data$Z_Score <- (
  rt - rt_mean
) / rt_sd

analysis_data$Z_Outlier <- (
  abs(analysis_data$Z_Score) > 3
)

z_outliers <- analysis_data %>%
  filter(Z_Outlier) %>%
  select(
    Subject_ID,
    Group,
    Mean_RT_Incongruent,
    Z_Score
  )

write.csv(
  z_outliers,
  file.path(output_dir, "05_Z_Score_Outliers.csv"),
  row.names = FALSE
)


# ============================================================
# 9. COMPARE IQR AND Z-SCORE METHODS
# ============================================================

iqr_ids <- analysis_data$Subject_ID[
  analysis_data$IQR_Outlier
]

z_ids <- analysis_data$Subject_ID[
  analysis_data$Z_Outlier
]

both_ids <- intersect(iqr_ids, z_ids)

iqr_only_ids <- setdiff(iqr_ids, z_ids)

z_only_ids <- setdiff(z_ids, iqr_ids)

comparison <- data.frame(
  Method = c("IQR", "Z-score"),
  Number_of_Outliers = c(
    sum(analysis_data$IQR_Outlier),
    sum(analysis_data$Z_Outlier)
  )
)

cat("\n--- OUTLIER COMPARISON ---\n")

print(comparison)

cat("\nDetected by both methods:\n")
print(both_ids)

cat("\nDetected only by IQR:\n")
print(iqr_only_ids)

cat("\nDetected only by Z-score:\n")
print(z_only_ids)

# Detailed participant comparison
outlier_comparison <- data.frame(
  Subject_ID = analysis_data$Subject_ID,
  Group = analysis_data$Group,
  Mean_RT_Incongruent = rt,
  Z_Score = analysis_data$Z_Score,
  IQR_Outlier = analysis_data$IQR_Outlier,
  Z_Outlier = analysis_data$Z_Outlier
)


# ============================================================
# 10. CREATE FILTERED DATASETS
# ============================================================

# Original dataset remains unchanged

task_wide_iqr_filtered <- analysis_data %>%
  filter(!IQR_Outlier) %>%
  select(all_of(names(task_wide)))

task_wide_z_filtered <- analysis_data %>%
  filter(!Z_Outlier) %>%
  select(all_of(names(task_wide)))


# ============================================================
# 11. COMPARE DESCRIPTIVE STATISTICS
# ============================================================

calculate_stats <- function(data, dataset_name) {
  
  x <- data$Mean_RT_Incongruent
  
  x <- x[
    !is.na(x) & is.finite(x)
  ]
  
  data.frame(
    Dataset = dataset_name,
    N = length(x),
    Mean = mean(x),
    SD = sd(x),
    Median = median(x)
  )
}

descriptive_comparison <- bind_rows(
  
  calculate_stats(
    analysis_data,
    "Original"
  ),
  
  calculate_stats(
    task_wide_iqr_filtered,
    "IQR Filtered"
  ),
  
  calculate_stats(
    task_wide_z_filtered,
    "Z-score Filtered"
  )
)

cat("\n--- DESCRIPTIVE STATISTICS ---\n")

print(descriptive_comparison)

write.csv(
  descriptive_comparison,
  file.path(output_dir, "06_Descriptive_Statistics.csv"),
  row.names = FALSE
)


# ============================================================
# 12. SAVE ALL RESULTS IN ONE EXCEL FILE
# ============================================================

write_xlsx(
  
  list(
    
    Original_Data = task_wide_original,
    
    Valid_Analysis_Data = analysis_data,
    
    Variable_Classification = variable_classification,
    
    Dataset_Information = dataset_info,
    
    IQR_Outliers = iqr_outliers,
    
    Z_Score_Outliers = z_outliers,
    
    Outlier_Comparison = outlier_comparison,
    
    Detection_Summary = comparison,
    
    IQR_Filtered_Data = task_wide_iqr_filtered,
    
    Z_Filtered_Data = task_wide_z_filtered,
    
    Descriptive_Statistics = descriptive_comparison
    
  ),
  
  file.path(
    output_dir,
    "07_Complete_Analysis.xlsx"
  )
)


# ============================================================
# 13. GENERATE ANALYSIS SUMMARY
# ============================================================

summary_text <- c(
  
  "PRACTICAL TASK: fMRI STROOP OUTLIER ANALYSIS",
  
  "============================================",
  
  "",
  
  paste("Original sample size:", nrow(task_wide)),
  
  paste("Valid observations:", nrow(analysis_data)),
  
  paste("Missing RT values:", missing_count),
  
  paste("Non-finite RT values:", nonfinite_count),
  
  "",
  
  "IQR METHOD",
  
  paste("Q1:", Q1),
  
  paste("Q3:", Q3),
  
  paste("IQR:", IQR_value),
  
  paste("Lower fence:", lower_fence),
  
  paste("Upper fence:", upper_fence),
  
  paste("Number of IQR outliers:", length(iqr_ids)),
  
  "",
  
  "Z-SCORE METHOD",
  
  paste("Number of Z-score outliers:", length(z_ids)),
  
  "",
  
  "METHOD COMPARISON",
  
  paste("Detected by both:", length(both_ids)),
  
  paste("IQR only:", length(iqr_only_ids)),
  
  paste("Z-score only:", length(z_only_ids)),
  
  "",
  
  "DESCRIPTIVE STATISTICS",
  
  capture.output(print(descriptive_comparison))
  
)

writeLines(
  summary_text,
  file.path(output_dir, "08_Analysis_Summary.txt")
)


# ============================================================
# 14. FINAL RESULTS
# ============================================================

cat("\n")
cat("============================================\n")
cat("ANALYSIS COMPLETED SUCCESSFULLY\n")
cat("============================================\n")

cat("\nOriginal participants:", nrow(task_wide), "\n")

cat("Valid RT observations:", nrow(analysis_data), "\n")

cat("IQR outliers:", length(iqr_ids), "\n")

cat("Z-score outliers:", length(z_ids), "\n")

cat("Detected by both:", length(both_ids), "\n")

cat("IQR only:", length(iqr_only_ids), "\n")

cat("Z-score only:", length(z_only_ids), "\n")

cat("\nDescriptive statistics:\n")

print(descriptive_comparison)

cat("\nAll results saved in:\n")

cat(output_dir, "\n")

cat("\n============================================\n")
