N = length(x);
M = N-1;
[coeff, xfit, yfit] = polyFit(x,y,M);
plot(x,y, 'bo')
hold on;
plot(xfit, yfit, 'r')
hold off;


