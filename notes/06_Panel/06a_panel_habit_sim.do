* Simulated firm panel for the "habit" slides of 06a_panel_data.qmd:
* how much of D survives firm + industry x year fixed effects?
*
* 500 firms in 20 industries, 2011-2020. True effect of D on y is 0.5.
* A quarter of firms are treated every year, ~8% switch on mid-sample,
* the rest are never treated.

clear all
set seed 2026
set obs 500
gen firm = _n
gen ind  = ceil(firm / 25)
gen firm_fe = rnormal(0, 1)
gen always  = runiform() < 0.25                       // treated every year
gen switch  = !always & runiform() < 0.08             // switches on mid-sample
gen adopt   = 2013 + floor(6 * runiform()) if switch
expand 10
bysort firm: gen year = 2010 + _n
gen D = always | (switch & year >= adopt)
bysort ind year: gen iy = rnormal(0, 1) if _n == 1    // one shock per industry-year
by ind year: replace iy = iy[1]
gen x = 0.5 * firm_fe + rnormal()
gen y = 0.5 * D + 0.3 * x + firm_fe + iy + rnormal()
xtset firm year

* ---- the slide code ----
capture which sumhdfe
if _rc net install sumhdfe, from("https://raw.githubusercontent.com/ed-dehaan/sumhdfe/master/src/")
reghdfe y D x, absorb(firm ind#year) vce(cluster firm)
sumhdfe

reghdfe D, absorb(firm ind#year) residuals(D_tilde)
summarize D D_tilde

quietly summarize D
local sdD = r(sd)
quietly summarize D_tilde
display "share of variance in D surviving the FE: " %5.3f (r(sd)/`sdD')^2
egen tagf = tag(firm)
count if tagf & switch                                // number of switching firms
