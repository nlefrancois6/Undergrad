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


%% Run Solvers

%Get exact solution of riemann problem
tic;
Wp_rie = zeros(3,N); %Initialize storage for solutions
x0 = 0; t0 = 0; %sampling pt offsets
for i=1:N
    xi = xp(i); %select sampling location
    Wp_rie(:,i) = riemannSolver(T,t0,xi,x0,WL,WR,gamma); %evaluate solver at sampling location
end
toc;

%Get numerical solutions using solvers
tic; Wp_none = EulerSolver('MH', Wp, Up, gamma, N, T, dt, dx, 'none'); toc; %No slope limiter
tic; Wp_zero = EulerSolver('MH', Wp, Up, gamma, N, T, dt, dx, 'zero'); toc; %Zero slope
tic; Wp_minmod = EulerSolver('MH', Wp, Up, gamma, N, T, dt, dx, 'minmod'); toc; %Minmod slope limiter

%Total runtime: 0.6s, 2675s/45m, 5s, 0.7s
%% Plot results
plot_results = true;
if plot_results
    figure;
    subplot(3,1,1)
    hold on;
    plot(xp, Wp_rie(1,:),'DisplayName','Exact')
    plot(xp, Wp_none(1,:),'o','DisplayName','None')
    plot(xp, Wp_zero(1,:),'o','DisplayName','Zero')
    plot(xp, Wp_minmod(1,:),'o','DisplayName','Minmod')
    hold off;
    ylabel('Density (kg/m^3)')
    legend('Location','best')

    subplot(3,1,2)
    hold on;
    plot(xp, Wp_rie(2,:),'DisplayName','Exact')
    plot(xp, Wp_none(2,:),'o','DisplayName','None')
    plot(xp, Wp_zero(2,:),'o','DisplayName','Zero')
    plot(xp, Wp_minmod(2,:),'o','DisplayName','Minmod')
    hold off;
    ylabel('Velocity (m/s)')
    %legend('Location','best')

    subplot(3,1,3)
    hold on;
    plot(xp, Wp_rie(3,:),'DisplayName','Exact')
    plot(xp, Wp_none(3,:),'o','DisplayName','None')
    plot(xp, Wp_zero(3,:),'o','DisplayName','Zero')
    plot(xp, Wp_minmod(3,:),'o','DisplayName','Minmod')
    hold off;
    ylabel('Pressure (Pa)')
    xlabel('Position')
    %legend('Location','best')
end
