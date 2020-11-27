Tw = 25; Qh = 63; sig = 5.67*1e-8;
h = 0.1; d1 = 0.1; d2 = 0.15;

A1 = pi*d1^2/4; A2 = pi*d2^2/4;

F11 = 0; F22 = 0;

ri = d2/2; rj = d1/2;
Ri = ri/h; Rj = rj/h;
S = 1 + (1+Rj^2)/Ri^2;
F21 = 0.5*(S - (S^2 - 4*(rj/ri)^2)^(1/2));
F23 = 1 - F21;

F12 = (A2/A1)*F21;
F13 = 1 - F12;

E3 = sig*(Tw+273)^4;

%A)
T2 = (Qh*F12/sig)^(1/4);

%B)
E_2 = sig*T2^4;
E1 = Qh/A1 + F12*E_2 + F13*E3;
T1 = (E1/sig)^(1/4) - 273;
%Check assumption validity
dT23 = T2^4 - Tw^4;
dT21 = T1^4 - T2^4;

%C)
d4 = 0.01; A4 = pi*(d4/2)^2;
rj = d1/2; ri = d4/2;
Ri = ri/h; Rj = rj/h;
S = 1 + (1+Rj^2)/Ri^2;
F41 = 0.5*(S - (S^2 - 4*(rj/ri)^2)^(1/2));
%F14 = (A4/A1)*F14;
F43 = 1-F41;

E4 = F41*E1 + F43*E3;
T4 = (E4/sig)^(1/4) - 273;


