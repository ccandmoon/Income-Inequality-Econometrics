*******************************************************
* Income Inequality Econometric Analysis (Initial)
* Author: Cecilia Li
* Dataset: IPUMS CPS Survey Data
* Purpose:
* Analyze relationships between wage income and
* demographic/work variables using descriptive
* statistics, correlations, and probability analysis.
*******************************************************

*******************************************************
* Setup & Data Cleaning
*******************************************************
cd "D:\PhotonUser\My Files\Google Drive\My Drive\github"
capture log close
log using initial_analysis.log, replace
use "cps.dta", clear
drop wkswork1

replace incwage = . if incwage == 0 | incwage == 99999999
replace age = . if age < 14
replace uhrsworkly = . if uhrsworkly == 999
gen white = (race == 100)
replace white = 0 if race != 100

*******************************************************
* Descriptive Analysis 
*******************************************************
sum age
sum sex
sum white
sum uhrsworkly
sum incwage

*******************************************************
* Income Distribution Analysis
*******************************************************
summarize incwage, detail
histogram incwage if incwage > 0 & incwage < 1000000 , percent normal bin(70)
graph export "hist_dependent.jpg", replace

*mean of the dummy explanatory variables
bysort sex: summarize incwage
bysort white: summarize incwage

*correlations with numerical variables
corr incwage age
corr incwage uhrsworkly

*generate a new dummy variable
summarize incwage if incwage > 0 & incwage < ., detail
gen high_income = (incwage > r(p50)) if incwage > 0 & incwage < .

*conditional and marginal probabilities table
tab high_income white, col

log close