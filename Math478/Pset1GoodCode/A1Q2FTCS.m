close all;
clear all;

plotSw = false;
%% Setup domain
LX = 2*pi;
Tf = 1;

NP = 64; dx1 = LX/NP;

numVals = 20;
%Best dx range for global time and global space respectively (use
%numVals~20)
%dx = linspace(0.1*dx1,1*dx1,numVals);
dx = linspace(1*dx1, 7*dx1,numVals);

dt = 0.8./(4.*((4/3).*(1./dx.^2)-1));

R = (dt./dx.^2);

%Needs to be <= 1
abs(4.*dt.*(1-(4/3).*(1./(dx.^2)))+1);

ErT = zeros(numVals,1);
ErX = zeros(numVals,1);

xg = linspace(0, LX, NP+1); %xg(end) = []; 
xg = xg(:);

%Exact solution
uE = @ (x, t) (1 + cos(2*x))*sin(t);


for time=1:numVals
    [ugTGlob] = FTCSSolver(NP, dx(end), dt(time), xg, uE, Tf, plotSw);
    

    %Global Error
    ErT(time) = max(ugTGlob - uE(xg, Tf));
end

for space=1:numVals
    [ugXGlob] = FTCSSolver(NP, dx(space), dt(end/2), xg, uE, Tf, plotSw);
    

    %Global Error
    ErX(space) = max(ugXGlob - uE(xg, Tf));
end

subplot(1,2,1)
%subplot(1,1,1)
loglog(dt(2:end), ErT(2:end), 'b');
hold on;
loglog(dt(2:end), (dt(2:end)).^(1));
loglog(dt(2:end), (dt(2:end).^(2)));
hold off;
title('Global Time Convergence Error')
xlabel('dt')
ylabel('Error')
legend({'FTCS','Er=dx','Er=dx^2'},'Location','southeast')

subplot(1,2,2)
%p = polyfit(dx,ErX',1)
%ErXfit = polyval(p,dx);

%subplot(1,1,1)
%loglog(dx(1:end), ErXfit(1:end), 'b');
loglog(dx(1:end), ErX(1:end), 'bo');
hold on;
loglog(dx(1:end), (dx(1:end)).^(-1));
loglog(dx(1:end), (dx(1:end)).^(-2));
loglog(dx(1:end), (dx(1:end).^(-0.5)));
hold off;
title('Global Space Convergence Error')
xlabel('dx')
ylabel('Error')
legend({'FTCS','Er=dx','Er=dx^2','Er=dx^{1/2}'},'Location','southwest')
