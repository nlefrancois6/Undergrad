function [Upred] = MUSCLH_pred(lim, W, im1, i, ip1, gamma, dt, dx)

%get W_(i-1), W_i, W_(i+1)
Wim1 = W(:,im1); Wi = W(:,i); Wip1 = W(:,ip1);

%convert W to U
Ui = WtoU(Wi,gamma);

%Get dW
dW = applyLimiter(lim,Wi,Wip1,Wim1);

%Get W_i+1/2^L, W_i-1/2^R
WLiph = Wi + 0.5*dW;
WRimh = Wi - 0.5*dW;

%Convert W to F
FLiph = WtoF(WLiph,gamma); FRimh = WtoF(WRimh,gamma);

%Get Upred
Upred = Ui - (dt/dx)*(FLiph-FRimh);

end