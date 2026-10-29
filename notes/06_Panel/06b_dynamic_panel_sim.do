*==============================================================================
* BUSS975 -- Dynamic panels on simulated data
*   y_it = rho * y_{i,t-1} + u_i + e_it,   u_i ~ N(0,1),  e_it ~ N(0,1)
* Truth is known, so every estimator can be graded.
*   rho = 0.95             : the instruments of difference GMM go weak
*   rho = 0.95, on_target 0: firms start away from their own long-run level,
*                            and system GMM's extra instruments become invalid
*==============================================================================
clear all
set seed 20260202
local N         = 500   // firms
local T         = 8     // years per firm
local rho       = 0.6   // true persistence; then try 0.95
local on_target = 1     // 1: start each firm at its own long-run level (mean stationarity)
                        // 0: start every firm at the average level, then converge

*---------------------------------------------------------------- 1. simulate
set obs `N'
gen firm = _n
gen u    = rnormal()                                   // firm effect
gen y    = `on_target'*u/(1-`rho') + rnormal(0, 1/sqrt(1-`rho'^2))
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

*---------------------------------------------------------------- 5. Blundell-Bond
* system GMM: adds the levels equation, instrumented by lagged differences
xtdpdsys y, lags(1) maxldep(3) twostep vce(robust)
estimates store BB
estat abond

*---------------------------------------------------------------- 6. grade them
* rho = 0.6 : expect OLS ~ 0.92, FE ~ 0.34 (Nickell, T = 8), AH/AB/BB near 0.6
* rho = 0.95: AH and AB are noisy and unreliable (weak instruments); BB near 0.95
* on_target = 0 with rho = 0.95: AB recovers; BB is pushed up, outside the bracket
* One draw is noisy -- re-run with other seeds before reading much into it.
display as text "truth: rho = `rho', on_target = `on_target'"
estimates table OLS FE AH AB BB, keep(L.y LD.y) b(%7.3f) se(%7.3f) stats(N)
