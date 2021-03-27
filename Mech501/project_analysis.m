%% Input variables
alpha_s = 0.95; eps_a = 0.09; eps_s = 1; sig = 5.67*1e-8;
r1 = 0.05; r2 = 0.1; rm = 1.5; D1 = 2*r1; D2 = 2*r2; Dm = 2*rm;
To = 293; Ti = 393; kf = 0.088; cpf = 2.438*1e3; muf = 1.9*1e-4;
Te = 35; Be = 1/(Te+273); alpha_e = 7.91*1e-5; ve = 5.49*1e-5; ke = 0.047;
k_al = 220; rough=0;

%L = 50; %dummy value, replace once we decide
Tf = (Ti + To)/2; %could discretize the length of the pipe and calculate the flux at each point using the local temperature

%mdot = 1;
Nm = 100;
mdot_vals = logspace(0,4,Nm); %Probably want to try a range of mdot values and pick the optimal one
rec_eff_vals = zeros(Nm,1);
Ta_vals = zeros(Nm,1);

QdotS = 10000; %Dummy value
%QdotS = alpha_s*cg*Is*Ai

verbose = false;

for i=1:Nm
    mdot = mdot_vals(i);
    
    %Evaluate HT model
    [Qdot_loss_rad, Qdot_loss_conv, Qdot_loss, rec_eff, Ta] = parabolic_trough_HT_model(mdot,QdotS,muf,cpf,kf,rough,r1,r2,D1,D2,k_al,alpha_e,ve,ke,Be,Te,Tf,eps_a,eps_s,verbose);
    
    Ta_vals(i) = Ta;
    rec_eff_vals(i) = rec_eff;

end

subplot(2,1,1)
semilogx(mdot_vals,rec_eff_vals)
xlabel('Mass flow rate (m^3/s)')
ylabel('Receiver Efficiency')

subplot(2,1,2)
semilogx(mdot_vals,Ta_vals)
xlabel('Mass flow rate (m^3/s)')
ylabel('External Absorber Wall Temperature (K)')

