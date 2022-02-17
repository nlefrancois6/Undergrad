function [fK] = fK_eval(ps, W, gamma, c)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

rhoK = W(1); uK = W(2); pK = W(3); %Unpack ICs

if ps > pK %Shock
    fK = (ps-pK)*((2/((gamma+1)*rhoK))/(ps+((gamma-1)/(gamma+1))*pK))^(0.5);
else %Rarefaction
    fK = ((2*c)/(gamma-1))*((ps/pK)^((gamma-1)/(2*gamma))-1);
end

end

