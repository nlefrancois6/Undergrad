clear all;
%% Define sampling domain
T = 10; %final time
xl = -50; xr = 50; %edges of computational domain
dx = 1; %mesh size
N = (xr-xl)/dx; %number of sampling pts
xp = linspace(xl, xr, N); %array of gridpoints (need to adjust to ensure 0&20 are gridpoints)

%% Define problem ICs on left and right sides
%Gas properties
gamma = 1.4; Rgas = 8.31; M=0.02897; T0 = 300;
c = sqrt(gamma*Rgas*T0/M);
%c = sqrt(gamma*pL/rhoL); %Gives ~5 compared to 347, not sure where it's derived from

R=0.9; %Courant number 
dt = R*dx/c; %dt calculated with constant Courant number
%Richtmeyer stable for c*dt/dx<2, giving R<2

rhoL = 1; rhoR = 1; %density 1 1
uL = 0; uR = 0; %velocity 0 0
pL = 1; pR = 2; %pressure 1 2 %seems like p gets scaled by rho when it shouldn't

WL = [rhoL uL pL]; %left ICs 
WR = [rhoR uR pR]; %right ICs
Wp = zeros(3,N);
for i=1:N
    if xp(i)<0
        Wp(:,i) = WL;
    else 
        Wp(:,i) = WR;
    end
end
Up = WtoU(Wp, gamma);

%% Run Solver
solver = 'richtmyer'; %Options: 'godunov','riemann','roe','richtmyer'
tic;
if strcmp(solver,'godunov') || strcmp(solver, 'roe') || strcmp(solver, 'richtmyer')
    Wp = EulerSolver(solver, Wp, Up, gamma, N, T, dt, dx);
elseif strcmp(solver,'riemann')
    Wp = zeros(3,N); %Initialize storage for solutions
    x0 = 0; t0 = 0; %sampling pt offsets
    for i=1:N
        xi = xp(i); %select sampling location
        Wp(:,i) = riemannSolver(T,t0,xi,x0,WL,WR,gamma); %evaluate solver at sampling location
    end
end
toc;

%Get exact solution of riemann problem
tic;
Wp_e = zeros(3,N); %Initialize storage for solutions
x0 = 0; t0 = 0; %sampling pt offsets
for i=1:N
    xi = xp(i); %select sampling location
    Wp_e(:,i) = riemannSolver(T,t0,xi,x0,WL,WR,gamma); %evaluate solver at sampling location
end
toc;
%% Plot results
plot_results = true;
if plot_results
    figure;
    subplot(3,1,1)
    hold on;
    plot(xp, Wp_e(1,:))
    plot(xp, Wp(1,:),'o')
    hold off;
    ylabel('Density (kg/m^3)')

    subplot(3,1,2)
    hold on;
    plot(xp, Wp_e(2,:))
    plot(xp, Wp(2,:),'o')
    hold off;
    ylabel('Velocity (m/s)')

    subplot(3,1,3)
    hold on;
    plot(xp, Wp_e(3,:))
    plot(xp, Wp(3,:),'o')
    hold off;
    ylabel('Pressure (Pa)')
    xlabel('Position')
end
