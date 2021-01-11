xdot = @(r,x) r*x - x/(1+x.^2);

r = 0;
[f, xdot_rf] = phasePortrait(xdot, -1, 1, r);

%root = fzero(xdot_rf, 10)

xFP = sqrt(1/r - 1)