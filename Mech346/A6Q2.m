Re = @(x, uinf, rho, mu) rho.*uinf.*x./mu;
Pr = @(mu, cp, k) mu*cp/k;
Nu = @(x, Re, Pr) 0.332.*Re.^(1/2).*Pr.^(1/3);

Tw = 12; Tinf = 8; dT = (Tw+Tinf)/2; rho = 999.2; mu = 1.31*1e-3; cp = 4195; k = 0.585; A = 0.5;
dT = Tw-Tinf;
%L = sqrt(A/pi)*2;

%a)
U1 = 2; Fd1 = 3.73;
Pr = Pr(mu, cp, k);
h1 = Fd1*cp/(A*U1*Pr^(2/3));
Q1 = h1*A*dT;

%b)
U2 = 9; Q2 = 23.43*1e3;
Fd2 = Q2*U2*Pr^(2/3)/(cp*dT);

%Interpolate to get Fd at U3=5m/s
U3 = 5; Fd3 = ((Fd2-Fd1)/(U2-U1))*(U3-U1) + Fd1;
h3 = Fd3*cp/(A*U3*Pr^(2/3))
Q3 = h3*A*dT

