%clear all;
%close all;
testCase = 'Uncovered'; %Can be 'Uncovered' or 'Covered'
%% Define pool geometry, material, and environmental data
L = 2; W = 2; D = 1; A = L*W; V = L*W*D; %Pool geometry
Tw = 298; %Water temperature to maintain
cp_w = 4181; rho_w = 997; 
mu_w = 0.891*1e-3; k_w = 0.6; %fake placeholder numbers, need to get the real ones
eps_w = 0.955; n_w = 1.33; %water data
eps_c = 0.9; n_c = 1.59; k_c = 0.191; %cover data
La = 0.01; Lc = 0.0127; %Thickness of cover sheets and air pocket. We can try to optimize these later
n_a = 1; k_a = 0.02364; %air data
sig = 5.67*1e-8; %Stefan-Boltzmann constant

%Reflective losses
alpha = @(n) 1 - (n-1)/(n+1);
alpha_w = alpha(n_w); alpha_c = alpha(n_c); alpha_a = alpha(n_a);

%Define energy info. Will load this from a data file eventually
Us = [4 1 1];
irradiances = [1 1 1];
Tes = [279 281 275];
Tbs = Tes - 10;

times = length(Us); %Time span of study. Will be an array eventually, probably in hours. Covering 3 months

%% Calculations For Uncovered Pool
if strcmp(testCase,'Uncovered')
    Qdot_solar = @(t) alpha_w*irradiances(t)*A; %solar heating
    
    %Define htc's
    h_r = @(Tb) 4*eps_c*sig*((Tw+Tb)/2)^3; %rad from pool surface to sky
    rho_a = 1.292; mu_a = 1.729*10^(-5); Pr_a = 0.7362; %All redundant stuff from covered
    Re = @(U) rho_a*U*L/mu_a;
    Nu = @(U) 0.664*Re(U)^0.5*Pr_a; %Nusselt correlation for h_conv_e
    h_conv = @(U) Nu(U)*k_a/L; %convection from pool surface to air
    
    %Heat fluxes
    Qdot_rad_func = @(t) h_r(Tbs(t))*A*(Tw-Tbs(t));
    Qdot_conv_func = @(t) h_conv(Us(t))*A*(Tw-Tes(t));
    Qdot_tot_func = @(t) Qdot_rad_func(t) + Qdot_conv_func(t);
    Qdot_heating_func = @(t) Qdot_tot_func(t) - Qdot_solar(t);
    
    powerUsage = zeros(1,times);
    powerCumulative = zeros(1,times);
    for t=1:times
        %U = Us(t); Tb = Tbs(t); Te = Tes(t);
        %Result:
        Qdot_rad = Qdot_rad_func(t);
        Qdot_conv = Qdot_conv_func(t);
        Qdot_tot = Qdot_tot_func(t);
        Qdot_heating_uncovered = Qdot_heating_func(t);
        powerCumulative(t) = Qdot_heating_uncovered + sum(powerUsage); %Could plot the running cost using this data
        powerUsage(t) = Qdot_heating_uncovered;
    end
    %Calculate total heating costs over the period of interest
    sumPower = sum(powerUsage);
    Cost_uncovered = electricity_price(sumPower);
    %Calculate running cost
    running_cost = electricity_price(powerUsage);
    %Might want to save the results, although this part is explicit and
    %should be pretty fast
end
%% Setup for Covered Pool

alpha_tot = alpha_w*alpha_c^2*alpha_a^2*alpha_c^2; %reflective losses
Qdot_solar = alpha_tot*irradiances.*A; %solar heating

%Define htc's
h_r_a = @(Tm_a) 4*eps_c*sig*Tm_a^3; %rad from first cover sheet to second cover sheet
h_r_e = @(Tb, Ts) 4*eps_c*sig*((Tb+Ts)/2)^3; %rad from cover to sky
rho_a = 1.292; mu_a = 1.729*10^(-5); Pr_a = 0.7362;
Re = @(U) rho_a*U*L/mu_a;
Nu_e = @(U) 0.664*Re(U)^0.5*Pr_a; %Nusselt correlation for h_conv_e
h_conv_e = @(U) Nu_e(U)*k_a/L; %convection from pool surface to air
Gr_w = @(T2) 9.81*(Tw-T2)*L^3/(Tw*(mu_w/rho_w)^2);
Pr_w = mu_w*cp_w/k_w;
Ra_w = @(T2) Gr_w(T2)*Pr_w;
h_conv_w = @(T2) 0.15*Ra_w(T2)^(1/3); %Ra = 1e13, probably need a different correlation

%Define Thermal Resistances
R_r_a = @(Tm_a) 1/(A*h_r_a(Tm_a));
R_r_e = @(Tb, Ts) 1/(A*h_r_e(Tb, Ts));
R_conv_e = @(U) 1/(A*h_conv_e(U));
R_conv_w = @(T2) 1/(A*h_conv_w(T2));
R_cond_c = @(Lc) Lc/(k_c*A);
R_cond_a = @(La) La/(k_a*A);
R_parallel = @(La, Tm_a) (1/R_cond_a(La) + 1/R_r_a(Tm_a))^-1;

