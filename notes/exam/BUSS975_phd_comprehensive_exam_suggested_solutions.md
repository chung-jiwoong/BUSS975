---
title: "BUSS975 Sample PhD Comprehensive Exam: Suggested Solutions"
format:
  pdf:
    papersize: letter
    geometry:
      - margin=1in
    fontsize: 11pt
    number-sections: false
    toc: false
    colorlinks: false
---

## Question 1. Regression Foundations, CEF, and Inference (12 points)

1. The conditional expectation function is
   $m(x) = E[Y|X=x]$.
   It gives the mean of $Y$ for each value of $X$ and is the best mean-squared-error predictor of $Y$ given $X$.
2. Let
   $u = Y - E[Y|X]$.
   Then
   $Y = E[Y|X] + u$.
   Also,
   $E[u|X] = E[Y - E[Y|X] | X] = E[Y|X] - E[Y|X] = 0$.
   This is the standard CEF decomposition.
3. A linear regression slope is not automatically causal because regression captures association unless we impose an exogeneity condition such as
   $E[u|X] = 0$.
   For causal interpretation, the regressors must not be correlated with omitted determinants of the outcome. Endogeneity from omitted variables, simultaneity, or measurement error breaks that link.
4. If zero conditional mean holds but the error is heteroskedastic:
   - OLS coefficients remain unbiased in finite samples under the usual conditions and remain consistent under standard asymptotics.
   - The conventional homoskedastic standard errors are generally wrong.
   - Inference should use heteroskedasticity-robust standard errors, or another variance estimator justified by the sampling setting.

## Question 2. Endogeneity, Omitted Variables, and Measurement Error (14 points)

1. If ability is omitted, the regression error becomes
   $e_i = \beta_2 ability_i + u_i$.
   Therefore,

   $$
   plim \ \hat{\beta}_1^{omit}
   = \beta_1 + \beta_2 \frac{Cov(educ_i, ability_i)}{Var(educ_i)}.
   $$

   This is the omitted variable bias formula in the simple case.
2. The return to education is upward biased if:
   - $\beta_2 > 0$, so ability raises wages, and
   - $Cov(educ_i, ability_i) > 0$, so more able people obtain more education.
   If both are negative, the product is also positive and the bias is still upward.
3. With classical measurement error in the regressor, the probability limit of the simple-regression slope becomes

   $$
   plim \ \hat{\beta}_1
   = \beta_1 \frac{Var(educ_i)}{Var(educ_i) + Var(v_i)}.
   $$

   This is attenuation bias toward zero.
4. With classical random measurement error in the dependent variable, the coefficient remains unbiased and consistent if the error is independent of the regressors. The main effect is larger residual variance, which reduces precision and inflates standard errors. Systematic measurement error in the dependent variable can generate bias if it is correlated with regressors.

## Question 3. Treatment Effects and Difference-in-Differences (14 points)

1. Using potential outcomes:
   - ATE: $ATE = E[Y_i(1) - Y_i(0)]$
   - ATT: $ATT = E[Y_i(1) - Y_i(0) | D_i = 1]$
2. The cross-sectional difference can be decomposed as

   $$
   E[Y_i|D_i=1] - E[Y_i|D_i=0]
   = ATT + \left(E[Y_i(0)|D_i=1] - E[Y_i(0)|D_i=0]\right).
   $$

   The second term is selection bias. Unless treated and untreated units would have had the same untreated outcomes on average, the simple difference does not identify the ATT.
3. In a two-group, two-period DID design:

   $$
   DID =
   \left(E[Y_{1,post}] - E[Y_{1,pre}]\right)
   -
   \left(E[Y_{0,post}] - E[Y_{0,pre}]\right).
   $$

   Under parallel trends,
   the untreated outcome trend for treated and control units would have been the same absent treatment. With no anticipation, stable composition, and a well-defined treatment, DID identifies the ATT for the treated group in the post period.
