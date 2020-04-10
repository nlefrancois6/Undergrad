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
[i,j]=meshgrid(1:NP+1,1:NP+1);
sig = 10^(1.5);
gauss = @(x, y, sig) exp(-(x.^2 + y.^2)./(sig.^2)); % gaussian centered at 0
w = gauss(mod(i, NP)-30, mod(j, NP)-30, sig);
%}

w = zeros(xLen, yLen);

for i=1:xLen
    for j=1:yLen
        w(i,j) = sin(1*pi/LX.*sxp(i)).*sin(1*pi/LY.*syp(j));%+ 0.1*randn(size(rho(:,1)));
    end
end


%Plot ICs
subplot(3,1,1);
imagesc(w);
%plot(sxp,w(:,1))

%% Solve & Plot Streamfunction solution
Psi = FFT_MethodWtoPsi(w, NP, dx);
%[Psi] = FFT_pseudospectral_MethodWtoPsi(w, NP);
subplot(3,1,2);
imagesc(abs(Psi));

%Recover the original w by reversing the FFT method, compare to original w
wRecovered = FFT_MethodPsitoW(Psi, NP, dx, xLen, yLen);
subplot(3,1,3);
imagesc(real(wRecovered));
%plot(sxp,wRecovered(:,1))
