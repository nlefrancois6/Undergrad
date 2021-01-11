clear all;
close all;
%System: xdot = -x
%Analytical solution
xtrue = @(t) exp(-t);
%Def initial conditions
dt = 1;
T=1;
size = [0; 1; 2; 3; 4];
errorStore = zeros(5,1);
for n=0:4
    x=1;
    t=0;
    dt = 10^(-n);
    N=T/dt;
    %xstore = zeros(N,1); tstore = zeros(N,1);
    for ts=1:N
        xnew = x - dt*x;
        t = t + dt;
        x = xnew;
        xstore(ts,1) = x;
        tstore(ts,1) = t;
    end

    errorStore(n+1,1)=abs(x-xtrue(T));

end

hold on
plot(10.^(-size),errorStore,'ro')
title('Forward Euler Method Error')
xlabel('dt')
ylabel('|x_T - x(T)|')
hold off
% Output the plot as a .png file
print('-dpng','-r300','EulerErrorLinear.png')

figure;
hold on
loglog(10.^(-size),errorStore,'ro')
title('Forward Euler Method Error')
xlabel('log(dt)')
ylabel('log(|x_T - x(T)|)')
set(gca,'YScale','log'); set(gca,'XScale','log');
hold off
% Output the plot as a .png file
print('-dpng','-r300','EulerErrorLogLog.png')
