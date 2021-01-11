xdot = @(r,x) r*x - x/(1+x);

r = -0.1;
[f, xdot_rf] = phasePortrait(xdot, -1, 1, r);

root = fzero(xdot_rf, 10)

xFP = 1/r - 1;


