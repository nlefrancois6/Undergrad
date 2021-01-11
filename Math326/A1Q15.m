%xdot1 = @(r,x) x;
%xdot2 = @(r,x) tanh(r*x);
xdot = @(r,x) x + tanh(r*x);

x = linspace(-1,1,1000);
r = -1.1;
%f1 = xdot1(r,x);
%f2 = xdot2(r,x);
f = xdot(r,x);

hold on;
%plot(x, f1)
%plot(x, f2)
plot(x, f)
title('Phase Portrait')
xlabel('x')
ylabel('xdot')
hold off