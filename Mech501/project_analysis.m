%% Input variables
alpha_s = 0.95; eps_a = 0.09; eps_s = 1; sig = 5.67*1e-8;
r1 = 0.05; r2 = 0.1; rm = 2.14; D1 = 2*r1; D2 = 2*r2; Dm = 2*rm;
To = 393; Ti = 293; kf = 0.088; cpf = 2.438*1e3; muf = 1.9*1e-4; rhof = 768;
Te = 35; Be = 1/(Te+273); alpha_e = 7.91*1e-5; ve = 5.49*1e-5; ke = 0.047;
k_al = 220; rough=0;


Tf = (Ti + To)/2; %could discretize the length of the pipe and calculate the flux at each point using the local temperature

Nm = 100;
mdot_vals = logspace(0,4,Nm); %Probably want to try a range of mdot values and pick the optimal one
rec_eff_vals = zeros(Nm,1);
Ta_vals = zeros(Nm,1);

Is = 1041; %W/m2 (DNI)
Ai = Dm*1; %m^2 per unit length
Ao = D2*pi/2;
Cg = Ai/Ao;
absorber_efficiency = 0.8455;

QdotS = Is*Cg*absorber_efficiency*Ao;

%L = 100; %Length of each individual trough, in metres

%% Run the model and analyze effects of varying mass flow rate

verbose = false;

for i=1:Nm
    mdot = mdot_vals(i);
    
    %Evaluate HT model
    [Qdot_loss_rad, Qdot_loss_conv, Qdot_loss, rec_eff, Ta] = parabolic_trough_HT_model(mdot,QdotS,muf,cpf,kf,rough,r1,r2,D1,D2,k_al,alpha_e,ve,ke,Be,Te,Tf,eps_a,eps_s,verbose);
    %plot_trough = false;
    %[L, Tf, Qdot_trough, rec_eff] = get_trough_performance(Ti,To,mdot,L,dL,QdotS,muf,cpf,kf,rough,r1,r2,D1,D2,k_al,alpha_e,ve,ke,Be,Te,eps_a,eps_s,verbose,plot_trough);
    
    Ta_vals(i) = mean(Tf);
    rec_eff_vals(i) = mean(rec_eff);

end

subplot(2,1,1)
semilogx(mdot_vals,rec_eff_vals)
xlabel('Mass flow rate (m^3/s)')
ylabel('Receiver Efficiency')

subplot(2,1,2)
semilogx(mdot_vals,Ta_vals)
xlabel('Mass flow rate (m^3/s)')
ylabel('External Absorber Wall Temperature (K)')

%% Determine length of a single trough given mdot, Ti, To

mdot_opt = 0.005;
%[Qdot_loss_rad, Qdot_loss_conv, Qdot_loss, rec_eff, Ta, fdarcy] = parabolic_trough_HT_model(mdot_opt,QdotS,muf,cpf,kf,rough,r1,r2,D1,D2,k_al,alpha_e,ve,ke,Be,Te,Tf,eps_a,eps_s,verbose);

L = 0;
dL = 1;

plot_trough = true;
[L, Tf_store, Qdot_trough_store, rec_eff_store] = get_trough_performance(Ti,To,mdot_opt,L,dL,QdotS,muf,cpf,kf,rhof,rough,r1,r2,D1,D2,k_al,alpha_e,ve,ke,Be,Te,eps_a,eps_s,verbose,plot_trough);

%{
Tf_store = [];
Qdot_trough_store = [];
rec_eff_store = [];
fdarcy_store = [];

Tf_i = Ti;
while Tf_i < To
    Tf = Tf_i; %Set the incoming fluid temperature of this 1m segment
    [~, ~, ~, rec_eff, ~, fdarcy] = parabolic_trough_HT_model(mdot_opt,QdotS,muf,cpf,kf,rough,r1,r2,D1,D2,k_al,alpha_e,ve,ke,Be,Te,Tf,eps_a,eps_s,verbose);
    Qdot_trough_i = QdotS*rec_eff; %Energy collected by one metre of trough
    dT = (Qdot_trough_i*L)/(mdot_opt*cpf); %Get change in temperature over this metre of trough
    Tf_i = Tf + dT; %Update fluid temperature
    
    Tf_store = [Tf_store Tf];
    Qdot_trough_store = [Qdot_trough_store Qdot_trough_i];
    L = L + dL;
    
end

figure;
subplot(2,1,1)
plot(Tf_store)
ylabel('Fluid Temperature (C)')

subplot(2,1,2)
plot(Qdot_trough_store)
ylabel('Net Flux (W)')
xlabel('Trough Length (m)')
%}

%Get the total flux absorbed over the length of one trough
Qdot_trough = sum(Qdot_trough_store);

%% Analysis of plant scaling based on units of this single trough

Qdot_plant = 50*1e6; %50MW plant
N_collectors = Qdot_plant/Qdot_trough; %Number of troughs needed to meet total power plant requirements

out = ['For trough of length ',num2str(L),'m and mass flow rate ',num2str(mdot_opt),'m^3/s, ',num2str(N_collectors),' troughs are needed to supply ', num2str(Qdot_plant/1e6), 'MW of thermal power'];
disp(out)

%% Calculation of pressure losses

%v_avg = (4*mdot_opt)/(pi*rhof*D1^2); %Calculate average velocity
v_avg = mdot_opt/(pi*r1^2);
%p_loss_parasitic = ((L*rhof*v_avg^2)/(D1*2))*fdarcy; %parasitic pressure loss along one trough


