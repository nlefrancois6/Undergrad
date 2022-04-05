function [Wp] = EulerSolver(solver, Wp, Up, gamma, N, T, dt, dx, wall, lim)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%sampling point(s)
x = 0; t = 0; %coordinates
x0 = 0; t0 = 0; %offsets
xi = 0; %position for exact riemann solver

Fs = zeros(3,N,2); %z=1 for FRL, z=2 for FRR
ti = 0;
while ti<T
    
    if strcmp(solver,'richtmyer')
        %Get fluxes for each cell
        im1 = [1 1:N-1]; i=1:N; ip1 = [2:N N];
        Wim1 = Wp(:,im1); Wi = Wp(:,i); Wip1 = Wp(:,ip1); %get W_(i-1), W_i, W_(i+1)
        
        FRL = richtmyerSolver(Wim1,Wi,gamma, dt, dx); %flux at left interface
        FRR = richtmyerSolver(Wi,Wip1,gamma, dt, dx); %flux at right interface
        Fs(:,:,1) = FRL; Fs(:,:,2) = FRR; %store fluxes at interfaces
    elseif strcmp(solver,'MH')
        [FRL, FRR] = MUSCLHsolver(lim, Wp, wall, gamma, dt, dx, N); %calculate flux at interfaces
        Fs(:,:,1) = FRL; Fs(:,:,2) = FRR; %store fluxes at interfaces
    else
        %Get fluxes for each cell
        %Left boundary
        im1 = 1; i=1; ip1 = 2; %get adjacent cell indices
        [FRL,FRR] = getFluxes(solver, im1, i, ip1, Wp, t, t0, xi, x0, gamma, dt, dx); %get fluxes at interfaces
        Fs(:,i,1) = FRL; Fs(:,i,2) = FRR; %store fluxes at interfaces

        %Unvectorized
        for i=2:N-1
            im1 = i-1; ip1 = i+1; %get adjacent cell indices
            [FRL,FRR] = getFluxes(solver, im1, i, ip1, Wp, t, t0, xi, x0, gamma, dt, dx); %get fluxes at interfaces
            Fs(:,i,1) = FRL; Fs(:,i,2) = FRR; %store fluxes at interfaces
        end

        %Right boundary
        im1 = N-1; i=N; ip1 = N; %get adjacent cell indices
        [FRL,FRR] = getFluxes(solver, im1, i, ip1, Wp, t, t0, xi, x0, gamma, dt, dx); %get fluxes at interfaces
        Fs(:,i,1) = FRL; Fs(:,i,2) = FRR; %store fluxes at interfaces
    end
    
    %Update U for each cell
    Up = Up + (dt/dx).*(Fs(:,:,1) - Fs(:,:,2));
    %Update W
    Wp = UtoW(Up, gamma);
    
    %Increment ti
    ti = ti + dt;
end

m1 = ['T final:',num2str(T)];
%disp(m1)

end