4. A reasonable panel regression for `EZUNEM` is

   $$
   luclms_{ct} = \alpha_c + \lambda_t + \delta ez_{ct} + u_{ct},
   $$

   where $\alpha_c$ are city fixed effects and $\lambda_t$ are year fixed effects.
   If treatment timing varies, $\delta$ is the average within-city change associated with enterprise zone status, conditional on common year shocks.
5. Credibility checks include:
   - testing for pre-treatment trends or plotting an event study,
   - placebo treatments or placebo outcomes,
   - checking whether treated and control groups evolve similarly before treatment,
   - assessing composition changes or other policies that coincide with treatment.

## Question 4. Panel Data and Fixed Effects (14 points)

1. Pooled OLS omits $a_i$. If $Cov(X_{it}, a_i) \neq 0$, then the error term contains a component correlated with the regressor, violating exogeneity and causing omitted variable bias.
2. Taking unit means:

   $$
   \bar{Y}_i = \beta \bar{X}_i + a_i + \bar{u}_i.
   $$

   Subtract this from the original equation:

   $$
   Y_{it} - \bar{Y}_i = \beta (X_{it} - \bar{X}_i) + (u_{it} - \bar{u}_i).
   $$

   The time-invariant term $a_i$ drops out. OLS on the demeaned equation gives the fixed effects estimator.
3. Fixed effects and first differences are numerically identical when there are exactly two time periods. With more than two periods:
   - fixed effects uses deviations from unit means,
   - first differences uses adjacent-period changes.
   First differences may be attractive if the error is highly persistent in levels, while fixed effects is often more efficient when idiosyncratic errors are weakly serially correlated.
4. The key identifying assumption is strict exogeneity conditional on the unit effect:

   $$
   E[u_{it} | X_{i1}, X_{i2}, ..., X_{iT}, a_i] = 0.
   $$

   Informally, after controlling for $a_i$, changes in $X_{it}$ must be uncorrelated with time-varying omitted shocks.
5. Standard errors are typically clustered at the unit level because outcomes and errors within a unit are often serially correlated over time. Ignoring that correlation tends to overstate precision.

## Question 5. Instrumental Variables and 2SLS (16 points)

1. The core IV assumptions are:
   - Relevance: $Cov(e401k_i, p401k_i) \neq 0$
   - Exogeneity or independence: the instrument is uncorrelated with the structural error, conditional on controls
   - Exclusion: eligibility affects net financial assets only through participation, not through another direct channel
   - For a LATE interpretation under heterogeneity: monotonicity, meaning no defiers
2. In the binary just-identified case, the Wald estimand is

   $$
   \frac{E[nettfa_i | e401k_i = 1] - E[nettfa_i | e401k_i = 0]}
        {E[p401k_i | e401k_i = 1] - E[p401k_i | e401k_i = 0]}.
   $$

   This is the ratio of the reduced-form effect of eligibility on assets to the first-stage effect of eligibility on participation.
3. A valid 2SLS setup is:

   First stage:

   $$
   p401k_i =
   \pi_0 + \pi_1 e401k_i + \pi_2 inc_i + \pi_3 age_i + \pi_4 marr_i
   + \pi_5 fsize_i + \pi_6 male_i + v_i.
   $$

   Second stage:

   $$
   nettfa_i =
   \beta_0 + \beta_1 \hat{p401k}_i + \beta_2 inc_i + \beta_3 age_i + \beta_4 marr_i
   + \beta_5 fsize_i + \beta_6 male_i + u_i.
   $$

4. Under heterogeneous treatment effects, IV identifies the local average treatment effect (LATE): the average effect for compliers, meaning those whose participation changes because of eligibility.
5. Weak instruments means the first stage is weak, so the instrument has little explanatory power for the endogenous regressor. Consequences include:
   - large finite-sample bias, often toward OLS,
   - imprecise estimates,
   - unreliable conventional inference,
   - non-normal sampling behavior in finite samples.
   A common diagnostic is the first-stage F-statistic, along with weak-IV-robust inference methods when needed.
