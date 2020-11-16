Di = 0.016; Do = 0.05; Ti = 338; Tinf = 299; Tf = 273+50;
k = 0.02735; v = 1.798*1e-5; Pr = 0.7228; beta = 1/Tf; g = 9.81;

eps_h = 0.88; A_L = pi*Di; sig = 5.67*1e-8;

Qrad_L = A_L*eps_h*sig*(Ti^4-Tinf^4);

Gr = g*beta*(Tf-Tinf)*Do^3/v^2;
Ra = Gr*Pr;

Nu = (0.6 + 0.387*(Ra/(1+(0.559/Pr)^(9/16))^(16/9))^(1/6))^2;
h = Nu*k/Do;

Rconv = h*(Tf-Tinf)*pi*Do;
Rcond = log(Do/Di)/(2*pi*Do*k)
Qdot = (Ti-Tinf)/(Rcond+Rconv)
