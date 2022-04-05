clear all;
%% Define sampling domain
T = 0.01; %final time

xl = 0; xr = 1.5;
h = 5; %Mesh refinement integer, h>=5
dx = 0.1/h; %mesh size
N = (xr-xl)/dx; %number of sampling pts excluding ghost pts
xp = linspace(xl, xr, N+1) - dx/2; %control volume centres, shifted left by dx/2 to place faces on 0.1, 1.5
xp = xp(2:end); %drop the extra cell on the left due to the shift

%% Define problem ICs
%Gas properties
gamma = 1.4; Rgas = 8.31; M=0.02897; T0 = 3000;
c = sqrt(gamma*Rgas*T0/M);

R = 100; %Courant number 
dt = R*dx/c; %dt calculated with constant Courant number
%dt = 0.1;
problem = 'T2'; %Options: 'T1', 'T2';

if strcmp(problem, 'T1')
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
elseif strcmp(problem,'T2')
    rho1 = 1; rho2 = 100; %density 1 100
    u1 = 0; u2 = 0; %velocity 0 0
    p1 = 1; p2 = 1000; %pressure 1 1000 %seems like p gets scaled by rho when it shouldn't

    W1 = [rho1 u1 p1]; %IC outside explosion
    W2 = [rho2 u2 p2]; %IC inside explosion
    Wp = zeros(3,N);
    for i=1:N
        if xp(i)<0.1
            Wp(:,i) = W2;
        else 
            Wp(:,i) = W1;
        end
    end
end
Up = WtoU(Wp, gamma);

%% Run Solver
solver = 'MH'; %Options: 'riemann','roe','MH'
limiter = 'vanleer_nonsmooth'; %Options: 'none','zero','minmod','superbee','vanleer_nonsmooth'
%'vanleer_smooth' doesn't work and I don't want to bother fixing the negative pressure steps
wall = true;

tic;
Wp = EulerSolver(solver, Wp, Up, gamma, N, T, dt, dx, wall, limiter);
toc;

%% Plot results
plot_results = true;
if plot_results
    figure;
    subplot(3,1,1)
    hold on;
    plot(xp, Wp(1,:),'o')
    hold off;
    ylabel('Density (kg/m^3)')

    subplot(3,1,2)
    hold on;
    plot(xp, Wp(2,:),'o')
    hold off;
    ylabel('Velocity (m/s)')

    subplot(3,1,3)
    hold on;
    plot(xp, Wp(3,:),'o')
    hold off;
    ylabel('Pressure (Pa)')
    xlabel('Position')
end
