close all
%% Set up the domain and x&y nodes
LX = 1;
LY = 1;

%% Def rho ICs
w_func = @(x,y) sin(2*pi/LX.*x).*sin(2*pi/LY.*y);

time = zeros(1,9);
for f=1:9
    NP = 2.^f;
    dx = LX/NP;
    xLen = LX*NP+1; yLen = LY*NP+1;
    sxp = linspace(0, LX, xLen); syp = linspace(0, LY, yLen);


    [X,Y]=meshgrid(sxp,syp);
    w = w_func(X,Y);

    %% Solve & Time
    tic;
    Psi = FFT_MethodWtoPsi(w, NP, dx);
    time(f) = toc;
end

figure;
plot(time,'o')
title('Algorithm Run-Time', 'FontSize', 24)
xlabel('Grid Size Exponent (f)', 'FontSize', 20)
ylabel('Time (seconds)', 'FontSize', 20)
