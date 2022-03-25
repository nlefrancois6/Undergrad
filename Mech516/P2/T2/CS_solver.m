function [ps, us] = CS_solver(WL, WR, gamma)
%Evaluate pressure and velocity on contact surface using implicit method given ICs
%{
Inputs:
    WL, WR: initial conditions on left and right side of discontinuity(rho, u, p)
    gamma: specific heat ratio. Currently assuming gammaL=gammaR
Output:
    ps, us: pressure and velocity of contact surface
%}

%Unpack ICs
rhoL = WL(1); uL = WL(2); pL = WL(3);
rhoR = WR(1); uR = WR(2); pR = WR(3);
%Calculate speed of sound on both sides
cL = sqrt(gamma*pL/rhoL);
cR = sqrt(gamma*pR/rhoR);

%Initial guess using acoustic approx
ps_guess = (pL*rhoR*cR + pR*rhoL*cL + (uL-uR)*rhoL*cL*rhoR*cR)/(rhoL*cL + rhoR*cR);

%Solve for ps
f_func = @(p) fK_eval(p, WL, gamma, cL) + fK_eval(p, WR, gamma, cR) + (uR-uL); %function of p which we want the root of 
options = optimset('Display','off'); %Suppress text output of solution
ps = fsolve(f_func, ps_guess, options); %Find the p value that solves f_func = 0

%Calculate us using converged value of ps
us = 0.5*(uL+uR) + 0.5*(fK_eval(ps, WR, gamma, cR) - fK_eval(ps, WL, gamma, cL));

end

