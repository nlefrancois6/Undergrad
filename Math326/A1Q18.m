xdot = @(r,x) x.*(1-x)-r;

r = 5;
[f, xdot_rf] = phasePortrait(xdot, -5, 5, r);

root = fzero(xdot_rf, 0.5)
max(f)