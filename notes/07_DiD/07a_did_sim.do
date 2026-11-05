*==============================================================================
* BUSS975 -- Difference-in-differences fundamentals
*   Part 1: four ways to one number (Cheng and Hoekstra 2013, castle.dta)
*   Part 2: the no-anticipation assumption, simulated (Remix ch. 9, na.do)
*==============================================================================
clear all
capture log close

*---------------------------------------------------------------- 1. castle doctrine
* 50 states, 2000-2010. Keep the states that adopted in 2006 and those that never adopted.
use data/castle.dta, clear
drop if inlist(effyear, 2005, 2007, 2008, 2009)
gen treat = effyear == 2006
drop post
gen post  = year >= 2006

* 1a. four averages and three subtractions
egen y11 = mean(l_homicide) if treat == 1 & post == 1
egen y10 = mean(l_homicide) if treat == 1 & post == 0
egen y01 = mean(l_homicide) if treat == 0 & post == 1
egen y00 = mean(l_homicide) if treat == 0 & post == 0
foreach v in y11 y10 y01 y00 {
    egen e`v' = max(`v')
}
display as text "2x2: " (ey11 - ey10) - (ey01 - ey00)      // 0.0682359

* 1b. interaction OLS
reg l_homicide treat##post, cluster(sid)                  // 0.0682359

* 1c. two-way fixed effects
xtset sid year
xtreg l_homicide c.treat#c.post i.year, fe cluster(sid)   // 0.0682359

* 1d. long difference: each state's post-period mean minus its pre-period mean
preserve
    collapse (mean) l_homicide, by(sid treat post)
    reshape wide l_homicide, i(sid treat) j(post)
    gen dbar = l_homicide1 - l_homicide0
    reg dbar treat, cluster(sid)                          // 0.0682359
restore

* 1e. event study against the 2005 baseline
gen rel = year - 2006 if treat == 1
forvalues y = 2000/2010 {
    gen d`y' = treat * (year == `y')
}
drop d2005
xtreg l_homicide d2000-d2010 i.year, fe cluster(sid)

*---------------------------------------------------------------- 2. no anticipation
* 1,000 firms in 40 states, 1990-1993. Treatment group (upper half) treated from 1991.
clear
set seed 20200403
set obs 40
gen state = _n
expand 25
bysort state: gen firms = runiform(0, 5)                // firm fixed effect
expand 4
sort state
bysort state firms: gen year = _n
gen n = year
replace year = 1989 + year
egen id = group(state firms)

gen group = id >= 500                                   // treatment group
gen post    = year >= 1991                              // correct baseline: 1990 untreated
gen post_na = year >= 1992                              // wrong baseline:   1991 already treated

gen e  = rnormal(0, 1)
gen y0 = firms + n + e                                  // untreated potential outcome

gen     y1_c = y0                                       // constant effect: 10, 10, 10
replace y1_c = y0 + 10 if year >= 1991
gen     y1_d = y0                                       // dynamic effect: 10, 20, 30
replace y1_d = y0 + 10 if year == 1991
replace y1_d = y0 + 20 if year == 1992
replace y1_d = y0 + 30 if year == 1993

gen d   = group * (year >= 1991)
gen y_c = d * y1_c + (1 - d) * y0                       // switching equation
gen y_d = d * y1_d + (1 - d) * y0

* grade them: clean baseline recovers the ATT (10 and 20);
* a treated baseline gives ATT(post) - ATT(pre): 0 under constant effects, 25 - 10 = 15 under dynamic
regress y_c group##post, robust                         // 10
regress y_d group##post, robust                         // 20
regress y_c group##post_na if year >= 1991, robust      // 0
regress y_d group##post_na if year >= 1991, robust      // 15
