close all
%% Set up the domain and x&y nodes
LX = 1;
LY = 1;


NP = 64;
dx = LX/NP;
xLen = LX*NP+1; yLen = LY*NP+1;
sxp = linspace(0, LX, xLen); syp = linspace(0, LY, yLen);

%% Def rho ICs

w_func = @(x,y) sin(2*pi/LX.*x).*sin(2*pi/LY.*y);

[X,Y]=meshgrid(sxp,syp);
w = w_func(X,Y);


%Plot ICs
subplot(2,1,1);
surf(w);

%% Solve & Plot Streamfunction solution
tic;
Psi = FFT_MethodWtoPsi(w, NP, dx);
toc;
subplot(2,1,2);
surf(Psi);

%{
%Recover the original w by reversing the FFT method, compare to original w
wRecovered = FFT_MethodPsitoW(Psi, NP, dx, xLen, yLen);
subplot(3,1,3);
imagesc(real(wRecovered));
%}
