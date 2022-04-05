function [Upred] = MUSCLH_pred(lim, W, wall, im1, i, ip1, N, gamma, dt, dx)

%get W_(i-1), W_i, W_(i+1)
if wall
    if im1 == -1         
        Wim1 = [W(1,1); -W(2,1); W(3,1)]; %apply wall reflection
        Wi = W(:,i); Wip1 = W(:,ip1);
    elseif ip1 > N
        Wim1 = W(:,im1); Wi = W(:,i); 
        Wip1 = [W(1,N); -W(2,N); W(3,N)]; %apply wall reflection
    else
        Wim1 = W(:,im1); Wi = W(:,i); Wip1 = W(:,ip1);
    end
else
    Wim1 = W(:,im1); Wi = W(:,i); Wip1 = W(:,ip1);
end

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