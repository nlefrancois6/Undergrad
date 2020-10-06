Qdotgen = 20; W = 0.1; L=0.2; H= 0.005; rho = 750; c=1500; k=2; Ta = 20; ha = 4;
t = 120;

V = L*W*H; A = 2*L*W + 2*W*H + 2*L*H;
tau = rho*V*c/(ha*A);

T = @(t) -Qdotgen*exp(-t/tau)/(ha*A) + Ta + Qdotgen/(ha*A);

Tfinal = T(120)

Qdot = -ha*A*(Tfinal - Ta)