
############################################################
# SESSION 3 - PRACTICAL STATISTICAL TASKS
# Task 1: Independent Samples
# Task 2: Categorical Association
# Task 3: Repeated Measures ANOVA
############################################################


############################################################
# PART 1 - CHECK AND INSTALL REQUIRED PACKAGES
############################################################

packages <- c(
  "readxl",
  "dplyr",
  "tidyr",
  "ggplot2",
  "rstatix",
  "afex",
  "emmeans"
)

# Check installed packages
installed <- rownames(installed.packages())

# Install missing packages
for (pkg in packages) {
  if (!pkg %in% installed) {
    install.packages(pkg, dependencies = TRUE)
  }
}

# Load packages
invisible(lapply(packages, library, character.only = TRUE))

cat("\nAll required packages are ready.\n")


############################################################
# PART 2 - IMPORT EXCEL DATASETS
############################################################

cat("\nSelect Excel file for TASK 1\n")
data1 <- read_excel(file.choose())

cat("\nSelect Excel file for TASK 2\n")
data2 <- read_excel(file.choose())

cat("\nSelect Excel file for TASK 3\n")
data3 <- read_excel(file.choose())


# Inspect datasets
cat("\nTASK 1 DATA:\n")
print(head(data1))
print(names(data1))

cat("\nTASK 2 DATA:\n")
print(head(data2))
print(names(data2))

cat("\nTASK 3 DATA:\n")
print(head(data3))
print(names(data3))


############################################################
# TASK 1 - INDEPENDENT GROUPS
# Comparing Brain Volume Between Cohorts
############################################################

cat("\n\n========== TASK 1 ==========\n")

# Check variables
stopifnot(all(c("Cohort", "Brain_Volume") %in% names(data1)))

# Convert cohort to factor
data1$Cohort <- as.factor(data1$Cohort)

# Descriptive statistics
task1_descriptive <- data1 %>%
  group_by(Cohort) %>%
  summarise(
    N = sum(!is.na(Brain_Volume)),
    Mean = mean(Brain_Volume, na.rm = TRUE),
    SD = sd(Brain_Volume, na.rm = TRUE),
    .groups = "drop"
  )

cat("\nDescriptive Statistics:\n")
print(task1_descriptive)

# Check normality in each group
task1_normality <- data1 %>%
  filter(!is.na(Cohort), !is.na(Brain_Volume)) %>%
  group_by(Cohort) %>%
  filter(n() >= 3, n() <= 5000) %>%
  shapiro_test(Brain_Volume)

cat("\nNormality Test:\n")
print(task1_normality)

# Welch Independent Samples t-test
task1_result <- t.test(
  Brain_Volume ~ Cohort,
  data = data1,
  var.equal = FALSE,
  conf.level = 0.95
)

cat("\nWelch Independent Samples t-test:\n")
print(task1_result)

# Extract results
cat("\nTask 1 Results:\n")
cat("t-statistic:", unname(task1_result$statistic), "\n")
cat("Degrees of freedom:", unname(task1_result$parameter), "\n")
cat("p-value:", task1_result$p.value, "\n")
cat("95% Confidence Interval:\n")
print(task1_result$conf.int)

if (task1_result$p.value < 0.05) {
  cat("Conclusion: Significant difference between cohorts.\n")
} else {
  cat("Conclusion: No statistically significant difference between cohorts.\n")
}


############################################################
# TASK 2 - CATEGORICAL ASSOCIATION
# Care Arm and Outcome Flag
############################################################

cat("\n\n========== TASK 2 ==========\n")

# Check variables
stopifnot(all(c("Care_Arm", "Outcome_Flag") %in% names(data2)))

# Remove missing observations
task2_data <- data2 %>%
  filter(!is.na(Care_Arm), !is.na(Outcome_Flag))

# Convert variables to factors
task2_data$Care_Arm <- as.factor(task2_data$Care_Arm)
task2_data$Outcome_Flag <- as.factor(task2_data$Outcome_Flag)

# Create contingency table
contingency_table <- table(
  task2_data$Care_Arm,
  task2_data$Outcome_Flag
)

