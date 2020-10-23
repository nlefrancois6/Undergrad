H = 0.14; D = 0.25; k = 0.46; c = 2800; rho = 960;
h = 13.2;

%Part a)
L = H/2;
Bi = h*L/k;

%Part b)
alpha = k/(rho*c);
Ti = 25; Tc = 90; Ts = 140;
%Fo = alpha*t/L^2 %Check truncation validity once we have t

A1 = 1.18; lambda1 = 1.08;
T = @(x,t, Tinf) -A1.*(Ti-Tinf).*exp(-lambda1^2.*alpha.*t/L^2).*cos(lambda1.*x/L) + Tinf;
%theta = @(x,t) -A1.*exp(-lambda1^2.*alpha.*t/L^2).*cos(lambda1.*x/L);

T(0,0,30)