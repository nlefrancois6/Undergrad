function [u, maxErr] = FACR_Solver(xLen, yLen, NP, LX, dx, f, g0, g, u_exact, plotResults)
%Use the Fourier Analysis and Cyclic Reduction method to solve a 2D Poisson equation
%with Neumann boundary conditions on the top and bottom, periodic
%conditions at left and right boundaries.
%Laplace(u) = g

%Neumann BCs for u
u = zeros(xLen, yLen);
u0 = -0*ones(1,yLen); uN = 0*ones(1,yLen);
u(1,:) = fft(u0); u(end,:) = fft(uN);


%% Compute T
%Compute B via x-differencing (Using Fourier Analysis method)
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

%Calculate maximum error and report if there are any NAN (seems to occur if f>=10)
maxErr = max(abs(u(:)-u_exact(:)));
if any(isnan(u(:)))
    disp('NAN ERROR')
end

if plotResults
    plotSolutions(g0, u_exact, u);
end

end

