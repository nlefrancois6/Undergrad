To = 5; tf = 18*1e2; A = 430; V = 750; rho = 1005; c = 4700; k = 4;
L = 0.01*V/A; %Convert length from cm to m
%Specify conditions for AC or no AC
AC = false;
if AC 
    Te = 13; h = 20;   
else
    Te = 30; h = 1;
end
Bi = Biot(L,h,k) %Check validity of LTC
%Lumped Thermal Capacity model
tau = rho*L*c/(h)
T = @(t_step,Tw) (Tw-Te)*exp(-t_step/tau) + Te;
Tw = T(tf,To)
%{
t_step = 1;
ts = 0:t_step:tf;
Tw = To;
for i=1:length(ts)
    Tw = T(t_step,Tw);
end
disp(Tw)
%}


