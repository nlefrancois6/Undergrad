%% Input variables
alpha_s = 0.95; eps_a = 0.09; eps_s = 1; eps_g = 0.4; sig = 5.67*1e-8;
r1 = 0.05; r2 = 0.1; rg = 0.2; rm = 2.14; D1 = 2*r1; D2 = 2*r2; Dm = 2*rm; Dg = 2*rg;
To = 393; Ti = 293; kf = 0.088; cpf = 2.438*1e3; muf = 1.9*1e-4; rhof = 768;
Te = 35; Be = 1/(Te+273); alpha_e = 7.91*1e-5; ve = 5.49*1e-5; ke = 0.047;
rough=0.01;

Is = 1041; %W/m2 (DNI)
Ai = Dm*1; %m^2 per unit length
Ao = D2*pi/2;
Cg = Ai/Ao;
absorber_efficiency = 0.8455; %From ray-tracing simulation. This will change for cover vs no cover

QdotS = Is*Cg*absorber_efficiency*Ao; %Total solar flux absorbed by tube's outer surface

natural_conv = false; %Use natural or forced convection on the outside of the pipe, ie is there wind?
cover = true; %Use a glass cover for the absorber
u_wind = 2.5; %11miles/hr=4.9m/s, from Abu Dhabi airport average wind statistics
%Cut in half by wind fences

%% Determine length of a single trough given mdot, Ti, To

mdot_opt = 0.005; %Choose a mass flow rate value

plot_trough = true; %Switch to plot trough metrics like temperature, flux, and efficiency
verbose = false; 
%Evaluate the trough performance using our heat transfer model
[L, Tf_store, Tg_store, Qdot_trough_store, rec_eff_store] = get_trough_performance(Ti,To,mdot_opt,QdotS,cpf,rhof,D2,Dg,alpha_e,ve,ke,Be,Te,eps_a,eps_s,eps_g,verbose,plot_trough,natural_conv,cover,u_wind);

%Get the total flux absorbed over the length of one trough by summing over differential elements
Qdot_trough = sum(Qdot_trough_store);

%Get the average receiver efficiency
rec_eff_trough = mean(rec_eff_store);

%% Analysis of plant scaling based on units of this single trough

Qdot_plant = 50*1e6; %50MW plant specification
N_collectors = Qdot_plant/Qdot_trough; %Number of troughs needed to meet total power plant requirements

out1 = ['For trough of length ',num2str(L),'m and mass flow rate ',num2str(mdot_opt),'m^3/s, ',num2str(N_collectors),' troughs are needed to supply ', num2str(Qdot_plant/1e6), 'MW of thermal power'];
out2 = ['Total power of trough is ',num2str(Qdot_trough/1e3),'kW. Receiver efficiency is ',num2str(rec_eff_trough)];
disp(out1)
disp(out2)

%% Calculation of pressure losses

v_avg = mdot_opt/(pi*r1^2); %Calculate average velocity

Re_f = (4*mdot_opt)/(muf*pi*D1); %Reynold's number of HTF in pipe
fdarcy = (1.8*log10(6.9/Re_f + (rough/(3.7*D1))^(1.11)))^(-2); %Darcy friction factor of HTF in pipe

p_loss_parasitic = ((L*rhof*v_avg^2)/(D1*2))*fdarcy; %parasitic pressure loss along one trough
out3 = ['Total parasitic pressure loss of ',num2str(p_loss_parasitic*N_collectors/1e3),'kPa in plant. HTF velocity is ',num2str(v_avg),'m/s'];
disp(out3)


%% Run the model and analyze effects of varying mass flow rate
%{
verbose = false;

Tf = (Ti + To)/2; %could discretize the length of the pipe and calculate the flux at each point using the local temperature

Nm = 500;
mdot_vals = logspace(-4,-2,Nm); %Probably want to try a range of mdot values and pick the optimal one
rec_eff_vals = zeros(Nm,1);
Ta_vals = zeros(Nm,1);
L_vals = zeros(Nm,1);

for i=1:Nm
    mdot = mdot_vals(i);
    
    %Evaluate HT model
    %[Qdot_loss_rad, Qdot_loss_conv, Qdot_loss, rec_eff, Ta] = parabolic_trough_HT_model(QdotS,D2,alpha_e,ve,ke,Be,Te,Tf,eps_a,eps_s,verbose);
    plot_trough = false;
    [L, Tf, Qdot_trough, rec_eff] = get_trough_performance(Ti,To,mdot,L,dL,QdotS,cpf,rhof,D2,alpha_e,ve,ke,Be,Te,eps_a,eps_s,verbose,plot_trough,natural_conv);
    
    Ta_vals(i) = mean(Tf);
    rec_eff_vals(i) = mean(rec_eff);
    L_vals(i) = L;

end

figure;
subplot(2,1,1)
semilogx(mdot_vals,rec_eff_vals)
xlabel('Mass flow rate (m^3/s)')
ylabel('Receiver Efficiency')

subplot(2,1,2)
loglog(mdot_vals,L_vals)
xlabel('Mass flow rate (m^3/s)')
ylabel('Total Trough Length (m)')
%}
