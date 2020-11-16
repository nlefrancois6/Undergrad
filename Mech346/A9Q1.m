ks = 0.49; kg = 0.025; cp = 1000; mu = 2*1e-5; rho = 1; beta = 0.003;
D = 0.02; Tinf = 20; Tw = 100; dT = Tw - Tinf; g = 9.81;

V = 4*pi*(D/2)^3/3; A = 4*pi*(D/2)^2;

Gr = g*beta*dT*D^3/(mu/rho)^2;
Pr = mu*cp/kg;
Ra = Gr*Pr;

Nu = 2 + 0.589*Ra^(1/4)/(1+(0.492/Pr)^(9/16))^(4/9);
h = Nu*kg/D;

Qdot_gen = h*A*dT/V;

c2 = 100 + Qdot_gen*(D/2)^2/(ks*6);