close all;
clear all;

draw = true;
pausetime = 0;
%% Setup domain
LX = 2*pi;
Tf = pi;

R = 0.1; c = 1;
NP = 512; dx = LX/NP;
dt = R*dx;

xg = linspace(0, LX, NP+1); %xg(end) = []; 
xg = xg(:);

xgLF = linspace(0,LX,NP);

%Exact solution
uE = @ (x, t) 1 + cos(4*(x+t));

%IC
u0 = @ (x) 1 + cos(4*x);


t=0;
while t<Tf
    ugUW = u0(xg);
    ugLW = u0(xg);
    ugLF = u0(xgLF);

%figure;
while t<Tf
    %Upwind Time-step on periodic domain
    for i=1:NP
        ugUW(i) = R*(ugUW(i+1)-ugUW(i)) + ugUW(i);    
    end
    ugUW(NP+1) = ugUW(1);
    
    %Lax-Wendroff time-step on periodic domain
    ugLW(1) = ugLW(1) - 0.5*R*(ugLW(2)-ugLW(NP)) + 0.5*R^2*(ugLW(2)-2*ugLW(1)+ugLW(NP)); 
    for i=2:NP
        ugLW(i) = ugLW(i) - 0.5*R*(ugLW(i+1)-ugLW(i-1)) + 0.5*R^2*(ugLW(i+1)-2*ugLW(i)+ugLW(i-1));   
    end 
    ugLW(NP+1) = ugLW(1); 
    
    %Lax-Friedrich time-step on periodic domain
    boundary1 = ugLF(NP);
    boundary2 = ugLF(1);
    ugLF = [boundary1 ugLF boundary2];

    t = t + dt;   % Adds time step to time 
    
    
    for j = 2 : NP + 1
        u(j) = (ugLF(j+1)+ugLF(j-1))/2 - R*(ugLF(j+1)-ugLF(j-1)); 
    end
    ugLF = u(2:NP+1);
    
    
    t = t + dt; 
    
    if draw == true
        newplot
        
        plot(xg, ugUW, 'b');
        hold on
        %plot(xg, ugLW, 'k');
        plot(xgLF, ugLF, 'c');
        plot(xg, uE(xg, t), 'r');
        hold off
        title(['t = ' num2str(t, '%10.3f')])
        legend({'Upwind','Lax-Friedrich','Exact'},'Location','south')
    
        drawnow
    end 
    pause(pausetime);
end
    
end

