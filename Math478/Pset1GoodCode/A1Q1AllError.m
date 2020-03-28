close all;
clear all;

plot = false;
%% Setup domain
LX = 2*pi;
Tf = 1;

R = 0.5; c = 1;
NP = 64; dx1 = LX/NP;

numVals = 8;
%Best dx range for local time&global space and local space respectively
%dx = linspace(1*dx1,5*dx1,numVals);
dx = linspace(0.09*dx1,1*dx1,numVals);

dt = R*dx;

ErTUWLoc = zeros(numVals,1);
ErTLWLoc = zeros(numVals,1);
ErTLFLoc = zeros(numVals,1);

ErXUWLoc = zeros(numVals,1);
ErXLWLoc = zeros(numVals,1);
ErXLFLoc = zeros(numVals,1);

ErXUWGlob = zeros(numVals,1);
ErXLWGlob = zeros(numVals,1);
ErXLFGlob = zeros(numVals,1);

xg = linspace(0, LX, NP+1); %xg(end) = []; 
xg = xg(:);

%Exact solution
uE = @ (x, t) 1 + cos(2*(x+t));

%IC
u0 = @ (x) 1 + cos(2*x);

for time=1:numVals
[ugUWLoc] = UWSolver(NP, dx(numVals/2), dt(time), xg, u0, uE, dt(time), plot);
[ugLWLoc] = LWSolver(NP, dx(numVals/2), dt(time), xg, u0, uE, dt(time), plot);
[ugLFLoc, xgLFLoc] = LFSolverGood(LX,NP,u0,dt(time),dx(numVals/2),dt(time));

%[ugUWGlob] = UWSolver(NP, dx(numVals/2), dt(time), xg, u0, uE, Tf, plot);
%[ugLWGlob] = LWSolver(NP, dx(numVals/2), dt(time), xg, u0, uE, Tf, plot);
%[ugLFGlob, xgLFGlob] = LFSolverGood(LX,NP,u0,dt(time),dx(numVals/2),Tf);

%Local Error
ErTUWLoc(time) = max(ugUWLoc - uE(xg, dt(time)));
ErTLWLoc(time) = max(ugLWLoc - uE(xg, dt(time)));
ErTLFLoc(time) = max(ugLFLoc - uE(xgLFLoc, dt(time)));

%Global Error
%ErXUWGlob(time) = max(ugUWGlob - uE(xg, dt(numVals/2)));
%ErXLWGlob(time) = max(ugLWGlob - uE(xg, dt(numVals/2)));
%ErXLFGlob(time) = max(ugLFGlob - uE(xgLFGlob, dt(numVals/2)));
end

for space=1:numVals
[ugUWLoc] = UWSolver(NP, dx(space), dt(5), xg, u0, uE, dt(5), plot);
[ugLWLoc] = LWSolver(NP, dx(space), dt(5), xg, u0, uE, dt(5), plot);
[ugLFLoc, xgLFLoc] = LFSolverGood(LX,NP,u0,dt(5),dx(space),dt(5));

[ugUWGlob] = UWSolver(NP, dx(space), dt(numVals/2), xg, u0, uE, Tf, plot);
[ugLWGlob] = LWSolver(NP, dx(space), dt(numVals/2), xg, u0, uE, Tf, plot);
[ugLFGlob, xgLFGlob] = LFSolverGood(LX,NP,u0,dt(numVals/2),dx(space),Tf);

%Local Error
ErXUWLoc(space) = max(ugUWLoc - uE(xg, dt(5)));
ErXLWLoc(space) = max(ugLWLoc - uE(xg, dt(5)));
ErXLFLoc(space) = max(ugLFLoc - uE(xgLFLoc, dt(5)));

%Global Error
ErXUWGlob(space) = max(ugUWGlob - uE(xg, dt(numVals/2)));
ErXLWGlob(space) = max(ugLWGlob - uE(xg, dt(numVals/2)));
ErXLFGlob(space) = max(ugLFGlob - uE(xgLFLoc, dt(numVals/2)));
end
%{
%subplot(1,3,1)
subplot(1,1,1)
loglog(dt(2:end), ErTUWLoc(2:end), 'b');
hold on;
loglog(dt(2:end), ErTLWLoc(2:end), 'r');
loglog(dt(2:end), ErTLFLoc(2:end), 'k');
loglog(dt(2:end), (dt(2:end)));
loglog(dt(2:end), (dt(2:end).^2));
hold off;
title('Local Time Convergence Error')
xlabel('dt')
ylabel('Error')
legend({'Upwind','Lax-Wendroff','Lax-Friedrich','Er=dt','Er=dt^2'},'Location','southeast')
%}

%subplot(1,3,2)
subplot(1,1,1)
loglog(dx(3:end), ErXUWLoc(3:end), 'b');
hold on;
loglog(dx(3:end), ErXLWLoc(3:end), 'r');
loglog(dx(3:end), ErXLFLoc(3:end), 'k');
loglog(dx(3:end), (dx(3:end)).^(-1));
loglog(dx(3:end), (dx(3:end).^(-2)));
hold off;
title('Local Space Convergence Error')
xlabel('dx')
ylabel('Error')
legend({'Upwind','Lax-Wendroff','Lax-Friedrich','Er=dx','Er=dx^2'},'Location','southwest')

%{
%subplot(1,3,3)
subplot(1,1,1)
loglog(dx(3:end), ErXUWGlob(3:end), 'b');
hold on;
loglog(dx(3:end), ErXLWGlob(3:end), 'r');
loglog(dx(3:end), ErXLFGlob(3:end), 'k');
loglog(dx(3:end), (dx(3:end)).^(-1))
loglog(dx(3:end), (dx(3:end)).^(-2));
%loglog(dx(3:end), flip((dx(3:end))))
%loglog(dx(3:end), flip((dx(3:end)).^2));
hold off;
title('Global Space Convergence Error')
xlabel('dx')
ylabel('Error')
legend({'Upwind','Lax-Wendroff','Lax-Friedrich','Er=dx','Er=dx^2'},'Location','southwest')
%}
