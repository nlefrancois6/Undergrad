function [FRL, FRR] = MUSCLHsolver(lim, W, gamma, dt, dx, N)
%UNTITLED21 Summary of this function goes here
%   Detailed explanation goes here

%% Get predictor step U for each cell
Upreds = zeros(3,N); %initialize storage

%Left boundary
im1 = 1; i=1; ip1 = i+1; %get adjacent cell indices
Upreds(:,i) = MUSCLH_pred(lim, W, im1, i, ip1, gamma, dt, dx); %calculate and store U_pred

for i=2:N-1
    im1 = i-1; ip1 = i+1; %get adjacent cell indices
    Upreds(:,i) = MUSCLH_pred(lim, W, im1, i, ip1, gamma, dt, dx); %calculate and store U_pred
end

%Right boundary
im1 = N-1; i=N; ip1 = N; %get adjacent cell indices
Upreds(:,i) = MUSCLH_pred(lim, W, im1, i, ip1, gamma, dt, dx); %calculate and store U_pred

Wpreds = UtoW(Upreds,gamma); %convert U to W

%% Get corrector step fluxes for each cell

FRL = zeros(3,N); FRR = zeros(3,N); %Initialize storage

%Left boundary
im2 = 1; im1 = 1; i=1; ip1 = i+1; ip2 = i+2; %get adjacent cell indices
[FRL(:,i), FRR(:,i)] = MUSCLH_corr(lim, W, Wpreds, im2, im1, i, ip1, ip2, gamma); %calculate and store U_pred

im2 = 1; im1 = 1; i=2; ip1 = i+1; ip2 = i+2; %get adjacent cell indices
[FRL(:,i), FRR(:,i)] = MUSCLH_corr(lim, W, Wpreds, im2, im1, i, ip1, ip2, gamma); %calculate and store U_pred

for i=3:N-2
    im2 = i-2; im1 = i-1; ip1 = i+1; ip2 = i+2; %get adjacent cell indices
    [FRL(:,i), FRR(:,i)] = MUSCLH_corr(lim, W, Wpreds, im2, im1, i, ip1, ip2, gamma); %calculate and store U_pred
end

%Right boundary
im2 = N-3; im1 = N-2; i=N-1; ip1 = N; ip2=N; %get adjacent cell indices
[FRL(:,i), FRR(:,i)] = MUSCLH_corr(lim, W, Wpreds, im2, im1, i, ip1, ip2, gamma); %calculate and store U_pre

im2 = N-2; im1 = N-1; i=N; ip1 = N; ip2=N; %get adjacent cell indices
[FRL(:,i), FRR(:,i)] = MUSCLH_corr(lim, W, Wpreds, im2, im1, i, ip1, ip2, gamma); %calculate and store U_pred

end

