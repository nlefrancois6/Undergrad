function [FRL,FRR] = getFluxes(solver, im1, i, ip1, Wp, t, t0, xi, x0, gamma,dt,dx)
%UNTITLED27 Summary of this function goes here
%   Detailed explanation goes here
Wim1 = Wp(:,im1); Wi = Wp(:,i); Wip1 = Wp(:,ip1); %get W_(i-1), W_i, W_(i+1)
if strcmp(solver, 'godunov')
    %evaluate solver at each interface
    WRL = riemannSolver(t,t0,xi,x0,Wim1,Wi,gamma); %Riemann sol on left interface
    WRR = riemannSolver(t,t0,xi,x0,Wi,Wip1,gamma); %Riemann sol on right interface
    %Convert primitive vectors to flux vectors
    FRL = WtoF(WRL, gamma); FRR = WtoF(WRR, gamma);
elseif strcmp(solver, 'roe')
    %evaluate solver at each interface
    FRL = roeSolver(Wim1,Wi,gamma); %Roe sol on left interface
    FRR = roeSolver(Wi,Wip1,gamma); %Roe sol on right interface
elseif strcmp(solver, 'richtmyer')
    %evaluate solver at each interface
    FRL = richtmyerSolver(Wim1,Wi,gamma,dt,dx); %Richt sol on left interface
    FRR = richtmyerSolver(Wi,Wip1,gamma,dt,dx); %Richt sol on right interface
%elseif strcmp(solver, 'MH')
    %evaluate solver at each interface
    %Upred = MUSCLH_pred(Wim1,Wi,Wip1,gamma,dt,dx); %MUSCLH fluxes
end