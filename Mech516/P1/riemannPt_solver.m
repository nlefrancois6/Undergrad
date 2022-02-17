function [W] = riemannPt_solver(S, ps, us, WL, WR, gamma, c)
%Follow flow chart to determine situation and evaluate W in that situation
%   Detailed explanation goes here

%Unpack ICs
rhoL = WL(1); uL = WL(2); pL = WL(3);
rhoR = WR(1); uR = WR(2); pR = WR(3);

if S < us %we are to the left of CS
    if ps > pL %left shock
        %Calculate SL
        SL = uL - c*(((gamma-1)/(2*gamma))*(ps/pL) + (gamma-1)/(2*gamma))^(1/2);
        if S<SL %shock has not yet arrived
            W = WL;
        else %shock has arrived
            rhosL = rhoL*(((ps/pL) + (gamma-1)/(gamma+1))/(((gamma-1)/(gamma+1))*(ps/pL) + 1));
            usL = us;
            psL = ps;
            WsL = [rhosL usL psL]; 
            W = WsL;
        end
    else %left fan
        cs = c*(ps/pL)^((gamma-1)/(2*gamma));
        SHL = uL - c;
        STL = us - cs;
        if S<SHL %fan has not yet arrived
            W = WL;
        elseif S>STL %fan has passed
            rhosL = rhoL*(ps/pL)^(1/gamma);
            usL = us;
            psL = ps;
            WsL = [rhosL usL psL];
            W = WsL;
        else %inside of fan
            rhofL = rhoL*((2/(gamma+1)) + ((gamma-1)/(gamma+1))*(uL-S)/c)^(2/(gamma-1));
            ufL = (2/(gamma+1))*(c + ((gamma-1)/2)*uL + S);
            pfL = pL*((2/(gamma+1)) + ((gamma-1)/(gamma+1))*(uL-S)/c)^(2*gamma/(gamma-1));
            WfanL = [rhofL ufL pfL];
            W = WfanL;
        end
    end
else %we are to the right of CS
    if ps > pR %right shock
        %Calculate SR
        SR = uR + c*(((gamma-1)/(2*gamma))*(ps/pR) + (gamma-1)/(2*gamma))^(1/2);
        if S>SR %shock has not yet arrived
            W = WR;
        else %shock has arrived
            rhosR = rhoR*(((ps/pR) + (gamma-1)/(gamma+1))/(((gamma-1)/(gamma+1))*(ps/pR) + 1));
            usR = us;
            psR = ps;
            WsR = [rhosR usR psR]; 
            W = WsR;
        end
    else %right fan
        cs = c*(ps/pR)^((gamma-1)/(2*gamma));
        SHR = uR + c;
        STR = us + cs;
        if S>SHR %fan has not yet arrived
            W = WR;
        elseif S<STR %fan has passed
            rhosR = rhoR*(ps/pR)^(1/gamma);
            usR = us;
            psR = ps;
            WsR = [rhosR usR psR];
            W = WsR;
        else %inside of fan
            rhofR = rhoR*((2/(gamma+1)) - ((gamma-1)/(gamma+1))*(uR-S)/c)^(2/(gamma-1));
            ufR = (2/(gamma+1))*(-c + ((gamma-1)/2)*uR + S);
            pfR = pR*((2/(gamma+1)) - ((gamma-1)/(gamma+1))*(uR-S)/c)^(2*gamma/(gamma-1));
            WfanR = [rhofR ufR pfR];
            W = WfanR;
        end
    end
end
    
end

