Te = 300; Ts = 1500; Tb = 1900; D = 0.08; H = 0.16; sig = 5.67*1e-8;
Ab = pi*(D/2)^2; As = pi*D*H;
Eb = sig*Tb^4; Es = sig*Ts^4; Ee = sig*Te^4;

Fbe = (1-sqrt(D^2+1))/(D^2/2); Rbe = 1/(Ab*Fbe);
Q_be = (Ee-Eb)/Rbe;

Fbs = 1 + (1-sqrt(D^2+1))/(D^2/2); Rbs = 1/(Ab*Fbs); Rse = Rbs;
Q_se = (Es-Ee)/Rse;

Q_bs = (Eb-Es)/Rbs;

Q_e = Q_be + Q_se;

Q_h = Q_be + Q_bs;




