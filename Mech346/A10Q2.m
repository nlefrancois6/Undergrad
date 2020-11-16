Tm = 2273; Ts = 973; Te = 303; Dm = 0.003; Ds = 0.05; theta = 30;
frac = theta/360; sig = 5.67*1e-8;
Am_L = pi*Dm; As_L = (1-frac)*pi*Ds;

Fme = frac;
Qme = Am_L*Fme*sig*(Tm^4-Te^4);

Fms = 1-frac;
Qms = Am_L*Fms*sig*(Tm^4-Ts^4);

Fsie = frac;
Qsie = As_L*Fsie*sig*(Ts^4-Te^4);

Qme_ns = Am_L*sig*(Tm^4-Te^4);




