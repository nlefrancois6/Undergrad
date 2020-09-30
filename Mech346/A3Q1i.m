A = [1e-4 2.5*1e-5 1e-4];
p = [0.04 0.02 0.04];
h = [10 100 1000];
k = [10 10 10];
L = [0.05 0.05 0.01];

beta = @(h, p, k, A) sqrt(h.*p./(k.*A));
infLongCond = @(beta, L) beta.*L;
adiabaticCond = @(beta, h, k) h./(beta.*k);

betaVals = beta(h, p, k, A)

infLong = infLongCond(betaVals, L)

adiabatic = adiabaticCond(betaVals, h, k)
