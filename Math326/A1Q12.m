xdot = @(r,x) x.*(r-exp(x));

r = 2;
[f, xdot_rf] = phasePortrait(xdot, -1, 1, r);

root = fzero(xdot_rf, 1)