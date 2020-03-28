function [ug] = A2Q2scheme2Solver(NP, dx, dt, xg, uE, Tf, draw)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
t = 0;
%dt = 1/NP;

R = dt/(dx^2);
if R > 0.9
    disp(R)
end

ug = uE(xg,0);

%figure;
while t<Tf
    %Question 2 Scheme
    ug(1) = R*((-1/12)*ug(3)+(4/3)*ug(2)-(5/2)*ug(1)+(4/3)*ug(NP)+(-1/12)*ug(NP-1))+dt*(cos(t)+cos(0)*(cos(t)+4*sin(t))) + ug(1);
    ug(2) = R*((-1/12)*ug(4)+(4/3)*ug(3)-(5/2)*ug(2)+(4/3)*ug(1)+(-1/12)*ug(NP))+dt*(cos(t)+cos(2*dx*1)*(cos(t)+4*sin(t))) + ug(2);
    for i=3:NP-1
        ug(i) = R*((-1/12)*ug(i+2)+(4/3)*ug(i+1)-(5/2)*ug(i)+(4/3)*ug(i-1)+(-1/12)*ug(i-2))+dt*(cos(t)+cos(2*dx*(i-1))*(cos(t)+4*sin(t))) + ug(i);    
    end
    %ug(NP+1) = R*(ug(1)-ug(NP+1)) + ug(NP+1);
    ug(NP) = R*((-1/12)*ug(2)+(4/3)*ug(1)-(5/2)*ug(NP)+(4/3)*ug(NP-1)+(-1/12)*ug(NP-2))+dt*(cos(t)+cos(2*dx*(NP-1))*(cos(t)+4*sin(t))) + ug(NP);
    ug(NP+1) = ug(1);
    
    t = t + dt; 
    
    if draw == true

        plot(xg, ug, 'b');
        hold on
        plot(xg, uE(xg, t), 'r');
        hold off
    
        drawnow
    end
end
end

