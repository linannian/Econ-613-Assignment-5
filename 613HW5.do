******************************************
* Options and miscellaneity *
******************************************
clear all
set more off, perm
set scrollbufsize 2000000

* Keep logs.
capture log close
log using "613HW5.txt", replace

cd "/Users/linannian/Downloads"
pwd

******************************************
* HW 2 *
******************************************

* Q1
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
corr Y X1
reg Y X1 X2 X3
reg Y X1 X2 X3, vce(bootstrap,reps(49))
reg Y X1 X2 X3, vce(bootstrap,reps(499))

* Q4
reg y_dum X1 X2 X3
probit y_dum X1 X2 X3
logit y_dum X1 X2 X3

* Q5
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

******************************************
* HW 3 *
******************************************
clear

* Q1
import delimited /Users/linannian/Downloads/product.csv
su
tab choice
save product.dta, replace

insheet using "/Users/linannian/Downloads/demos.csv",clear
su
joinby hhid using product.dta

* Q2
gen num = _n
gen n = 4470
rename (ppk_stk pbb_stk pfl_stk phse_stk pgen_stk pimp_stk pss_tub ppk_tub pfl_tub phse_tub)(p1 p2 p3 p4 p5 p6 p7 p8 p9 p10)
reshape long p, i(num) j(Product)
gen chosen = cond(Product==choice,1,0)
asclogit chosen p, case(num) alternative(Product)
est sto clogit

* marginal effect part of Q4
estat mfx

* Q3
asclogit chosen, case(num) alternatives(Product) casevar(income)
est sto mlogit

* marginal effect part of Q4
estat mfx

* Q4 is in the Q2&3

* Q5
asmixlogit chosen, random(p) case(num) alternatives(Product) casevar(income)
est sto mixlogit

drop if choice == 10
drop if Product == 10
asmixlogit chosen, random(p) case(num) alternatives(Product) casevar(income)
est sto mixlogit2
lrtest (mixlogit) (mixlogit2), force stats

******************************************
* HW 4 *
******************************************
clear

* Q1
import delimited /Users/linannian/Downloads/Koop-Tobias.csv
su
tabulate educ
tabulate potexper

xtset personid timetrnd
bysort personid: gen t = _n
xtdes

* Q2
global xvars "educ potexper"
global yvars "logwage"
xtreg $yvars $xvars, re
est store panel_random

* Q3
* between estimator
xtreg $yvars $xvars, be
est store panel_between

* within estimator
xtreg $yvars $xvars, fe
est store panel_within

* first differencing
gen d_id = personid - personid[_n-1]
gen d_wage = logwage - logwage[_n-1]
gen d_edu = educ - educ[_n-1]
gen d_exp = potexper - potexper[_n-1]
drop if d_id == 1
drop if d_id == .
reg d_wage d_edu d_exp
est store panel_first_diff
