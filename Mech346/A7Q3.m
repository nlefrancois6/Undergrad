L = 0.085; Ti = 793; Ue = 10; Te = 293;

c = 0.246; m = 0.588;
kc = 1.062; rhoc = 2000; cpc = 1000;
kg = 0.025; rhog = 1; cpg = 1000; mug = 2*1e-5;

Re = 42500; Pr = 0.8;
h = kg*c*Re^m*Pr^(1/3)/L;

%alpha = 5.31*1e-7; tau = 0.208;
%t = tau*L^2/alpha;
lmb = 1.19; A = 1.21;
tau = log((1-0.4)*lmb/(A*sin(lmb)))/lmb^2;
t = tau*L^2/alpha