cat("\nContingency Table:\n")
print(contingency_table)

# Calculate row percentages
cat("\nRow Percentages:\n")
print(round(prop.table(contingency_table, margin = 1) * 100, 2))

# Chi-square test
chi_result <- chisq.test(contingency_table, correct = FALSE)

cat("\nExpected Frequencies:\n")
print(chi_result$expected)

# Select appropriate test
if (any(chi_result$expected < 5)) {
  
  task2_result <- fisher.test(contingency_table)
  
  cat("\nFisher's Exact Test was selected.\n")
  
} else {
  
  task2_result <- chi_result
  
  cat("\nChi-square Test was selected.\n")
}

cat("\nTask 2 Statistical Results:\n")
print(task2_result)

# Extract p-value
cat("\np-value:", task2_result$p.value, "\n")

# Report Chi-square statistic and df only if Chi-square was selected
if (inherits(task2_result, "htest") &&
    !is.null(task2_result$statistic) &&
    !is.null(task2_result$parameter)) {
  
  cat("Chi-square statistic:", unname(task2_result$statistic), "\n")
  cat("Degrees of freedom:", unname(task2_result$parameter), "\n")
}

if (task2_result$p.value < 0.05) {
  cat("Conclusion: Significant association between Care Arm and Outcome Flag.\n")
} else {
  cat("Conclusion: No statistically significant association between Care Arm and Outcome Flag.\n")
}



############################################################
# TASK 3 - REPEATED MEASURES ANOVA
# Evaluating Changes in Systolic Blood Pressure Over Time
############################################################

# Step 1: Check dataset
names(data3)
str(data3)

# Step 2: Select Active participants
active_data <- data3 %>%
  filter(Program == "Active")

cat("Number of Active Participants:",
    nrow(active_data), "\n")

# Step 3: Remove participants with missing measurements
active_data <- active_data %>%
  filter(
    !is.na(SBP_Initial),
    !is.na(SBP_Month1),
    !is.na(SBP_Month3)
  )

cat("Complete Participants:",
    nrow(active_data), "\n")

# Step 4: Create Participant ID
active_data$ID <- factor(active_data$Participant_Code)

# Step 5: Convert Wide Data to Long Format
sbp_long <- active_data %>%
  select(ID, SBP_Initial, SBP_Month1, SBP_Month3) %>%
  pivot_longer(
    cols = c(SBP_Initial, SBP_Month1, SBP_Month3),
    names_to = "Time",
    values_to = "SBP"
  )

# Step 6: Set measurement order
sbp_long$Time <- factor(
  sbp_long$Time,
  levels = c(
    "SBP_Initial",
    "SBP_Month1",
    "SBP_Month3"
  ),
  labels = c(
    "Baseline",
    "Month 1",
    "Month 3"
  )
)

# Step 7: Descriptive Statistics
task3_descriptive <- sbp_long %>%
  group_by(Time) %>%
  summarise(
    N = n(),
    Mean = mean(SBP),
    SD = sd(SBP),
    .groups = "drop"
  )

cat("\nDescriptive Statistics:\n")
print(task3_descriptive)

# Step 8: Repeated Measures ANOVA
task3_result <- anova_test(
  data = sbp_long,
  dv = SBP,
  wid = ID,
  within = Time,
  effect.size = "pes"
)

# Step 9: Display ANOVA results
task3_anova_table <- get_anova_table(
  task3_result,
  correction = "GG"
)

cat("\nRepeated Measures ANOVA Results:\n")
print(task3_anova_table)

# Step 10: Pairwise Comparisons
pairwise_result <- sbp_long %>%
  pairwise_t_test(
    SBP ~ Time,
    paired = TRUE,
    p.adjust.method = "bonferroni"
  )

cat("\nPairwise Comparisons:\n")
print(pairwise_result)

# Step 11: Final Interpretation
task3_p <- task3_anova_table$p[1]

cat("\nFinal Conclusion:\n")

if (task3_p < 0.05) {
  cat("There is a statistically significant change in SBP over time.\n")
} else {
  cat("There is no statistically significant change in SBP over time.\n")
}


############################################################
# END OF SESSION 3
############################################################
