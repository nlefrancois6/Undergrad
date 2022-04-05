function [F] = richtmyerSolver(WL,WR,gamma, dt, dx)

UL = WtoU(WL, gamma); UR = WtoU(WR, gamma); %convert primitive vectors to U vectors
FL = WtoF(WL, gamma); FR = WtoF(WR, gamma); %convert primitive vectors to flux vectors

%Compute velocity at predictor step
U_pred = 0.5*(UR+UL) - (dt/(2*dx))*(FR-FL);
%Convert to flux for corrector step (performed in EulerSolver
W = UtoW(U_pred, gamma);
F = WtoF(W, gamma);

end