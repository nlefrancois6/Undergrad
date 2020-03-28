function [coeff, xfit, yfit] = polyFit(x,y,M)
%Find the polynomial fit coefficients for data pairs (x,y) with 
%an M-deg polynomial
%Output the xfit and yfit values for plotting, as well as the coefficients
%needed for evaluating the fit at a specified x value.

%Find fit coefficients
j = 1:M;
S = x.^(j-1);
c = S\y;
coeff = flip(c);

%Evaluate fit at N*10 points for plotting
N = length(x);
nFitPts = 10*N;
xfit = linspace(min(x), max(x), nFitPts);
yfit = polyval(coeff, xfit);
end

