---
title: "BUSS975 Sample PhD Comprehensive Exam"
format:
  pdf
---

## Question 1. Regression Foundations, CEF, and Inference (12 points)

1. Define the conditional expectation function (CEF) of $Y$ given $X$.
2. Show that any random variable can be decomposed as
   $Y = E[Y|X] + u$
   with $E[u|X] = 0$.
3. Explain why the existence of a linear regression of $Y$ on $X$ does not by itself justify a causal interpretation of the slope coefficient.
4. Suppose the zero conditional mean assumption holds but the variance of the error depends on $X$. What happens to:
   - unbiasedness or consistency of OLS,
   - the usual homoskedastic standard errors,
   - the preferred approach to statistical inference?

## Question 2. Endogeneity, Omitted Variables, and Measurement Error (14 points)

Suppose the true wage equation is

$$
\log(wage_i) = \beta_0 + \beta_1 educ_i + \beta_2 ability_i + u_i,
$$

where $E[u_i|educ_i, ability_i] = 0$.

1. If a researcher omits $ability_i$ and regresses $\log(wage_i)$ only on $educ_i$, derive the probability limit of the OLS estimator on $educ_i$.
2. Under what sign conditions will the estimated return to education be upward biased?
3. Now suppose $educ_i$ is observed with classical measurement error:
   $educ_i^{obs} = educ_i + v_i$, where $E[v_i] = 0$ and $v_i$ is independent of $educ_i$, $ability_i$, and $u_i$.
   What happens to the estimated coefficient on education in a simple regression?
4. Contrast that result with the case where the dependent variable $\log(wage_i)$ is measured with classical random error instead.

## Question 3. Treatment Effects and Difference-in-Differences (14 points)

1. Define the average treatment effect (ATE) and the average treatment effect on the treated (ATT) using potential outcomes notation.
2. Explain why the simple cross-sectional difference
   $E[Y_i|D_i=1] - E[Y_i|D_i=0]$
   does not generally identify the ATT.
3. Consider a two-period difference-in-differences setup with treated and untreated units. Derive the DID estimand and state the key identifying assumptions required for a causal interpretation.
4. Using the `EZUNEM` panel as motivation, write a regression specification that could estimate the effect of enterprise zone designation on log unemployment claims.
5. Give two empirical diagnostics or design checks that would strengthen the credibility of a DID design.

## Question 4. Panel Data and Fixed Effects (14 points)

Consider the panel model

$$
Y_{it} = \beta X_{it} + a_i + u_{it},
$$

where $a_i$ is an unobserved time-invariant unit effect.

1. Explain why pooled OLS can be biased when $a_i$ is omitted and correlated with $X_{it}$.
2. Derive the fixed effects ("within") transformation and show how it removes $a_i$.
3. Compare fixed effects and first differences. Under what condition are they identical, and when might one be preferred to the other?
4. State the key identifying assumption for a causal interpretation of the fixed effects estimator.
5. What kind of standard error adjustment is typically appropriate in panel settings, and why?

## Question 5. Instrumental Variables and 2SLS (16 points)

Suppose a researcher wants to estimate the causal effect of 401(k) participation (`p401k`) on net financial assets (`nettfa`) using 401(k) eligibility (`e401k`) as an instrument.

1. State the core assumptions required for `e401k` to be a valid instrument for `p401k`.
2. In the just-identified binary instrument / binary treatment case, write the Wald estimand and interpret it.
3. Write the first-stage and second-stage equations for a 2SLS specification that also controls for income, age, marital status, family size, and gender.
4. Explain what the 2SLS coefficient identifies under heterogeneous treatment effects.
5. What is the weak instruments problem? Describe its consequences for estimation and inference.
6. If the researcher had more instruments than endogenous regressors, what additional test becomes available, and what does it assess?

## Question 6. Regression Discontinuity Design (10 points)

1. Explain the basic idea of a regression discontinuity design (RDD).
2. Distinguish between sharp and fuzzy RDD, both conceptually and in terms of the causal parameter identified.
3. State the continuity-based identifying assumption underlying RDD.
4. Give three practical validity checks or implementation choices that are important in applied RDD work.

## Question 7. Matching and Selection on Observables (10 points)

1. State the key identifying assumptions behind matching estimators.
2. Explain why matching on the propensity score can be sufficient, rather than matching on the full vector of covariates directly.
3. Outline a reasonable workflow for implementing matching in practice.
4. Give two important limitations of matching for causal inference.

## Question 8. Research Design Critique (10 points)

A researcher studies whether ESG disclosure increases firm value. She runs a cross-sectional OLS regression of Tobin's $q$ on an ESG disclosure score using one year of listed firms. Her controls include current leverage, analyst coverage, and institutional ownership. She drops firms that delisted during the year and concludes that the positive, statistically significant ESG coefficient is causal.

1. Identify at least five threats to causal interpretation in this design.
2. For each threat, briefly explain why it matters.
3. Propose a stronger research design using one of the methods emphasized in this course.

