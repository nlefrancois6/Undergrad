function [fK] = fK_eval(ps, W, gamma, c)
%Evaluate f_K(p) for use in implicit contact surface pressure solver. K = Left or Right
%{
Inputs:
    ps: guess for contact surface pressure
    W: initial conditions on side K of discontinuity(rhoK, uK, pK)
    gamma: specific heat ratio on side K of discontinuity
    c: speed of sound on side K of discontinuity
Output:
    ps, us: pressure and velocity of contact surface
%}

rhoK = W(1); uK = W(2); pK = W(3); %Unpack ICs

%Check situation and evaluate fK for either a shock or rarefaction case
if ps > pK %Shock
    fK = (ps-pK)*((2/((gamma+1)*rhoK))/(ps+((gamma-1)/(gamma+1))*pK))^(0.5);
else %Rarefaction
    fK = ((2*c)/(gamma-1))*((ps/pK)^((gamma-1)/(2*gamma))-1);
end

end

