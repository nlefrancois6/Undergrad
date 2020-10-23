Re = @(x, uinf, rho, mu) rho.*uinf.*x./mu;
Pr = @(v, alpha) v/alpha;
Nu = @(x, Re, Pr) 0.332.*Re.^(1/2).*Pr.^(1/3);
qx = @(x, Nu, dT, k) k*Nu*dT/x;
dx = @(x, Re) 4.92*x/sqrt(Re);
dtx = @(Pr, dx) dx*Pr^(-1/3);

uinf = 2; mu = 1.9295*1e-5; rho = 1.118; v = 1.725*1e-5; alpha = 2.381*1e-5; k = 0.026805;
Tinf = 60; Tw = 27; dT = Tinf-Tw;
x1 = 0.2; x2 = 0.4;
%a)
Re1 = Re(x1, uinf, rho, mu); Re2 = Re(x2, uinf, rho, mu);
dx1 = dx(x1, Re1); dx2 = dx(x2, Re2);
%b)
Pr = Pr(v, alpha);
dtx1 = dtx(Pr, dx1); dtx2 = dtx(Pr, dx2);
%c), d)
Nu1 = Nu(x1, Re1, Pr); Nu2 = Nu(x2, Re2, Pr);
qxInt = @(x) k.*Nu(x,Re(x,uinf,rho,mu),Pr).*dT./x;
Q1 = integral(qxInt,0,x1)
Q2 = integral(qxInt,0,x2)
