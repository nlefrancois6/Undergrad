clear all;
%% Define sampling domain
T = 25; %final time
xl = -50; xr = 50; %edges of computational domain
dx = 1; %mesh size
N = (xr-xl)/dx; %number of sampling pts
xp = linspace(xl, xr, N); %array of gridpoints (need to adjust to ensure 0&20 are gridpoints)

%% Define problem ICs on left and right sides
%Gas properties
gamma = 1.4; Rgas = 8.31; M=0.02897; T0 = 300;
c = sqrt(gamma*Rgas*T0/M);

%R = 0.9; %Courant number 
%dt = R*dx/c; %dt calculated with constant Courant number

dt=0.5;

rhoL = 1; rhoR = 1; %density 1 1
uL = 0; uR = 0; %velocity 0 0
pL = 2; pR = 1; %pressure 1 2 %seems like p gets scaled by rho when it shouldn't

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
solver = 'MH'; %Options: 'riemann','roe','MH'
limiter = 'vanleer_nonsmooth'; %Options: 'none','zero','minmod','superbee','vanleer_nonsmooth'
%'vanleer_smooth' doesn't work and I don't want to bother fixing the negative pressure steps

tic;
if strcmp(solver, 'roe')
    Wp = EulerSolver(solver, Wp, Up, gamma, N, T, dt, dx);
elseif strcmp(solver, 'MH')
    Wp = EulerSolver(solver, Wp, Up, gamma, N, T, dt, dx, limiter);
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
