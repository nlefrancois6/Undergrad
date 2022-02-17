function [ps, us] = CS_solver(WL, WR, gamma, c)
%Evaluate pressure and velocity on contact surface using implicit method given ICs
%   Detailed explanation goes here

%Unpack ICs
rhoL = WL(1); uL = WL(2); pL = WL(3);
rhoR = WR(1); uR = WR(2); pR = WR(3);

%Initial guess using acoustic approx
%Currently assuming cL=cR=c since no instruction was given
ps_guess = (pL*rhoR*c + pR*rhoL*c + (uL-uR)*rhoL*c*rhoR*c)/(rhoL*c + rhoR*c);

%Solve for ps
f_func = @(p) fK_eval(p, WL, gamma, c) + fK_eval(p, WR, gamma, c) + (uR-uL); %function of p which we want the root of 
options = optimset('Display','off'); %Suppress text output of solution
ps = fsolve(f_func, ps_guess, options); %Find the p value that solves f_func = 0

%{
%Seems like I get garbage out of this and I don't think its worth debugging
since I get a reasonable result just using fsolve

%Iterate until we meet convergence tolerance
conv_crit = inf; count = 0;
while conv_crit > tol
    %Evaluate f(ps, WL, WR) and df(ps, WL, WR)
    f_guess = fK_eval(ps_guess, WL, gamma, c) + fK_eval(ps_guess, WR, gamma, c) + (uR - uL);
    df_guess = dfK_eval(ps_guess, WL, gamma, c) +  dfK_eval(ps_guess, WR, gamma, c);
    %Update pressure
    ps_update = ps_guess - f_guess/df_guess;
    %Check convergence criterion
    conv_crit = abs(ps_update - ps_guess)/ps_guess; %Should probably check to make sure i don't get negative pressure
    %Update guess for next step
    ps_guess = ps_update;
    count = count + 1; %Update iteration count
    
end
    
%Converged value of ps
ps = ps_update;

disp(count)
%}

%Calculate us using converged ps
us = 0.5*(uL+uR) + 0.5*(fK_eval(ps, WR, gamma, c) - fK_eval(ps, WL, gamma, c));

end

