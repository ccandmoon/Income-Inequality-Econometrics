*******************************************************
* Income Inequality Econometric Analysis
* Author: Cecilia (Xinran) Li
* Dataset: IPUMS CPS Survey Data
*
* Objective:
* Examine how demographic and labor-related
* characteristics influence wage income using
* descriptive statistics, hypothesis testing,
* and multivariate regression analysis.
*******************************************************

clear all
capture log close
log using complete_regression.log, replace

*******************************************************
* 1. Load and Clean Data
*******************************************************

use "cps.dta", clear

* Remove unnecessary variable
drop wkswork1

* Handle invalid or missing values
replace incwage = . if incwage == 0 | incwage == 99999999
replace age = . if age < 14
replace uhrsworkly = . if uhrsworkly == 999

* Create race indicator variable
gen white = (race == 100)

* Label variables for readability
label variable incwage "Annual Wage Income"
label variable age "Age"
label variable sex "Sex"
label variable uhrsworkly "Usual Weekly Hours Worked"
label variable white "White Race Indicator"

*******************************************************
* 2. Descriptive Statistics
*******************************************************

* Summary statistics of key variables
summarize incwage age sex uhrsworkly white

* Detailed distribution of wage income
summarize incwage, detail

*******************************************************
* 3. Distribution Analysis
*******************************************************

* Visualize wage income distribution
histogram incwage if incwage > 0 & incwage < 1000000, ///
percent normal bin(70) ///
title("Distribution of Wage Income")

graph export "income_distribution_histogram.jpg", replace

*******************************************************
* 4. Exploratory Relationship Analysis
*******************************************************

* Relationship between age and wage income
scatter incwage age, ///
title("Wage Income vs Age")

graph export "income_age_scatter.jpg", replace

* Relationship between work hours and wage income
scatter incwage uhrsworkly, ///
title("Wage Income vs Weekly Hours Worked")

graph export "income_hours_scatter.jpg", replace

*******************************************************
* 5. Correlation Analysis
*******************************************************

* Examine linear relationships
corr incwage age
corr incwage uhrsworkly

*******************************************************
* 6. Group Comparison Analysis
*******************************************************

* Compare mean wages by sex
table sex, statistic(mean incwage)

* Hypothesis test:
* Are average wages significantly different by sex?
ttest incwage, by(sex)

*******************************************************
* 7. Regression Analysis
*******************************************************

* Multivariate regression model
* Controls for age, weekly hours, race, and sex
reg incwage age uhrsworkly white sex, robust

*******************************************************
* End of Analysis
*******************************************************

log close