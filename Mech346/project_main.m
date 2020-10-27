clear all;
close all;
testCase = 'Uncovered'; %Can be 'Uncovered' or 'Covered'
%% Define pool geometry, material, and environmental data
L = 1; W = 1; D = 1; A = L*W; V = L*W*D; %Pool geometry
Tw = 298; %Water temperature to maintain
%May not need this since we only need Qdot
%c_water = 4200; rho_water = 997; m_pool = rho_water*V; c_pool = m_pool*c_water;
eps_w = 1; n_w = 1; %water data
eps_c = 1; n_c = 1; k_c = 1; %cover data
La = 0.1; Lc = 0.1; %Thickness of cover sheets and air pocket. We can try to optimize these later
n_a = 1; k_a = 1; %air data
sig = 5.67*1e-8; %Stefan-Boltzmann constant

%Reflective losses
alpha = @(n) 1 - (n-1)/(n+1);
alpha_w = alpha(n_w); alpha_c = alpha(n_c); alpha_a = alpha(n_a);

%Define energy info. Will load this from a data file eventually
irradiance = @(t) 1;
Te = @(t) 279;
Tb = @(t) Te(t) - temp_convert((temp_convert(Te(t),'K','F') - 20),'F','K'); %Tb = Te - 20F, convert back to K
%Cost = @(Qdot_heating, t_heat) [integral over time of e_price, Qdot_heating]
times = 10; %Time span of study. Will be an array eventually, probably in hours. Covering 3 months

%% Calculations For Uncovered Pool
if strcmp(testCase,'Uncovered')
    Qdot_solar = @(t) alpha_w*irradiance(t)*A; %solar heating

    %Define htc's
    h_r = @(Tb) 4*eps_c*sig*((Tw+Tb)/2)^3; %rad from pool surface to sky
    h_conv = 1; %convection from pool surface to air

    %Heat fluxes
    Qdot_rad = @(t) h_r(Tb(t))*A*(Tw-Tb(t));
    Qdot_conv = @(t) h_conv*A*(Tw-Te(t));
    Qdot_tot = @(t) Qdot_rad(t) + Qdot_conv(t);
    Qdot_heating = @(t) Qdot_tot(t) - Qdot_solar(t);

    %Result:
    Qdot_heating_uncovered = Qdot_heating(times)
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
h_conv_w = 1; %convection from pool surface to air
h_conv_e = 1; %convection from pool surface to air

%Define Thermal Resistances
R_r_a = @(Tm_a) 1/(A*h_r_a(Tm_a));
R_r_e = @(Tb, Ts) 1/(A*h_r_e(Tb, Ts));
R_conv_w = 1/(A*h_conv_w);
R_conv_e = 1/(A*h_conv_e);
R_cond_c = @(Lc) Lc/(k_c*A);
R_cond_a = @(La) La/(k_a*A);

%Sum of the thermal resistances along each path (need to fix, make r_a parallel with cond_a)
Rth_e = @(Tm_a, Lc, La) R_r_a(Tm_a) + R_conv_w + R_conv_e + R_cond_c(Lc) + R_cond_a(La);
Rth_b = @(Tm_a, Tb, Ts, Lc, La) R_r_a(Tm_a) + R_r_e(Tb, Ts) + R_conv_w + R_cond_c(Lc) + R_cond_a(La);
Rth_s = @(Tm_a, Lc, La) R_r_a(Tm_a) + R_conv_w + R_cond_c(Lc) + R_cond_a(La);
Rth_2 = @(Lc) R_conv_w + R_cond_c(Lc);

%Heat flux along each path
Qdot_e = @(Te, Tm_a, Lc, La) Rth_e(Tm_a, Lc, La)^(-1)*(Te-Tw);
Qdot_b = @(Tb, Tm_a, Ts, Lc, La) Rth_b(Tm_a, Tb, Ts, Lc, La)^(-1)*(Tb-Tw);
Qdot_totFunc = @(Qdot_e, Qdot_b) Qdot_b + Qdot_e; %Could rewrite w/nested functions and not have to directly eval them to use as inputs

%Get Ts from each terminal path and take the average as Ts_guess
Ts_e = @(Te, Qdot_e) Te - Qdot_e*R_conv_e;
Ts_b = @(Tb, Qdot_b, Ts_old) Tb - Qdot_b*R_r_e(Tb, Ts_old);
Ts_guess = @(Ts_e, Ts_b) (Ts_e + Ts_b)/2; %Could rewrite this w/nested functions

%Get the intermediary temperatures needed for R_rad_a
T2_guess = @(Qdot_tot, Lc) Tw + Qdot_tot*Rth_2(Lc);
T3_guess = @(Qdot_tot, Ts_guess, Lc) Ts_guess - Qdot_tot*R_cond_c(Lc);
Tm_a_guess = @(T2_guess, T3_guess) (T2_guess + T3_guess)/2; %Could rewrite this w/nested functions

%Initial guesses for T distribution
Tm = @(t) (Te(t) + Tw)/2; %Tm should be roughly halfway between the water and air
Ts = @(t) Tw + 0.9*(Te(t)-Tw); %Ts should be pretty close to the air

%% Calculation for Covered Pool
if strcmp(testCase,'Covered')
    tol = 100;
    Qdot_tot_store = zeros(length(times),1);
    t = times(1); %this will eventually be in a for loop to go through the time span
    Te = Te(t); Tb = Tb(t); Tm = Tm(t); Ts = Ts(t); %Initial T distribution
    %Calculate Qdot_tot for first time step
    [Qdot_tot, Tm, Ts] = Qdot_convergence(Te, Tb, Tm, Ts, tol, Qdot_e, Qdot_b, Qdot_totFunc, Lc, La);
    Qdot_tot_store(1) = Qdot_tot;
    %Run the rest of the time steps, reusing Tm, Ts from last time step as initial guess
    for i=2:times(end)
        t = times(i);
        %Initial T distribution
        Te = Te(t); Tb = Tb(t);
        [Qdot_tot, Tm, Ts] = Qdot_convergence(Te, Tb, Tm, Ts, tol, Qdot_e, Qdot_b, Qdot_totFunc, Lc, La);
        Qdot_tot_store(i) = Qdot_tot;
    end

    %Result:
    Qdot_heating_covered = Qdot_tot - Qdot_solar(times) %Calculate the heating energy used at each time step in the array
    %Not sure if these are the right input formats for the integral
    %Cost_uncovered = Cost(Qdot_heating_uncovered, times)
    
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
function [Qdot_tot, Tm, Ts] = Qdot_convergence(Te, Tb, Tm, Ts, tol, Qdot_e, Qdot_b, Qdot_tot, Lc, La)
    %Use the iterative method to find Qdot_tot given a T distribution guess
    %Note: Qdot_e,b,tot inputs are functions. Might run into overloading trouble here
    dQ_Tot = 1000;
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
