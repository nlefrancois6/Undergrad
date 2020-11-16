D = 7; H = 13; Tw = 700; Tinf = 300; Tf = (Tw+Tinf)/2; dT = Tw - Tinf;
k = 0.039545; v = 3.798*1e-5; Pr = 0.6958; beta = 1/Tf; g = 9.81;
A = pi*D*H;

lhs = D/H;
Gr = g*beta*dT*H^3/v^2;
rhs = 35*Gr^(-1/4);

Ra = Gr*Pr;
Nu = (0.825 + 0.387*(Ra/(1+(0.492/Pr)^(9/16))^(8/27))^(1/6))^2;
h = Nu*k/H;

Qconv = h*A*dT;

Qsolar = 20*1e6;
fracLoss = Qconv/Qsolar;

%Natural Conv negligible
Uncn = sqrt(10*Gr)*v/H;

Rencn = Uncn*H/v;
param_ncn = Gr/Rencn^2;

%Forced Conv negligible
Ufcn = sqrt(0.1*Gr)*v/H;
Refcn = Ufcn*H/v;
param_fcn = Gr/Refcn^2;