%Sum of the thermal resistances along each path
Rth_e = @(Tm_a, T2, Lc, La, U) R_conv_e(U) + R_conv_w(T2) + 2*R_cond_c(Lc) + R_parallel(La, Tm_a);
Rth_b = @(Tm_a, T2, Tb, Ts, Lc, La) R_r_e(Tb, Ts) + R_conv_w(T2) + 2*R_cond_c(Lc) + R_parallel(La, Tm_a);
Rth_s = @(Tm_a, T2, Lc, La) R_conv_w(T2) + 2*R_cond_c(Lc) + R_parallel(La, Tm_a);
Rth_2 = @(Lc, T2) R_cond_c(Lc) + R_conv_w(T2);

%Heat flux along each path
Qdot_e_initial = @(Te, Tm_a, T2, Lc, La, U) (Tw-Te)/Rth_e(Tm_a, T2, Lc, La, U);
Qdot_b_initial = @(Tb, Tm_a, T2, Ts, Lc, La) (Tw-Tb)/Rth_b(Tm_a, T2, Tb, Ts, Lc, La);
Qdot_e_good = @(Te, Ts, U) (Ts-Te)/R_conv_e(U);
Qdot_b_good = @(Tb, Ts) (Ts-Tb)/R_r_e(Tb, Ts);
Qdot_totFunc = @(Qdot_e, Qdot_b) Qdot_b + Qdot_e; %Could rewrite w/nested functions and not have to directly eval them to use as inputs
%Might use avg(avg(Qe,Qb),Qe+Qb) to improve our initial guess

%Get Ts from each terminal path and take the average as Ts_guess
Ts_e_guess = @(Te, Qdot_e, U) Te + Qdot_e*R_conv_e(U);
Ts_b_guess = @(Tb, Qdot_b, Ts_old) Tb + Qdot_b*R_r_e(Tb, Ts_old);
Ts_guess_initial = @(Ts_e, Ts_b) (Ts_e + Ts_b)/2; %Could rewrite this w/nested functions
Ts_guess_good = @(Qdot_tot, Tm_a, T2, Lc, La) Tw - Qdot_tot*Rth_s(Tm_a, T2, Lc, La);

%Get the intermediary temperatures needed for R_rad_a
T2_guess = @(Qdot_tot, Lc, T2) Tw - Qdot_tot*Rth_2(Lc, T2);
T3_guess = @(Qdot_tot, Ts_guess, Lc) Ts_guess + Qdot_tot*R_cond_c(Lc);
Tm_a_guess = @(T2_guess, T3_guess) (T2_guess + T3_guess)/2; %Could rewrite this w/nested functions

%Initial guesses for T distribution
%Tm = @(t) (Te(t) + Tw)/2; %Tm should be roughly halfway between the water and air
%Ts = @(t) Tw + 0.9*(Te(t)-Tw); %Ts should be pretty close to the air

%% Calculation for Covered Pool
if strcmp(testCase,'Covered')
    tol = 1;
    powerUsage = zeros(1,times);
    powerCumulative = zeros(1,times);
    
    %Calculate the first time step with initial guesses
    t = 1;
    Te = Tes(t); Tb = Tbs(t); Tm = 0.5*(Tw-Te) + Te; Ts = 0.9*(Tw-Te) + Te; %Initial T distribution. Replace Tm(t), Ts(t) with reasonable guesses between Te, Tw
    %Also need to get wind velocity at time t to get h_c_e
    U = Us(t);
    %Calculate Qdot_tot for first time step
    %Looks like i also need to pass anon funcs as args here
    [Qdot_tot, Tm, Ts] = Qdot_convergence(Te, Tb, Tm, Ts, tol, Lc, La, U, Qdot_e_initial, Qdot_b_initial, Qdot_totFunc, Ts_e_guess, Ts_b_guess, Ts_guess_initial, T2_guess, T3_guess, Tm_a_guess, Ts_guess_good, Qdot_e_good, Qdot_b_good);
    Qdot_heating = Qdot_tot - Qdot_solar(t);
    powerCumulative(1) = Qdot_heating + sum(powerUsage);
    powerUsage(1) = Qdot_heating;

    %Run the rest of the time steps, reusing Tm, Ts from last time step as initial guess
    for t=2:times
        %Get wind velocity at time t, use velocity to get convective htc
        U = Us(t);
        %Initial T distribution
        Te = Tes(t); Tb = Tbs(t);
        [Qdot_tot, Tm, Ts] = Qdot_convergence(Te, Tb, Tm, Ts, tol, Lc, La, U, Qdot_e_initial, Qdot_b_initial, Qdot_totFunc, Ts_e_guess, Ts_b_guess, Ts_guess_initial, T2_guess, T3_guess, Tm_a_guess, Ts_guess_good, Qdot_e_good, Qdot_b_good);
        Qdot_heating = Qdot_tot - Qdot_solar(t);
        powerCumulative(t) = Qdot_heating + sum(powerUsage);
        powerUsage(t) = Qdot_heating;
    end

    %Result:
    sumPower = sum(powerUsage);
    Cost_covered = electricity_price(sumPower);
    %Calculate running cost
    running_cost = electricity_price(powerUsage);
    %Might want to save the results so I don't have to run the loops
    %every time if it's slow
