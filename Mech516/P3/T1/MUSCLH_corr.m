function [FRL, FRR] = MUSCLH_corr(lim, W, Wpred, im2, im1, i, ip1, ip2, gamma)

%get W_(i-1), W_i, W_(i+1) for original W and W_pred
Wim2 = W(:,im2); Wim1 = W(:,im1); 
Wi = W(:,i); 
Wip1 = W(:,ip1); Wip2 = W(:,ip2);

WPim1 = Wpred(:,im1); 
WPi = Wpred(:,i); 
WPip1 = Wpred(:,ip1);
    
%Get dW
dWim1 = applyLimiter(lim,Wim1,Wi,Wim2);
dWi = applyLimiter(lim,Wi,Wip1,Wim1);
dWip1 = applyLimiter(lim,Wip1,Wip2,Wi);

%Get W_i+1/2^L, W_i+1/2^R
WLiph = 0.5*(Wi+WPi) + 0.5*dWi;
WRiph = 0.5*(Wip1+WPip1) - 0.5*dWip1;

%Get W_i-1/2^L, W_i-1/2^R
WLimh = 0.5*(Wim1+WPim1) + 0.5*dWim1;
WRimh = 0.5*(Wi+WPi) - 0.5*dWi;

%sampling point for Riemann solver
xi = 0; t = 0; %coordinates
x0 = 0; t0 = 0; %offsets

%Solve Riemann problem to get W_RS_iph, W_RS_imh
WRL = riemannSolver(t,t0,xi,x0,WLimh,WRimh,gamma);
WRR = riemannSolver(t,t0,xi,x0,WLiph,WRiph,gamma);

%Convert W to F
FRL = WtoF(WRL,gamma); FRR = WtoF(WRR,gamma);

end