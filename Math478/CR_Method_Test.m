clear all
close all
%% Set up the domain and x&y nodes
LX = 1;
LY = 1;

f=3;
NP = 2^f+1;
xLen = LX*NP; yLen = LY*NP;
sxp = linspace(0, LX, xLen); syp = linspace(0, LY, yLen+1); syp(end) = [];
dx = sxp(2)-sxp(1);

plotResults = true;
%% Def Source Term ICs


g0 = zeros(xLen, yLen);
u_exact = zeros(xLen, yLen);

for i=1:xLen
    for j=1:yLen
        g0(i,j) = 1*sin(2*pi/LX.*sxp(i)).*sin(2*pi/LY.*syp(j));%+ 0.1*randn(size(rho(:,1)));
        u_exact(i,j) = -1*((2*pi/LX)^2+(2*pi/LY)^2)^(-1)*sin(2*pi/LX.*sxp(i)).*sin(2*pi/LY.*syp(j));
    end
end
g = fft(g0, size(g0,2), 2);

%{
[X,Y]=meshgrid(sxp,syp);
sig = 10^(0.25);
gauss = @(x, y, sig) exp(-(x.^2 + y.^2)./(sig.^2)); % gaussian centered at 0
g = gauss(mod(X, LX)-5, mod(Y, LX)-5, sig);
%}
if plotResults
    %Plot ICs
    subplot(3,1,1);
    %figure;
    %imagesc(g0);
    surf(g0);
    title('Source Term, g')
    xlabel('X');
    ylabel('Y');
end

%Neumann BCs for u
%1 & -1 for testing but final test should use u=0 BC
u = zeros(xLen, yLen);
u0 = -0*ones(1,yLen); uN = 0*ones(1,yLen);
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
u = ifft(u, size(u,2), 2, 'symmetric');

%u = u*(dx^2 + dx^2);
MaxErr = max(abs(u(:)-u_exact(:)))
if any(isnan(u(:)))
    disp('NAN ERROR')
end
if plotResults
    %Plot result
    subplot(3,1,2);
    %figure;
    %imagesc(u)
    surf(u);
    title('Numerical Solution to Laplace(u) = g, u')
    xlabel('X');
    ylabel('Y');
end
%{
subplot(3,1,3);
%figure;
%imagesc(u)
surf(u_exact);
title('Exact Solution to Laplace(u) = g, u')
xlabel('X');
ylabel('Y');
%}
if plotResults
    subplot(3,1,3);
    surf(u-u_exact);
    title('Error From Exact Solution to Laplace(u) = g, u')
    xlabel('X');
    ylabel('Y');
end

