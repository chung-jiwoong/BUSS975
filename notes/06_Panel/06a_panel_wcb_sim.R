# Monte Carlo for the inference section of 06a_panel_data.qmd:
# rejection rates of a 5% test of a TRUE null, standard CRSE vs. wild cluster
# bootstrap, with G = 10 states and a varying number of treated states.
#
# DGP (same as the Stata code on the slides):
#   10 states x 100 workers x 5 years; worker effect ~ N(15, 4), drawn once per
#   worker; state-year shock ~ N(0, 1.2^2), drawn once per state-year; iid noise.
#   Policy switches on in years 3-5 for states 1..n_treated. True effect = 0.
# Estimator: worker + year FE, standard errors clustered by state (CR1, the
#   reghdfe small-sample factor), critical values from t(G - 1).
# WCB: restricted (null imposed), Webb six-point weights, B = 999 -- what
#   boottest, weight(webb) does. Vectorised: a balanced panel with worker and
#   year FE lets every bootstrap draw be computed from G x T cluster aggregates.

set.seed(12345)
G <- 10; Nw <- 100; T <- 5; N <- G * Nw * T
S_SIM <- 5000; B <- 999

worker <- rep(1:(G * Nw), each = T)
state  <- ceiling(worker / Nw)
year   <- rep(1:T, times = G * Nw)
dm2 <- function(x) x - ave(x, worker) - ave(x, year) + mean(x)   # two-way demean
webb <- c(-sqrt(1.5), -1, -sqrt(0.5), sqrt(0.5), 1, sqrt(1.5))
adj  <- G / (G - 1) * (N - 1) / (N - T)      # CR1; K = policy + 4 year dummies

one_panel <- function(n_treated) {
  y  <- rnorm(G * Nw, 15, 2)[worker] +
        matrix(rnorm(G * T, 0, 1.2), G, T)[cbind(state, year)] + rnorm(N)
  D  <- as.numeric(state <= n_treated & year >= 3)
  Dd <- dm2(D); yd <- dm2(y); SDD <- sum(Dd^2)

  # Standard CRSE
  del <- sum(Dd * yd) / SDD
  sc  <- tapply(Dd * (yd - Dd * del), state, sum)
  t0  <- del / (sqrt(adj * sum(sc^2)) / SDD)
  p_crse <- 2 * pt(-abs(t0), G - 1)

  # Wild cluster bootstrap under H0 (restricted residuals are yd itself)
  E  <- unclass(tapply(yd, list(state, year), sum))
  A  <- unclass(tapply(Dd, list(state, year), sum))
  Sg <- as.vector(tapply(Dd * yd, state, sum))
  Dg <- as.vector(tapply(Dd^2, state, sum))
  W  <- matrix(sample(webb, G * B, TRUE), G, B)
  dstar <- colSums(W * Sg) / SDD
  m     <- t(W) %*% E / (G * Nw)                 # year means of w * residual
  score <- W * Sg - A %*% t(m - rowMeans(m)) - outer(Dg, dstar)
  tstar <- dstar / (sqrt(adj * colSums(score^2)) / SDD)
  p_wcb <- mean(abs(tstar) >= abs(t0))

  c(crse = p_crse < 0.05, wcb = p_wcb < 0.05)
}

for (nt in c(2, 3, 5)) {
  r <- rowMeans(replicate(S_SIM, one_panel(nt)))
  cat(sprintf("%d of %d states treated: CRSE rejects %.1f%%, WCB rejects %.1f%%\n",
              nt, G, 100 * r["crse"], 100 * r["wcb"]))
}
