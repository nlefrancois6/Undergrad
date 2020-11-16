clear all;
close all;
testCase = 'Covered'; %Can be 'Uncovered' or 'Covered'
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
irradiance = @(t) 1;
Te_func = @(t) 279;
Tb_func = @(t) temp_convert((temp_convert(Te_func(t),'K','F') - 20),'F','K'); %Tb = Te - 20F, convert back to K
%Cost = @(Qdot_heating, t_heat) [integral over time of e_price, Qdot_heating]
times = 1; %Time span of study. Will be an array eventually, probably in hours. Covering 3 months

%% Calculations For Uncovered Pool
if strcmp(testCase,'Uncovered')
    Qdot_solar = @(t) alpha_w*irradiance(t)*A; %solar heating
    
    U = 4;
    %Define htc's
    h_r = @(Tb) 4*eps_c*sig*((Tw+Tb)/2)^3; %rad from pool surface to sky
    rho_a = 1.292; mu_a = 1.729*10^(-5); Pr_a = 0.7362; %All redundant stuff from covered
    Re = @(U) rho_a*U*L/mu_a;
    Nu = @(U) 0.664*Re(U)^0.5*Pr_a; %Nusselt correlation for h_conv_e
    h_conv = @(U) Nu(U)*k_a/L; %convection from pool surface to air

    %Heat fluxes
    Qdot_rad = @(t) h_r(Tb_func(t))*A*(Tw-Tb_func(t));
    Qdot_conv = @(t) h_conv(U)*A*(Tw-Te_func(t));
    Qdot_tot = @(t) Qdot_rad(t) + Qdot_conv(t);
    Qdot_heating = @(t) Qdot_tot(t) - Qdot_solar(t);

    %Result:
    Qdot_rad = Qdot_rad(times);
    Qdot_conv = Qdot_conv(times);
    Qdot_tot = Qdot_tot(times);
    Qdot_heating_uncovered = Qdot_heating(times);
    %Not sure if these are the right input formats for the integral
    %Cost_uncovered = Cost(Qdot_heating_uncovered, times)
    
    %Might want to save the results, although this part is explicit and
    %should be pretty fast
end
%% Setup for Covered Pool

alpha_tot = alpha_w*alpha_c^2*alpha_a^2*alpha_c^2; %reflective losses
Qdot_solar = @(t) alpha_tot*irradiance(t)*A; %solar heating

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
    Qdot_tot_store = zeros(length(times),1);
    t = times(1); %this will eventually be in a for loop to go through the time span
    Te = Te_func(t); Tb = Tb_func(t); Tm = 0.5*(Tw-Te) + Te; Ts = 0.9*(Tw-Te) + Te; %Initial T distribution. Replace Tm(t), Ts(t) with reasonable guesses between Te, Tw
    %Also need to get wind velocity at time t to get h_c_e
    %U = U(t); 
    U = 4;
    %Calculate Qdot_tot for first time step
    %Looks like i also need to pass anon funcs as args here
    [Qdot_tot, Tm, Ts] = Qdot_convergence(Te, Tb, Tm, Ts, tol, Lc, La, U, Qdot_e_initial, Qdot_b_initial, Qdot_totFunc, Ts_e_guess, Ts_b_guess, Ts_guess_initial, T2_guess, T3_guess, Tm_a_guess, Ts_guess_good, Qdot_e_good, Qdot_b_good);
    Qdot_tot_store(1) = Qdot_tot
    %For initial test, I can stop here and just check that Qdot_convergence
    %works given reasonable Te, Tb, U inputs.
    %Run the rest of the time steps, reusing Tm, Ts from last time step as initial guess
    %{
    for i=2:times(end)
        t = times(i);
        %Get wind velocity at time t, use velocity to get convective htc
        %U = U(t);
        %Initial T distribution
        Te = Te_func(t); Tb = Tb_func(t);
        [Qdot_tot, Tm, Ts] = Qdot_convergence(Te, Tb, Tm, Ts, tol, Lc, La, U);
        Qdot_tot_store(i) = Qdot_tot;
    end

    %Result:
    Qdot_heating_covered = Qdot_tot - Qdot_solar(times) %Calculate the heating energy used at each time step in the array
    %Not sure if these are the right input formats for the integral
    %Cost_uncovered = Cost(Qdot_heating_uncovered, times)
    %}
    %Might want to save the results so I don't have to run the loops
    %every time if it's slow
end


%{
%This section has now been replaced by a more compact/reusable section
%Iterate until Qdot_tot converges
t = times; %this will eventually change in a for loop to go through the time span
Te = Te(t); Tb = Tb(t); Tm = Tm(t); Ts = Ts(t); %Initial T distribution
%For t>0, could use previous temps as a better guess
%Calculate initial fluxes
Qdot_e = Qdot_e(Te, Tm, Lc, La); 
Qdot_b = Qdot_b(Tb, Tm, Ts, Lc, La);
Qdot_tot = Qdot_tot(Qdot_e, Qdot_b); Qdot_tot_old = Qdot_tot;

while abs(dQ_Tot) > tol
    %Update guesses for T distribution
    Ts_e = Ts_e(Te, Qdot_e); Ts_b = Ts_b(Tb, Qdot_b, Ts);
    Ts = Ts_guess(Ts_e, Ts,b); %Could store and track Ts for convergence if i wanted before updating
    T2 = T2_guess(Qdot_tot, Lc); T3 = T3_guess(Qdot_tot, Ts_guess, Lc);
    Tm = Tm_a_guess(T2, T3);
    %Update guesses for fluxes
    Qdot_e = Qdot_e(Te, Tm, Lc, La); 
    Qdot_b = Qdot_b(Tb, Tm, Ts, Lc, La);
    Qdot_tot = Qdot_tot(Qdot_e, Qdot_b);
    %Check convergence
    dQ_Tot = Qdot_tot - Qdot_tot_old;
end

%Calculate heating energy used at this time step
Qdot_heating =  Qdot_tot - Qdot_solar(t);
%Not sure if these are the right input formats for the integral
%Cost_uncovered = Cost(Qdot_heating_uncovered, times)
%}

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
function Tout = temp_convert(Tin, Uin, Uout)
%Convert from units of Uin to units of Uout
    if strcmp(Uin,'F')&&strcmp(Uout,'K')
        Tout = 273.15 + ((Tin - 32)*(5/9));
    elseif strcmp(Uin,'K')&&strcmp(Uout,'F')
        Tout = 32 + (Tin - 273.15)*9/5;
    else
        disp('Not a supported unit conversion')
    end
end
function price = e_price(Qt)
%Qt is the power used, in kWh
%Price is the cost of that amount of power, in dollars
    if Qt<40
        price = 0.0608*Qt;
    else
        price = 0.0608*40 + 0.0938*(Qt-40);
    end
end