end

%% Plotting Results
%Could plot Qdot_heating as a function of time 
%Could compare this plot for covered vs uncovered
%Could also overlay plots of the incident radiation intensity and/or air temperature
%{
plot(times, Qdot_heating_uncovered, 'DisplayName', 'Without Solar Blanket')
hold on;
plot(times, Qdot_heating_covered, 'DisplayName', 'With Solar Blanket')
plot(times, Te(times), 'DisplayName', 'Ambient Air Temperature')
plot(times, irradiance(times), 'DisplayName', 'Direct Normal Irradiance')
title('Heating Power Required To Maintain Water Temperature')
xlabel('Date') %could make nice xticks showing the actual date instead of just time elapsed
ylabel('Heating Power [W]')
hold off;
%}

%% Helper Functions
function [Qdot_tot, Tm, Ts] = Qdot_convergence(Te, Tb, Tm, Ts, tol, Lc, La, U, Qdot_e_initial, Qdot_b_initial, Qdot_totFunc, Ts_e_guess, Ts_b_guess, Ts_guess_initial, T2_guess, T3_guess, Tm_a_guess, Ts_guess_good, Qdot_e_good, Qdot_b_good)
    %Use the iterative method to find Qdot_tot given a T distribution guess
    %Note: Qdot_e,b,tot inputs are functions. Might run into overloading trouble here
  
    T2 = Tm + 3; %need an initial guess for T2
    %Calculate initial fluxes
    Qdot_e = Qdot_e_initial(Te, Tm, T2, Lc, La, U);
    Qdot_b = Qdot_b_initial(Tb, Tm, T2, Ts, Lc, La);
    Qdot_tot = Qdot_e + Qdot_b;
    Qdot_tot_old = Qdot_tot;
    %Calculate first updated guess for Ts
    Ts_e = Ts_e_guess(Te, Qdot_e, U);
    Ts_b = Ts_b_guess(Tb, Qdot_b, Ts);
    Ts = Ts_guess_initial(Ts_e, Ts_b);
    %Calculate first updated guess for Tm
    T2 = T2_guess(Qdot_tot, Lc, T2);
    T3 = T3_guess(Qdot_tot, Ts, Lc);
    Tm = Tm_a_guess(T2, T3);
    %Update guesses for fluxes
    Qdot_e = Qdot_e_good(Te, Ts, U);
    Qdot_b = Qdot_b_good(Tb, Ts);
    Qdot_tot = Qdot_e + Qdot_b;
    %Check convergence
    dQ_Tot = Qdot_tot - Qdot_tot_old;

    while abs(dQ_Tot) > tol
        Qdot_tot_old = Qdot_tot;
        %Update guesses for T distribution. 
        %Currently replacing my "good" method which diverges with the
        %initial guess method which treats Qe and Qb as parallel
        %Ts = Ts_guess_good(Qdot_tot, Tm, Lc, La);
        Qdot_e = Qdot_e_initial(Te, Tm, T2, Lc, La, U);
        Qdot_b = Qdot_b_initial(Tb, Tm, T2, Ts, Lc, La);
        Ts_e = Ts_e_guess(Te, Qdot_e, U);
        Ts_b = Ts_b_guess(Tb, Qdot_b, Ts);
        Ts = Ts_guess_initial(Ts_e, Ts_b);
        T2 = T2_guess(Qdot_tot, Lc, T2)
        T3 = T3_guess(Qdot_tot, Ts, Lc)
        Tm = Tm_a_guess(T2, T3);
        %Update guesses for fluxes
        Qdot_e = Qdot_e_good(Te, Ts, U);
        Qdot_b = Qdot_b_good(Tb, Ts);
        Qdot_tot = Qdot_e + Qdot_b;
        %Check convergence
        dQ_Tot = Qdot_tot - Qdot_tot_old;
    end

end

function price = electricity_price(Qt)
%Qt is the power used, in Watt hours. Convert to kWh first
%sumHeating is the amount of electricity we've already used in Watt hours, to check when
%we go over 40 kWh
Qt = Qt/1000;
%sumHeating = sumHeating/1000;
%Price is the cost of that amount of power, in dollars (HydroQuebec Pricing)
    if Qt<40
        price = 0.0608*Qt;
    else
        price = 0.0608*40 + 0.0938*(Qt-40);
    end
end

