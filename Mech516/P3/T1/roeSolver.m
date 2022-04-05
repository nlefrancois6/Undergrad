function [F] = roeSolver(WL,WR,gamma)

UL = WtoU(WL, gamma); UR = WtoU(WR, gamma); %convert primitive vectors to U vectors
FL = WtoF(WL, gamma); FR = WtoF(WR, gamma); %convert primitive vectors to flux vectors
dU = UR-UL; %compute delta U

%unpack primitive vectors and compute specific enthalpy
rhoL = WL(1); uL = WL(2); pL = WL(3);
rhoR = WR(1); uR = WR(2); pR = WR(3);
HL = (gamma/(gamma-1))*pL./rhoL + uL.^2/2; HR = (gamma/(gamma-1))*pR./rhoR + uR.^2/2;
%Compute Roe-averaged velocity and specific enthalpy
us = (sqrt(rhoL).*uL+sqrt(rhoR).*uR)./(sqrt(rhoL)+sqrt(rhoR));
Hs = (sqrt(rhoL).*HL+sqrt(rhoR).*HR)./(sqrt(rhoL)+sqrt(rhoR));

%Compute eigenvalues of As 
cs = sqrt((gamma-1)*(Hs-0.5*us.^2));
e1 = us-cs; e2 = us; e3 = us+cs;

%Entropy fix for absolute value of eigenvalues
delta = 0.9;
e_abs1 = abs(e1).*(abs(e1)>delta) + ((abs(e1)^2 + delta^2)./(2*delta)).*(abs(e1)<=delta);
e_abs2 = abs(e2).*(abs(e2)>delta) + ((abs(e2)^2 + delta^2)./(2*delta)).*(abs(e2)<=delta);
e_abs3 = abs(e3).*(abs(e3)>delta) + ((abs(e3)^2 + delta^2)./(2*delta)).*(abs(e3)<=delta);

%Compute right eigenvectors Rs
Rs1 = [1; us-cs; Hs-us.*cs];
Rs2 = [1; us; 1/2*us^2]; %should this be 1/(2*us^2)?
Rs3 = [1; us+cs; Hs+us*cs];

% Compute Roe waves strength alpha
alpha2 = (gamma-1)/(cs.^2).*(dU(1).*(Hs-us.^2) + us.*dU(2) - dU(3));
alpha1 = 1/(2*cs).*(dU(1).*(us+cs) - dU(2)-cs.*alpha2);
alpha3 = dU(1)-(alpha1 + alpha2);

%Compute flux at interface
sumterm = alpha1.*e_abs1.*Rs1 + alpha2.*e_abs2.*Rs2 + alpha3.*e_abs3.*Rs3;
F = 0.5*(FL + FR - sumterm); 



end