uinf = 5; rho = 1; cp = 1000;
Tinf = 50; Tw = 10; dT = Tinf-Tw;

d = 0.0166; L = 0.2; W = 1; Qtot = 132.8;

%a)
A = L*W;
ReL = (1.328*A*rho*uinf^2/(2*d))^2;
mu = rho*uinf*L/ReL

%b)
cf = 1.328/sqrt(ReL);
qtot = Qtot/A;
h = qtot/dT;
frac = cf*rho*cp*uinf/(2*h);
k = mu*cp*frac^(-3/2)

