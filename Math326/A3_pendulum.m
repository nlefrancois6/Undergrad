theta0 = pi/2; v0 = 1;
T = 10;
dt = 1e-3; nsteps = T/dt;
T_ticks = linspace(0,T,nsteps+1);

H = @(theta, v) v^2/2 - cos(theta);

%Initialize & store the variables
thetas = zeros(1,nsteps+1); vs = zeros(1,nsteps+1); Hs = zeros(1,nsteps+1);
theta = theta0; v = v0;
thetas(1) = theta; vs(1) = v;
Hs(1) = H(theta,v);

method = 'Method 2'
if strcmp(method,'Method 1')
    %Method 1
    for t=1:nsteps
        %Update the variables
        theta_next = theta + dt*v;
        v = v - dt*sin(theta);
        theta = theta_next;
        %Store the variables
        thetas(t+1) = theta; vs(t+1) = v;
        %Calculate & store the hamiltonian
        Hs(t+1) = H(theta,v);
    end
elseif strcmp(method,'Method 2')
    %Method 2
    for t=1:nsteps
        %Update the variables
        theta = theta + dt*v;
        v = v - dt*sin(theta);
        %Store the variables
        thetas(t+1) = theta; vs(t+1) = v;
        %Calculate & store the hamiltonian
        Hs(t+1) = H(theta,v);
    end
end

%Plot the results
subplot(1,2,1)
hold on;
plot(T_ticks, thetas)
xlabel('Time')
ylabel('Theta')
hold off;
subplot(1,2,2)
hold on;
plot(T_ticks, Hs)
xlabel('Time')
ylabel('Hamiltonian')
hold off;

