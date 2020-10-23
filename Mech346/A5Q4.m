k = 15.1; rho = 8055; c = 480;
alpha = k/(rho*c);

H = 0.1; W = 0.02; xp = 0; yp = 0; zp = 0.01;
Lx = W/2; Ly = W/2; Lz = H/2;

t = 100;
tauX = alpha*t/(Lx^2); tauY = alpha*t/(Ly^2); tauZ = alpha*t/(Lz^2);

%Expressions for lambda and A in the series expansion
lambdan = @(n) (n-1)*pi + pi/2;
An = @(n) 4*sin(lambdan(n))/(2*lambdan(n)+sin(2*lambdan(n)));

theta1D = @(r,A,lambda,tau,L) A*exp(-lambda^2*tau)*cos(lambda*r/L);

%Calculate the series for theta in each direction up to nterms
nterms = 5;
theta_n = zeros(nterms,3);
for i=1:nterms
    lambda_n = lambdan(i);
    A_n = An(i);
    theta_n(i,1) = theta1D(xp,A_n,lambda_n,tauX,Lx);
    theta_n(i,2) = theta1D(yp,A_n,lambda_n,tauY,Ly);
    theta_n(i,3) = theta1D(zp,A_n,lambda_n,tauZ,Lz);
end
%Evaluate the 3D transient theta 
theta = sum(theta_n(:,1))*sum(theta_n(:,2))*sum(theta_n(:,3))
