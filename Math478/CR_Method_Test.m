clear all
close all
%% Set up the domain and x&y nodes
LX = 1;
LY = 1;

f=5;
NP = 2^f+1;
dx = LX/NP;
xLen = LX*NP; yLen = LY*NP;
sxp = linspace(0, LX, xLen); syp = linspace(0, LY, yLen);

%% Def Source Term ICs


g0 = zeros(xLen, yLen);

for i=1:xLen
    for j=1:yLen
        g0(i,j) = sin(1*pi/LX.*sxp(i)).*sin(1*pi/LY.*syp(j));%+ 0.1*randn(size(rho(:,1)));
    end
end
g = fft(g0, xLen, 2);

%{
[i,j]=meshgrid(1:NP,1:NP);
sig = 10^(0.25);
gauss = @(x, y, sig) exp(-(x.^2 + y.^2)./(sig.^2)); % gaussian centered at 0
g = gauss(mod(i, NP)-5, mod(j, NP)-5, sig);
%}

%Plot ICs
subplot(2,1,1);
%figure;
imagesc(g0);
%surf(g0);


%Neumann BCs for u
%1 & -1 for testing but final test should use u=0 BC
u = zeros(xLen, yLen);
u0 = -ones(1,yLen); uN = ones(1,yLen);
u(1,:) = fft(u0); u(end,:) = fft(uN);


%% Compute T
%Compute B via x-differencing
BMat = getBMatrix(NP,LX);

TMat = BMat - 2*ones(NP,NP);

%% Compute T_n's and g_n's for all n=1:f levels
T_ni=zeros(xLen, xLen, f);
g_ni=zeros(xLen, yLen, f);

T_ni(:,:, 1) = TMat;
g_ni(:, :, 1) = g;

for n=2:f
    [T_ni(:,:,n), g_ni(:, :, n)] = Tg_next(T_ni(:,:,n-1), g_ni(:,:, n-1), NP, dx);
end

%Display the position, upper BC, and lower BC for each level in our CR
printIndexTest=false;
%Apply CR to solve for u at each level
u = CR_SolveLevels(g_ni, T_ni, u, f, dx, yLen, printIndexTest);
u = ifft(u, xLen, 2, 'symmetric');


%Plot result
subplot(2,1,2);
%figure;
imagesc(u)
%surf(u);

