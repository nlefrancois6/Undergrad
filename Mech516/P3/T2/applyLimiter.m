function [dU] = applyLimiter(lim, Ui, Uip1, Uim1)
%Minmod slope limiter

dUiph = Uip1 - Ui; %dU_i+1/2
dUimh = Ui - Uim1; %dU_i-1/2

if strcmp(lim,'none')
    dU = 0.5*(dUiph+dUimh);
elseif strcmp(lim,'zero')
    dU = Ui*0;
elseif strcmp(lim,'minmod')
    dU = 0.5*(sign(dUiph)+sign(dUimh)).*min(abs(dUiph),abs(dUimh));
elseif strcmp(lim,'superbee')
    dU = 0.5*(sign(dUiph)+sign(dUimh)).*max(min(2*abs(dUimh),abs(dUiph)),min(abs(dUimh),2*abs(dUiph)));
elseif strcmp(lim,'vanleer_smooth')
    dU = 0.5*(sign(dUiph)+sign(dUimh)).*((2*abs(dUimh))/(abs(dUiph)+abs(dUimh))).*abs(dUiph);
elseif strcmp(lim,'vanleer_nonsmooth')
    dU = 0.5*(sign(dUiph)+sign(dUimh)).*min(min(2*abs(dUiph),2*abs(dUimh)),0.5*abs(dUiph+dUimh));
end

end

