h = 0.6; Tg = 10; To = 90; dT = To-Tg; r = 0.125; D = 2*r; k = 0.8; hc = 300;

%Part i)
QdotLi = k*2*pi*dT/log(4*h/D)

%Part ii)
Reff = 1/(hc*2*r) + log(4*h/D)/(2*pi*k);

QdotLii = dT/Reff