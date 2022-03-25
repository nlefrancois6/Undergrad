function [W] = riemannSolver(t,t0,x,x0,WL,WR,gamma)
%Evaluate solution of Riemann problem at position S=(x-x0)/(t-t0) given ICs
%{
Inputs:
    t, t0: sampling time and time offset of discontinuity
    x, x0: sampling position and position offset of discontinuity
    WL, WR: initial conditions on left and right side of discontinuity(rho, u, p)
    gamma: specific heat ratio. Currently assuming gammaL=gammaR
Output:
    W: solution vector at sampling point (rho, u , p)
%}


if ((t-t0)<=0) && ((x-x0)~=0) %Check&handle t<=0 case to avoid divide by zero
    if (x-x0)>0 %we are to the right of discontinuity
        W = WR;
    else
        W = WL; %we are to the right of discontinuity
    end
else %if t>0 or x=0, use Riemann solver to evaluate W(S)
    %Get self-similar sampling point value
    if (x-x0)==0
        S = 0;
    else
        S = (x-x0)/(t-t0);
    end
    
    %Solve for contact surface pressure and velocity
    [ps, us] = CS_solver(WL, WR, gamma);

    %Follow flow chart to determine situation and evaluate W in that situation
    [W] = riemannPt_solver(S, ps, us, WL, WR, gamma);
end  

end

