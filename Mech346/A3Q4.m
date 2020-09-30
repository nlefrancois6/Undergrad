t = 0.0002; s = 0.003; di = 0.02; do = 0.05; ri = di/2; ro = do/2;
hnf = 20; hf = 15; k = 42;

beta = 60; br1 = 0.59; br2 = 1.5;
k1r1 = besselk(1,br1); i1r2 = besseli(1,br2); i1r1 = besseli(1,br1); k1r2 = besselk(1, br2);
k0r1 = besselk(0,br1); i0r1 = besseli(0,br1);

eta = (di/beta)/(ro^2-ri^2)*(k1r1*i1r2 - i1r1*k1r2)/(k0r1*i1r2 + i0r1*k1r2);
Anf = pi*di*s; Af = pi*di*t; Auf = Anf-Af;

Rtf = 1/(hf*(Auf + eta*Af))
Rtnf = 1/(hnf*Anf)