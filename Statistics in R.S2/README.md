
# Assignment: Outlier Detection and Evaluation in the fMRI Dataset

## Objective

The objective of this assignment is to detect, analyze, and evaluate outliers in the fMRI Stroop dataset using statistical methods in R.

## Tasks

### Task 1: Variable Classification

Classify the following variables:

- `Group`
- `Sex`
- `Age`
- `Mean_RT_Incongruent`
- `Mean_ACC_Beta_Incongruent`

Identify whether each variable is categorical or numerical and determine its measurement level:

- Nominal
- Ordinal
- Interval
- Ratio

### Task 2: Data Visualization

Create a histogram and a boxplot for `Mean_RT_Incongruent`.

Describe the following:

- Distribution shape
- Central tendency
- Data spread
- Potential extreme observations

### Task 3: Outlier Detection Using the IQR Method

Calculate:

- First Quartile (Q1)
- Third Quartile (Q3)
- Interquartile Range (IQR)
- Lower Fence
- Upper Fence

Identify observations outside the IQR fences.

### Task 4: IQR Outlier Identification

Create a table containing:

- `Subject_ID`
- `Group`
- `Mean_RT_Incongruent`

Include all participants identified as outliers by the IQR method.

### Task 5: Outlier Detection Using the Z-Score Method

Calculate Z-scores for `Mean_RT_Incongruent`.

Identify observations with an absolute Z-score greater than 3:

```r
abs(Z_Score) > 3
```

### Task 6: Comparison of Outlier Detection Methods

Compare the IQR and Z-score methods.

Identify:

- Number of outliers detected by each method
- Outliers detected by both methods
- Outliers detected only by the IQR method
- Outliers detected only by the Z-score method

### Task 7: Data Filtering

Create two separate filtered datasets:

- Dataset 1: Exclude outliers identified by the IQR method.
- Dataset 2: Exclude outliers identified by the Z-score method.

Preserve the original dataset.

### Task 8: Comparison of Descriptive Statistics

Compare the following statistical measures before and after outlier removal:

- Mean
- Standard Deviation (SD)
- Median

Perform the comparison for:

- Original Dataset
- IQR-Filtered Dataset
- Z-Score-Filtered Dataset

### Task 9: Scientific Interpretation of Outliers

Explain why an outlier does not necessarily represent an error.

Discuss possible explanations:

- Individual differences
- Slow reaction times
- Task difficulty
- Attention and concentration
- Recording or data-processing issues

### Task 10: Final Evaluation and Conclusion

Interpret the results of the analysis.

Discuss how removing outliers may affect descriptive statistics and the interpretation of cognitive performance.

## Expected Deliverables

- [ ] Variable classification table
- [ ] Histogram and boxplot
- [ ] IQR calculations and outlier table
- [ ] Z-score calculations and outlier table
- [ ] Comparison of both detection methods
- [ ] Two filtered datasets
- [ ] Comparison of descriptive statistics
- [ ] Scientific interpretation
- [ ] Final conclusion

## Important Note

Outlier detection and outlier removal are two separate decisions.

The original dataset must be preserved, and any exclusion of observations should be scientifically justified.
