function [dfK] = dfK_eval(ps, W, gamma, c)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

rhoK = W(1); uK = W(2); pK = W(3); %Unpack ICs

if ps > pK %Shock
    dfK = ((2/((gamma+1)*rhoK))/(ps+((gamma-1)/(gamma+1))*pK))^(0.5)*(1-(ps-pK)/(2*(ps+((gamma-1)/(gamma+1))*pK)));
else %Rarefaction
    dfK = (1/(rhoK*c))*(ps/pK)^(-(gamma+1)/(2*gamma));
end

end

