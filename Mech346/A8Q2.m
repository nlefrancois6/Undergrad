L = 0.2; W = 0.002; H = 0.14; Ti = 15; Tb = 32.5; Ts = 50; Ua = 4;
P = 2*(W+H); A = W*H;
Dh = 4*A/P;

rho = 1.184; mu = 1.849*1e-5; k = 0.02551;
Re = rho*Ua*Dh/mu;
xe_D = 0.05*Re;

Nu = 8.24;
h = Nu*k/Dh;
qw = h*(Ts-Tb);
Qtot = qw*H*L