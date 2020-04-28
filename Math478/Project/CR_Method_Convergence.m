clear all
%% Set up the domain and x&y nodes
LX = 1;
LY = 1;

plotResults = false;

errors = zeros(1,9);
time = zeros(1,9);
for f=1:9
    NP = 2^f+1;
    xLen = LX*NP; yLen = LY*NP;
    sxp = linspace(0, LX, xLen); syp = linspace(0, LY, yLen+1); syp(end) = [];
    dx = sxp(2)-sxp(1);


    %% Def Source Term ICs

    g0_func = @(x,y) sin(2*pi/LX.*x).*sin(2*pi/LY.*y);
    u_exact_func = @(x,y) -1*((2*pi/LX)^2+(2*pi/LY)^2)^(-1)*sin(2*pi/LX.*x).*sin(2*pi/LY.*y);

    [X,Y]=meshgrid(sxp,syp);
    g0 = g0_func(X,Y);
    u_exact = u_exact_func(X,Y);

    tic;
    g = fft(g0, size(g0,2), 2);

    %Solve 2D poisson for u
    [u, maxErr] = FACR_Solver(xLen, yLen, NP, LX, dx, f, g0, g, u_exact, plotResults);
    time(f) = toc;
    errors(f) = maxErr;
end
subplot(2,1,1)
plot(errors,'ro')
title('a) Maximum Error Convergence Plot', 'FontSize', 24)
xlabel('Grid Size Exponent (f)', 'FontSize', 20)
ylabel('Maximum Error', 'FontSize', 20)

subplot(2,1,2)
plot(time,'o')
title('b) Algorithm Run-Time', 'FontSize', 24)
xlabel('Grid Size Exponent (f)', 'FontSize', 20)
ylabel('Time (seconds)', 'FontSize', 20)

%{
timeLabels = 8:12
figure;
plot(timeLabels, time(8:end),'o')
title('Algorithm Run-Time for Large f', 'FontSize', 24)
xlabel('Grid Size Exponent (f)', 'FontSize', 20)
ylabel('Time (seconds)', 'FontSize', 20)
%}
