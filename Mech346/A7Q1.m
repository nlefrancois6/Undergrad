NuL = @(ReL, Pr) 0.664*(5*10^5)*Pr^(1/2) + 0.037*ReL^(4/5)*Pr^(1/3)*(1-(5*10^5/ReL)^(4/5));

ReL = 3.88*1e6; Pr = 8.47;
%NuL = NuL(ReL, Pr);
NuL = 9776;

Ts = 297; Tinf = 286;
kw = 0.593; L = 1.8; A = 2;
hconv = NuL*kw/L;
Rconv = 1/(A*hconv);
Rn = 0.03; Rw = 8.4*1e-4;
Rth = Rconv + Rn + Rw;
Qdot = (Ts-Tinf)/Rth;
Qdot_kcals = Qdot*0.859;
timbit = 50; num_bits = Qdot_kcals/timbit