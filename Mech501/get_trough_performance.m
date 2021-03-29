function [L, Tf_store, Qdot_trough_store, rec_eff_store] = get_trough_performance(Ti,To,mdot,L,dL,QdotS,muf,cpf,kf,rough,r1,r2,D1,D2,k_al,alpha_e,ve,ke,Be,Te,eps_a,eps_s,verbose,plot_trough)
%Calculate the length of the trough needed to acheive desired Ti, To, and mdot values
%Also return the net flux, Tf, rec_eff, and fdarcy at each differential length element

Tf_store = [];
Qdot_trough_store = [];
rec_eff_store = [];
fdarcy_store = [];

Tf_i = Ti;
while Tf_i < To
    Tf = Tf_i; %Set the incoming fluid temperature of this 1m segment
    [~, ~, ~, rec_eff, ~] = parabolic_trough_HT_model(mdot,QdotS,muf,cpf,kf,rough,r1,r2,D1,D2,k_al,alpha_e,ve,ke,Be,Te,Tf,eps_a,eps_s,verbose);
    Qdot_trough_i = QdotS*rec_eff; %Energy collected by one metre of trough
    dT = (Qdot_trough_i*dL)/(mdot*cpf); %Get change in temperature over this metre of trough
    Tf_i = Tf + dT; %Update fluid temperature
    
    Tf_store = [Tf_store Tf];
    Qdot_trough_store = [Qdot_trough_store Qdot_trough_i];
    rec_eff_store = [rec_eff_store rec_eff];
    %fdarcy_store = [fdarcy_store fdarcy];
    L = L + dL;
    
end

if plot_trough
    figure;
    subplot(2,2,1)
    plot(Tf_store)
    ylabel('Fluid Temperature (C)')

    subplot(2,2,2)
    plot(Qdot_trough_store)
    ylabel('Net Flux (W)')
    xlabel('Trough Length (m)')
    
    subplot(2,2,3)
    plot(rec_eff_store)
    ylabel('Receiver Efficiency')
    xlabel('Trough Length (m)')
    
    subplot(2,2,4)
    %plot(fdarcy_store)
    ylabel('Darcy Friction Factor')
    xlabel('Trough Length (m)')
end


end

