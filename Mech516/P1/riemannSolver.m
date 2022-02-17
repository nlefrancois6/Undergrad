function [W] = riemannSolver(t,t0,x,x0,WL,WR,gamma,c)
%Evaluate solution of Riemann problem at position S=(x-x0)/(t-t0) given ICs
%   Currently assuming that gamma and c are constant on both sides

%Check&handle t<=0 case
if (t-t0)<=0
    if (x-x0)>0
        W = WR;
    else
        W = WL;
    end
else %if t>0, use Riemann solver to evaluate W(S)
    %Get self-similar sampling point value
    S = (x-x0)/(t-t0);
    
    %Solve for contact surface pressure and velocity
    [ps, us] = CS_solver(WL, WR, gamma, c);

    %Follow flow chart to determine situation and evaluate W in that situation
    [W] = riemannPt_solver(S, ps, us, WL, WR, gamma, c);
end  

end

