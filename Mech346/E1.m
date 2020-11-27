Ts = 100; Ti = 30; Tf = 64.81;
d = 0.01; rho = 2200; cp = 700;
t = 120;

theta = (Tf-Ti)/(Ts-Ti);

alpha = (d/(2*sqrt(t)*erfcinv(theta)))^2;

k = alpha*rho*cp