clear all;
%% Define sampling domain
T = 1; %final time
xl = -50; xr = 50; %edges of computational domain
dx = 1; %mesh size
N = (xr-xl)/dx; %number of sampling pts
xp = linspace(xl, xr, N); %array of gridpoints (need to adjust to ensure 0&20 are gridpoints)

%% Define problem ICs on left and right sides
%Gas properties
gamma = 1.4; Rgas = 8.31; M=0.02897; T0 = 300;
c = sqrt(gamma*Rgas*T0/M);

R=0.9; %Courant number 
dt = R*dx/c; %dt calculated with constant Courant number
%Richtmeyer stable for c*dt/dx<2, giving R<2

%I have L and R backwards compared to how the problem specifies
rhoL = 1; rhoR = 1; %density 1 1
uL = -19.59745; uR = -19.59745; %velocity 0 0
pL = 1000; pR = 0.01; %pressure 1 2

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
tic; Wp_g = EulerSolver('godunov', Wp, Up, gamma, N, T, dt, dx); toc; %godunov, 1st order
tic; Wp_roe = EulerSolver('roe', Wp, Up, gamma, N, T, dt, dx); toc; %roe, 1st order
tic; Wp_ric = EulerSolver('richtmyer', Wp, Up, gamma, N, T, dt, dx); toc; %richtmyer, 2nd order

%Total runtime: 0.6s, 2675s/45m, 5s, 0.7s
%% Plot results
plot_results = true;
if plot_results
    figure;
    subplot(3,1,1)
    hold on;
    plot(xp, Wp_rie(1,:),'DisplayName','Exact')
    plot(xp, Wp_g(1,:),'o','DisplayName','Godunov')
    plot(xp, Wp_roe(1,:),'o','DisplayName','Roe')
    plot(xp, Wp_ric(1,:),'o','DisplayName','Richtmyer')
    hold off;
    ylabel('Density (kg/m^3)')
    legend('Location','best')

    subplot(3,1,2)
    hold on;
    plot(xp, Wp_rie(2,:),'DisplayName','Exact')
    plot(xp, Wp_g(2,:),'o','DisplayName','Godunov')
    plot(xp, Wp_roe(2,:),'o','DisplayName','Roe')
    plot(xp, Wp_ric(2,:),'o','DisplayName','Richtmyer')
    hold off;
    ylabel('Velocity (m/s)')
    %legend('Location','best')

    subplot(3,1,3)
    hold on;
    plot(xp, Wp_rie(3,:),'DisplayName','Exact')
    plot(xp, Wp_g(3,:),'o','DisplayName','Godunov')
    plot(xp, Wp_roe(3,:),'o','DisplayName','Roe')
    plot(xp, Wp_ric(3,:),'o','DisplayName','Richtmyer')
    hold off;
    ylabel('Pressure (Pa)')
    xlabel('Position')
    %legend('Location','best')
end
