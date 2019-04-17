******************************************
* Options and miscellaneity *
******************************************
clear all
set more off, perm
set scrollbufsize 2000000

* Keep logs.
capture log close
log using "613HW5.txt", replace

******************************************
* HW 2 *
******************************************

*Q1
set seed 613
set obs 1000
gen X1 = runiform(1,3)
gen X2 = rgamma(3,2)
gen X3 = rbinomial(1,0.3)
gen eps = rnormal(2,1)
gen Y = 0.5+1.2*X1-0.9*X2+0.1*X3+eps

egen y_mean = mean(Y)
gen y_dum = (Y>y_mean)

* Q2
Q2
corr Y X1
reg Y X1 X2 X3
reg Y X1 X2 X3, vce(bootstrap,reps(49))
reg Y X1 X2 X3, vce(bootstrap,reps(499))

* Q4
reg y_dum X1 X2 X3
probit y_dum X1 X2 X3
logit y_dum X1 X2 X3

*Q5
probit y_dum X1 X2 X3
margins, dydx(*)
margins, dydx(*) atmeans

probit y_dum X1 X2 X3, vce(bootstrap,reps(49))
margins, dydx(*)
margins, dydx(*) atmeans

logit y_dum X1 X2 X3
margins, dydx(*)
margins, dydx(*) atmeans

logit y_dum X1 X2 X3, vce(bootstrap,reps(49))
margins, dydx(*)
margins, dydx(*) atmeans

