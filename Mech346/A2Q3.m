Di = 0.00825; Do = 0.00970; Ri = Di/2; Ro = Do/2; s = 0.0175;
Qcore = 152.4; Tw = 400; hc = 1e4; hi = 6000; kU = 2.5; kZ = 17.2;

vfracFuel = pi*Ri^2/s^2;
Qfuel = Qcore/vfracFuel;

%After cancelling out 2piL
Rint = 1/(Ri*hi); Rz = log(Ro/Ri)/kZ; Rconv = 1/(hc*Ro);
Rth = Rint + Rz + Rconv;

T1 = 2*pi*Qcore*s^2*Rth^(1) + Tw

Tmax = T1 + Qfuel*Ri^2/(4*kU)

