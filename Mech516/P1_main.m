%define problem ICs
rhoL = 1; rhoR = 1;
uL = 0; uR = 0;
pL = 0.01; pR = 100;

WL = [rhoL uL pL]; %left ICs 
WR = [rhoR uR pR]; %right ICs
gamma = 1.4; %specific heat ratio

%Calculate speed of sound
T0 = 300; R=8.31; M=0.02897;
c = sqrt(gamma*R*T0/M);

%sampling point
x = 0.1; t = 0.035; %Coordinates
x0 = 0; t0 = 0; %Offsets

[W] = riemannSolver(t,t0,x,x0,WL,WR,gamma,c);
        
        







