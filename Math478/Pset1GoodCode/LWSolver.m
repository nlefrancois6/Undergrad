function [ug] = LWSolver(NP, dx, dt, xg, u0, uE, Tf, draw)
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
    %Lax-Wendroff time-step on periodic domain
    ug(1) = ug(1) - 0.5*R*(ug(2)-ug(NP)) + 0.5*R^2*(ug(2)-2*ug(1)+ug(NP)); 
    for i=2:NP
        ug(i) = ug(i) - 0.5*R*(ug(i+1)-ug(i-1)) + 0.5*R^2*(ug(i+1)-2*ug(i)+ug(i-1));   
    end 
    ug(NP+1) = ug(1); 
    
    t = t + dt; 
    
    if draw == true

        plot(xg, ug, 'k');
        %hold on
        %plot(xg, uE(xg, t), 'r');
        %hold off
    
        drawnow
    end
end
end

