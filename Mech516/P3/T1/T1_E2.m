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
tic; Wp_m = EulerSolver('MH', Wp, Up, gamma, N, T, dt, dx, 'minmod'); toc; %minmod slope limiter
tic; Wp_s = EulerSolver('MH', Wp, Up, gamma, N, T, dt, dx, 'superbee'); toc; %superbee slope limiter
tic; Wp_v = EulerSolver('MH', Wp, Up, gamma, N, T, dt, dx, 'vanleer_nonsmooth'); toc; %van leer slope limiter

%% Evaluate error metric
L2_norm = @(e, s) sqrt(sum((s-e).^2,2)); %Calculate L2 norm error for each of the 3 variables

L2_m = L2_norm(Wp_rie, Wp_m);
L2_s = L2_norm(Wp_rie, Wp_s);
L2_v = L2_norm(Wp_rie, Wp_v);

L2_errs = [L2_m L2_s L2_v];

%% Plot results
plot_results = true;
if plot_results
    figure;
    subplot(3,1,1)
    hold on;
    plot(xp, Wp_rie(1,:),'DisplayName','Exact')
    plot(xp, Wp_m(1,:),'o','DisplayName','Minmod')
    plot(xp, Wp_s(1,:),'o','DisplayName','Superbee')
    plot(xp, Wp_v(1,:),'o','DisplayName','Van Leer (Non-Smooth)')
    hold off;
    ylabel('Density (kg/m^3)')
    legend('Location','best')

    subplot(3,1,2)
    hold on;
    plot(xp, Wp_rie(2,:))
    plot(xp, Wp_m(2,:),'o')
    plot(xp, Wp_s(2,:),'o')
    plot(xp, Wp_v(2,:),'o')
    hold off;
    ylabel('Velocity (m/s)')
    %legend('Location','best')

    subplot(3,1,3)
    hold on;
    plot(xp, Wp_rie(3,:),'DisplayName','Exact')
    plot(xp, Wp_m(3,:),'o')
    plot(xp, Wp_s(3,:),'o')
    plot(xp, Wp_v(3,:),'o')
    hold off;
    ylabel('Pressure (Pa)')
    xlabel('Position')
    %legend('Location','best')
    
    %Error metric plot
    X = categorical({'rho','u','p'});
    X = reordercats(X,{'rho','u','p'});
    figure;
    bar(X, L2_errs)
    ylabel('L2 Norm')
end
