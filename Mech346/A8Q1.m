mdot = 0.0123; rho = 1000; mu = 0.001; Dh = 0.0222;
Ac = pi*Dh^2/4; L = 16.5;

Uav = mdot/(rho*Ac);
ReD = rho*Uav*Dh/mu;
xe_D = 0.05*ReD;

Pr = 7; %not sure if i need to look up diffusivities for this
xet_D = 0.034*ReD*Pr;

f_Darcy = 64/ReD;

pressure_drop = f_Darcy*(L*rho*Uav^2/(Dh*2))