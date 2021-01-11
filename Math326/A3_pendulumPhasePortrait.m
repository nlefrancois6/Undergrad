f = @(t,theta, v) [v; -sin(theta)];

theta_range = linspace(-pi,3*pi,20);
v_range = linspace(-2,2,20);

% creates two matrices one for all the x-values on the grid, and one for
% all the y-values on the grid. Note that x and y are matrices of the same
% size and shape, in this case 20 rows and 20 columns
[x,y] = meshgrid(theta_range,v_range);
size(x)
size(y)

u = zeros(size(x));
v = zeros(size(x));
% we can use a single loop over each element to compute the derivatives at
% each point (y1, y2)
t=0; % we want the derivatives at each point at t=0, i.e. the starting time
for i = 1:numel(x)
    Yprime = f(t,x(i), y(i));
    u(i) = Yprime(1);
    v(i) = Yprime(2);
end

quiver(x,y,u,v,'r'); figure(gcf)
xlabel('Theta')
ylabel('Velocity')
axis tight equal;

T = 15;
hold on
for theta0 = 0
    for v0 = [0 0.5 1 1.5 1.9 1.99 2 2.01]
        %Replace with solver from [0,T] of our scheme
        %[ts,ys] = ode45(f,[0,50],[0,v0]); 
        [ts, ys] = my_Solver(T, theta0, v0);
        plot(ys(:,1),ys(:,2))
        plot(ys(1,1),ys(1,2),'bo') % starting point
        plot(ys(end,1),ys(end,2),'ks') % ending point
    end
end
for theta0 = 2*pi
    for v0 = [-2.01 -2 0 0.5 1 1.5 1.9 1.99]
        %Replace with solver from [0,T] of our scheme
        %[ts,ys] = ode45(f,[0,50],[0,v0]); 
        [ts, ys] = my_Solver(T, theta0, v0);
        plot(ys(:,1),ys(:,2))
        plot(ys(1,1),ys(1,2),'bo') % starting point
        plot(ys(end,1),ys(end,2),'ks') % ending point
    end
end
hold off

function [ts, ys] = my_Solver(T, theta0, v0)

dt = 1e-4; nsteps = T/dt;
ts = linspace(0,T,nsteps+1);

ys = zeros(nsteps+1,2);
theta = theta0; v = v0;
ys(1,1) = theta; ys(1,2) = v;

for t=1:nsteps
        %Update the variables
        theta = theta + dt*v;
        v = v - dt*sin(theta);
        %Store the variables
        ys(t+1,1) = theta; ys(t+1,2) = v;
end

end



