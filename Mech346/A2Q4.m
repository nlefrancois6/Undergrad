Ti = 400; Te = 300; sig = 5.67*1e-8; ri = 0.0005; k = 0.1;
eps = 0.5;

%Equation for Q/L==q as a function of r0, T0
q_est = @(r0, T0) 2.*pi.*r0.*(sig.*eps.*(T0.^4-Te^4) + 1.1.*(T0-Te)./(sqrt(2).*sqrt(r0)));
%Equation for T0 as a function of r0, q
T0_est = @(r0, q_guess) Ti - q_guess.*log(r0/ri)/(2*pi*k);

%Define a linspace of r0 sizes to try and store T0 values
np = 100; rp = linspace(1e-4, 2.99*1e-3, np); T0_values = [];

%Stop the loop if it exceeds nmax iterations
nmax = 1e2; count = 0;
%Stop iteration if dT0 falls below tolerance. Initial guess of T0=350
dT0 = 1000; tol = 1; T0_guessPrev = 350;

while (max(dT0) > tol)&&(count < nmax + 1)
    %Compute the next guess
    q_guess = q_est(rp, T0_guessPrev);
    T0_guess = T0_est(rp, q_guess);
    %Compute the change in T0 for this iteration
    dT0 = abs(T0_guess-T0_guessPrev);
    %Store the T0 value and update the count
    T0_values = [T0_values; T0_guess];
    T0_guessPrev = T0_guess;
    count = count + 1;
end

[q_max, r0_maxInd] = max(q_guess)
r0_max = rp(r0_maxInd)
T0_max = T0_est(r0_max, q_max)


figure;
plot(T0_values(:,1))
hold on;
title('T0 Convergence')
xlabel('Iterations')
ylabel('T0 (K)')
for x=2:np
    plot(T0_values(:,x))
end
hold off;

figure;
plot(rp, q_guess)
hold on;
title('Sheath Flux As a Function of Outer Radius')
xlabel('R0 (m)')
ylabel('Flux (W/m)')
hold off;


