function [f, xdot_rf] = phasePortrait(xdot, a, b, r)
%Plot the phase portrait of xdot=f(x)
%a,b are the start and end points
%r is the bifurcation parameter

x = linspace(a,b,1e3);
f = xdot(r,x);
xdot_rf = @(x) xdot(r,x);

hold on;
plot(x, f)
title('Phase Portrait')
xlabel('x')
ylabel('xdot')
hold off
end

