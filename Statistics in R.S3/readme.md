# Session 3 – Practical Statistical Tasks in R

## Overview

This session focuses on practical applications of statistical analysis using R. The exercises cover three fundamental statistical methods used to investigate group differences, categorical associations, and changes in measurements over time.

Each task involves identifying the research question, defining the variables, selecting an appropriate statistical test, checking relevant assumptions, performing the analysis, and interpreting the results.

---

## Task 1 – Independent Samples Comparison

### Objective

Investigate whether the mean brain volume differs significantly between two independent cohorts: Patient and Reference.

### Research Question

Is there a statistically significant difference in brain volume between the Patient and Reference cohorts?

### Variables

- **Independent Variable (IV):** Cohort
  - Patient
  - Reference
- **Dependent Variable (DV):** Brain_Volume (continuous)

### Hypotheses

- **Null Hypothesis (H₀):** The mean brain volume is equal between the Patient and Reference cohorts.
- **Alternative Hypothesis (H₁):** The mean brain volume differs between the Patient and Reference cohorts.

### Statistical Method

- Independent Samples t-test
- Welch's t-test (does not assume equal variances)
- Shapiro–Wilk normality test
- Descriptive statistics

### Analysis Workflow

1. Load and inspect the dataset.
2. Verify the required variables.
3. Convert the cohort variable into a categorical factor.
4. Calculate descriptive statistics (sample size, mean, and standard deviation) for each cohort.
5. Assess normality within each group using the Shapiro–Wilk test.
6. Perform Welch's independent samples t-test.
7. Extract the test statistic, degrees of freedom, p-value, and 95% confidence interval.
8. Interpret the results and determine whether the difference between cohorts is statistically significant.

### Expected Outputs

- Descriptive statistics for both cohorts.
- Normality test results.
- Welch's t-test results.
- 95% confidence interval for the mean difference.
- Statistical conclusion regarding differences in brain volume between the cohorts.

---

## Task 2 – Categorical Association

### Objective

Examine whether the type of care received is associated with the observed outcome.

### Research Question

Is there a statistically significant association between Care_Arm and Outcome_Flag?

### Variables

- **Independent Variable:** Care_Arm
  - Advanced
  - Conventional
- **Outcome Variable:** Outcome_Flag
  - 0 = No event
  - 1 = Event

Both variables are categorical.

### Hypotheses

- **Null Hypothesis (H₀):** Care_Arm and Outcome_Flag are independent, with no statistically significant association.
- **Alternative Hypothesis (H₁):** Care_Arm and Outcome_Flag are associated.

### Statistical Method

- Contingency table analysis
- Pearson's Chi-square test of independence
- Fisher's Exact Test when expected cell frequencies are insufficient
- Row percentages for comparing outcome distributions between groups

### Analysis Workflow

1. Load and inspect the dataset.
2. Verify the required variables.
3. Remove observations with missing values in the relevant variables.
4. Convert Care_Arm and Outcome_Flag into categorical factors.
5. Construct a contingency table showing observed frequencies.
6. Calculate row percentages to compare outcome distributions across care groups.
7. Perform the Chi-square test of independence.
8. Examine expected cell frequencies to assess the appropriateness of the Chi-square test.
9. Select Fisher's Exact Test if expected frequencies are insufficient; otherwise, use Pearson's Chi-square test.
10. Extract the test statistic, degrees of freedom, and p-value.
11. Interpret the statistical findings and determine whether a significant association exists.

### Expected Outputs

- Observed contingency table.
- Row percentages for each care group.
- Expected cell frequencies.
- Chi-square or Fisher's Exact Test results.
- Statistical conclusion regarding the association between care type and outcome.

---

## Task 3 – Repeated Measures ANOVA

### Objective

Evaluate changes in systolic blood pressure (SBP) over time among participants enrolled in the Active program.

### Research Question

Does systolic blood pressure change significantly over time in participants enrolled in the Active program?

### Variables

- **Dependent Variable (DV):** SBP (continuous)
- **Within-Subject Independent Variable:** Time
  - Baseline
  - Month 1
  - Month 3
- **Participant Identifier:** Participant_Code

The same participants are measured at all three time points, making the observations dependent.

### Hypotheses

- **Null Hypothesis (H₀):** Mean SBP is equal across Baseline, Month 1, and Month 3.
- **Alternative Hypothesis (H₁):** At least one time point has a significantly different mean SBP.

### Statistical Method

- Repeated Measures ANOVA
- Greenhouse–Geisser correction
- Paired-samples t-tests for post-hoc comparisons
- Bonferroni adjustment for multiple comparisons
- Descriptive statistics

### Analysis Workflow

1. Load and inspect the dataset.
2. Select participants enrolled in the Active program.
3. Identify and remove participants with missing SBP measurements at any time point.
4. Create a participant identifier for repeated measurements.
5. Convert the dataset from Wide Format to Long Format.
6. Define Time as a categorical within-subject factor with three ordered levels.
7. Calculate descriptive statistics (sample size, mean, and standard deviation) for each time point.
8. Perform Repeated Measures ANOVA to evaluate the overall effect of Time on SBP.
9. Apply Greenhouse–Geisser correction when extracting the ANOVA results.
10. Conduct paired-samples t-tests for all pairwise comparisons between time points.
11. Apply Bonferroni correction to control for multiple comparisons.
12. Interpret the overall ANOVA result and post-hoc comparisons to determine when SBP changes occur.

### Expected Outputs

- Number of participants included in the analysis.
- Descriptive statistics for Baseline, Month 1, and Month 3.
- Repeated Measures ANOVA results.
- F-statistic, corrected degrees of freedom, p-value, and partial eta-squared.
- Pairwise comparisons with Bonferroni-adjusted p-values.
- Statistical conclusion regarding changes in SBP over time.

---

## Statistical Methods Summary

| Task | Research Objective | Statistical Method |
|---|---|---|
| Task 1 | Compare a continuous variable between two independent groups | Welch's Independent Samples t-test |
| Task 2 | Examine the association between two categorical variables | Pearson's Chi-square test / Fisher's Exact Test |
| Task 3 | Compare a continuous variable across multiple measurements from the same participants | Repeated Measures ANOVA with post-hoc paired comparisons |

---

## Key Learning Outcomes

By completing these practical tasks, the learner will be able to:

- Identify independent and dependent variables.
- Distinguish continuous and categorical variables.
- Formulate statistical null and alternative hypotheses.
- Select an appropriate statistical test based on the research question and study design.
- Perform descriptive and inferential statistical analyses in R.
- Assess relevant statistical assumptions.
- Interpret p-values, confidence intervals, test statistics, and effect sizes.
- Understand the differences between independent groups and repeated measurements.
- Perform post-hoc comparisons and correct for multiple testing.
- Report statistical findings in a scientific format.

---

## Repository Contents

The repository contains the R scripts, datasets, analysis outputs, and documentation associated with the practical statistical tasks.

Each task is organized around its research objective, statistical methodology, analysis workflow, and interpretation of results.

---

**Session:** 3 – Practical Statistical Tasks  
**Software:** R / RStudio  
**Topics:** Independent Samples t-test, Chi-square Test, Repeated Measures ANOVA
