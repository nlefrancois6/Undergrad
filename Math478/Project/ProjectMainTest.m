close all
%% Set up the domain and x&y nodes
LX = 1;
LY = 1;

NP = 64;
dx = LX/NP;
xLen = LX*NP+1; yLen = LY*NP+1;
sxp = linspace(0, LX, xLen); syp = linspace(0, LY, yLen);

%% Def rho ICs
%{
w = zeros(xLen, yLen);

for i=1:xLen
    for j=1:yLen
        w(i,j) = sin(1*pi/LX.*sxp(i)).*sin(1*pi/LY.*syp(j));%+ 0.1*randn(size(rho(:,1)));
        %w(i,j) = cos(2*pi/LX.*sxp(i)).*cos(2*pi/LY.*syp(j));
    end
end
%}
[i,j]=meshgrid(1:NP+1,1:NP+1);
sig = 10^(1.5);
gauss = @(x, y, sig) exp(-(x.^2 + y.^2)./(sig.^2)); % gaussian centered at 0
w = gauss(mod(i, NP)-30, mod(j, NP)-30, sig);


%Plot ICs
subplot(1,1,1);
imagesc(w);

%% Solve Poisson Equation for Psi
%Currently using FFT method, will eventually test with CR method and FACR
%method
Psi = FFT_MethodWtoPsi(w, NP, dx);

figure;
imagesc(Psi)

%[u, v] = PsiToVelocity(Psi, NP, dx, xLen, yLen);

%w = advectW(u, v, w, NP, dx, xLen, yLen);





