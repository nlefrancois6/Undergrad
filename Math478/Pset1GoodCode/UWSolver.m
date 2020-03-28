function [ug] = UWSolver(NP, dx, dt, xg, u0, uE, Tf, draw)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
t = 0;
%dt = 1/NP;

R = dt/dx;
if R > 0.9
    disp(R)
end

ug = u0(xg);

%figure;
while t<Tf
    %Upwind Time-step on periodic domain
    for i=1:NP
        ug(i) = R*(ug(i+1)-ug(i)) + ug(i);    
    end
    %ug(NP+1) = R*(ug(1)-ug(NP+1)) + ug(NP+1);
    ug(NP+1) = ug(1);
    
    t = t + dt; 
    
    if draw == true
        newplot
        
        plot(xg, ug, 'b');
        hold on
        plot(xg, uE(xg, t), 'r');
        hold off
    
        drawnow
    end
    
end
end

