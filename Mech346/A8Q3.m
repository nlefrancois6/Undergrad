mdot = 0.01; k = 0.116; mu = 15.6*1e-6; rho = 0.241; Pr = 0.7

D = [0.003; 0.005; 0.01; 0.015; 0.02; 0.025; 0.03];

%Laminar
Act = 0.007;
Ua = mdot./(rho.*Act);
ReD = rho.*Ua.*D./mu;
Nu = 3.658;
h = Nu.*k./D;
hNP = 4.*h.*Act./D;
dp_L = 64.*rho.*Ua.^2./(ReD.*D.*2);
mdotdP_rhoL = mdot.*dp_L./rho;
T_Laminar = table(D, ReD, h, hNP, mdotdP_rhoL)

%Turbulent
Act = 3*1e-4;
Ua = mdot./(rho.*Act);
ReD = rho.*Ua.*D./mu;
fD = (1.8.*log10(6.9./ReD)).^(-2);
Nu = (fD./8).*(ReD - 1000).*Pr./(1+12.7.*sqrt(fD./8).*(Pr^(2/3)-1));
h = Nu.*k./D;
hNP = 4.*h.*Act./D;
dp_L = fD.*rho.*Ua.^2./(2.*D);
mdotdP_rhoL = mdot.*dp_L./rho;
T_Turbulent = table(D, ReD, h, hNP, mdotdP_rhoL)



