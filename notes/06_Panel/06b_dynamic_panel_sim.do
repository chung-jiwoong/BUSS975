*==============================================================================
* BUSS975 -- Dynamic panels on simulated data
*   y_it = rho * y_{i,t-1} + u_i + e_it,   u_i ~ N(0,1),  e_it ~ N(0,1)
* Truth is known, so every estimator can be graded. Change rho to 0.95 and
* re-run to watch the instruments weaken.
*==============================================================================
clear all
set seed 20260202
local N    = 500        // firms
local T    = 8          // years kept per firm
local burn = 30         // burn-in, so every firm starts at its own long-run level
local rho  = 0.6        // true persistence

*---------------------------------------------------------------- 1. simulate
set obs `N'
gen firm = _n
gen u    = rnormal()                                   // firm effect
gen y    = u/(1-`rho') + rnormal(0, 1/sqrt(1-`rho'^2)) // stationary start
forvalues s = 1/`burn' {
    replace y = `rho'*y + u + rnormal()                // burn in
}
expand `T'
bysort firm: gen year = _n
xtset firm year
bysort firm (year): replace y = `rho'*y[_n-1] + u + rnormal() if _n > 1

*---------------------------------------------------------------- 2. the bracket
reg   y L.y, vce(cluster firm)                          // biased UP
estimates store OLS
xtreg y L.y, fe vce(cluster firm)                       // biased DOWN (Nickell)
estimates store FE

*---------------------------------------------------------------- 3. Anderson-Hsiao
* difference the model; instrument the lagged difference with the second lag in levels
ivregress 2sls D.y (LD.y = L2.y), vce(cluster firm)
estimates store AH

*---------------------------------------------------------------- 4. Arellano-Bond
* difference GMM: lags 2..4 of y as instruments, two-step, Windmeijer-corrected SEs
xtabond y, lags(1) maxldep(3) twostep vce(robust)
estimates store AB
estat abond                                             // AR(1): expected. AR(2): must be absent
estat sargan                                            // run after one-step, non-robust, if you want it

*---------------------------------------------------------------- 5. Blundell-Bond
* system GMM: adds the levels equation, instrumented by lagged differences
xtdpdsys y, lags(1) maxldep(3) twostep vce(robust)
estimates store BB
estat abond

*---------------------------------------------------------------- 6. grade them
* truth: rho = `rho'.  Expect OLS ~ 0.92, FE ~ 0.34, the three IV/GMM estimates ~ 0.6
estimates table OLS FE AH AB BB, keep(L.y LD.y) b(%7.3f) se(%7.3f) stats(N)

* Now set rho = 0.95 at the top and run again: AH scatters, AB drifts toward FE.
