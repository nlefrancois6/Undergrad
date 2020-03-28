function [ug, xg] = LFSolverGood(LX,NP,u0,dt,dx,Tf)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
pausetime = 0.1;
xg = linspace(0,LX,NP);

ug = zeros(1,NP);
for i = 1 : NP
    ug(i) = u0(xg(i));  % Defines the initial conditions
end

%% Solver
t = 0;

%Need R<=1 for stability
R = dt/dx;

while t < Tf  % Halts program when inequality is violated
    % Applies periodic boundary conditions depending on choice
    
    boundary1 = ug(NP);
    boundary2 = ug(1);
    ug = [boundary1 ug boundary2];

    t = t + dt;   % Adds time step to time 
    
    
    for j = 2 : NP + 1
        u(j) = (ug(j+1)+ug(j-1))/2 - R*(ug(j+1)-ug(j-1)); 
    end
%{
        plot(xg,u(2:NP+1),'b')    % Plots pollutant (dependent variable)
        xlabel('x [m]')         % Adds appropiate labels
        ylabel('U [m]')
    
    % Adds title depending on scheme choice
    

    title('Solves 1D Advection Equation using Lax-Friedrichs Scheme','Fontsize',10)

    
    axis([0 LX min(u) 1.1*max(u)])  % Sets axis 
    pause(pausetime)   % Shows results for each timestep
%}   
    ug = u(2:NP+1);   % Ommits boundary conditions ready for the next time step
  
end
end