6. With more instruments than endogenous regressors, an overidentification test becomes available, such as the Hansen J or Sargan test. It assesses whether the instruments as a group appear uncorrelated with the structural error, assuming at least one instrument is valid. It is not a direct test of exclusion for any one instrument individually.

## Question 6. Regression Discontinuity Design (10 points)

1. RDD exploits a known treatment rule based on whether a running variable crosses a cutoff. Units just above and just below the cutoff are compared, with the idea that they are locally similar except for treatment status.
2. In sharp RDD, treatment changes from 0 to 1 deterministically at the cutoff. The estimand is the jump in the conditional expectation of the outcome at the threshold.
   In fuzzy RDD, treatment probability changes discontinuously at the cutoff but not from 0 to 1. The estimand is the ratio of the outcome jump to the treatment-probability jump, which is a local IV estimand at the cutoff.
3. The key assumption is continuity of the potential outcome functions at the cutoff. Absent treatment, expected outcomes just above and below the threshold would have evolved smoothly through the cutoff.
4. Important practical choices and checks include:
   - bandwidth selection and robustness to alternative bandwidths,
   - local linear estimation rather than global high-order polynomials,
   - graphical inspection of outcome means near the cutoff,
   - density tests for manipulation of the running variable,
   - continuity tests for predetermined covariates at the cutoff.

## Question 7. Matching and Selection on Observables (10 points)

1. Matching relies on:
   - unconfoundedness or selection on observables:
     $(Y_i(1), Y_i(0)) \perp D_i | X_i$
   - overlap or common support:
     $0 < P(D_i=1|X_i) < 1$
2. Rosenbaum and Rubin show that if treatment is independent of potential outcomes conditional on $X_i$, then it is also independent conditional on the propensity score
   $p(X_i) = P(D_i=1|X_i)$.
   So matching on the scalar propensity score can balance the covariate distribution between treated and control units.
3. A sensible workflow is:
   - choose pre-treatment covariates,
   - estimate the propensity score,
   - trim observations with poor overlap if necessary,
   - perform matching or weighting,
   - check covariate balance after matching,
   - estimate the ATT or ATE with appropriate standard errors,
   - conduct sensitivity analysis where possible.
4. Important limitations:
   - matching does not solve bias from unobserved confounders,
   - poor overlap can make estimates noisy and sample-dependent,
   - estimates can be sensitive to the propensity score model and matching algorithm,
   - matching may worsen finite-sample performance if implemented mechanically.

## Question 8. Research Design Critique (10 points)

1. Plausible threats include:
   - omitted variable bias from unobserved firm quality, governance, or industry shocks,
   - reverse causality if high-value firms choose better ESG disclosure,
   - bad controls if leverage, analyst coverage, or institutional ownership are partly outcomes of ESG disclosure,
   - survivorship bias from dropping delisted firms,
   - measurement error in ESG scores,
   - cross-sectional selection differences across industries or firm life cycle,
   - simultaneous policy or reputation shocks correlated with ESG disclosure.
2. Why they matter:
   - omitted variables and reverse causality mean the ESG coefficient may absorb other determinants of firm value,
   - bad controls can block part of the treatment effect or induce collider bias,
   - survivorship bias distorts the sample toward successful firms,
   - measurement error can attenuate estimates or create nonclassical bias,
   - cross-sectional designs lack a clean counterfactual and do not remove time-invariant firm heterogeneity.
3. Stronger designs could include:
   - panel data with firm and year fixed effects, if identification comes from within-firm changes and timing is credible,
   - a DID design around an exogenous disclosure mandate,
   - an IV strategy using plausibly exogenous variation in disclosure costs or regulation,
   - matching combined with DID if a policy creates quasi-experimental variation.
   Full-credit answers should explain why the proposed design improves identification rather than simply naming a method.

## Notes for Grading

- Full-credit answers should separate identification assumptions from statistical inference.
- Strong answers should name both the formal assumption and the economic intuition.
- Extra credit quality often comes from discussing threats to validity, interpretation of estimands, and limits to external validity.
