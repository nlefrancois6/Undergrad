xdot = @(r,x) r - cosh(x);

x = linspace(-1,1,1000);
r = 1.1;
f = xdot(r,x);

xdot_rf = @(x) r - cosh(x);



roots = zeros(2,1);
roots(1,1) = fzero(xdot_rf, 0.1);
roots(2,1) = fzero(xdot_rf, -0.1);

hold on;
plot(x, f)
title('Phase Portrait')
xlabel('x')
ylabel('xdot')
hold off