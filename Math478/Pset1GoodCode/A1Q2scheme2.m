close all;
clear all;

draw = false;
%% Setup domain
LX = 2*pi;
Tf = 1;

NP = 64; dx1 = LX/NP;
numVals = 10;
dx = linspace(0.1*dx1, 1*dx1,numVals);

dt = 0.1./(4.*((4/3).*(1./dx.^2)-1));

%Needs to be <= 1

4.*dt.*(1+1./(dx.^2))+1;

ErT = zeros(numVals,1);
ErX = zeros(numVals,1);

xg = linspace(0, LX, NP+1); %xg(end) = []; 
xg = xg(:);

%Exact solution
uE = @ (x, t) (1 + cos(2*x))*sin(t);


for time=1:numVals
    [ugT] = A2Q2scheme2Solver(NP, dx(1), dt(time), xg, uE, dt(time), draw);

    %Local Error
    ErT(time) = max(ugT - uE(xg, dt(time)));
end

for space=1:numVals
    [ugX] = A2Q2scheme2Solver(NP, dx(space), dt(numVals/2), xg, uE, dt(numVals/2), draw);

    %Local Error
    ErX(space) = max(ugX - uE(xg, dt(numVals/2)));
end


%{
subplot(1,2,1)
%subplot(1,1,1)
loglog(dt(1:end), ErT(1:end), 'b');
hold on;
loglog(dt(1:end), (dt(1:end)).^(1));
loglog(dt(1:end), (dt(1:end).^(2)));
hold off;
title('Local Time Convergence Error')
xlabel('dt')
ylabel('Error')
legend({'Numerical Sol.','Er=dt','Er=dt^2'},'Location','southeast')
%}

p = polyfit(dx,ErX',1)
ErXfit = polyval(p,dx);

subplot(1,1,1)
%subplot(1,2,2)
loglog(dx(1:end), ErXfit(1:end), 'b');
hold on;
loglog(dx(1:end), (dx(1:end)).^(-1));
loglog(dx(1:end), (dx(1:end)).^(-2));
hold off;
title('Local Space Convergence Error')
xlabel('dx')
ylabel('Error')
legend({'Numerical Sol.','Er=dx','Er=dx^2'},'Location','northeast')


