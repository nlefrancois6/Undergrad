function [ug] = FTCSSolver(NP, dx, dt, xg, uE, Tf, plotSw)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    t = 0;
    R = (dt./dx.^2);

    %ug = u0(xg)
    ug = uE(xg, 0);

    while t<Tf
        %FTCS Scheme
        ug(1) = R*(ug(2)-2*ug(1)+ug(NP))+dt*(cos(t)+cos(0)*(cos(t)+4*sin(t))) + ug(1);
        for i=2:NP
            ug(i) = R*(ug(i+1)-2*ug(i)+ug(i-1))+dt*(cos(t)+cos(2*dx*(i-1))*(cos(t)+4*sin(t))) + ug(i);    
        end
        %ug(NP+1) = R*(ug(1)-ug(NP+1)) + ug(NP+1);
        ug(NP+1) = ug(1);
    
        t = t + dt; 
        
        if(plotSw == true)
            newplot

            plot(xg, ug, 'b');
            hold on
            plot(xg, uE(xg, t), 'r');
            hold off
    
            drawnow
        end
    end
end



