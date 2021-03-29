function [L, Tf_store, Qdot_trough_store, rec_eff_store] = get_trough_performance(Ti,To,mdot,L,dL,QdotS,cpf,rhof,D2,alpha_e,ve,ke,Be,Te,eps_a,eps_s,verbose,plot_trough)
%Calculate the length of the trough needed to acheive desired Ti, To, and mdot values
%Also return the net flux, Tf, and rec_eff at each differential length element

Tf_store = [];
Qdot_trough_store = [];
rec_eff_store = [];

Tf_i = Ti;
while Tf_i < To
    Tf = Tf_i; %Set the incoming fluid temperature of this 1m segment
    [~, ~, ~, rec_eff, ~] = parabolic_trough_HT_model(QdotS,D2,alpha_e,ve,ke,Be,Te,Tf,eps_a,eps_s,verbose);
    Qdot_trough_i = QdotS*rec_eff; %Energy collected by 1m of trough
    dT = (Qdot_trough_i*dL)/(mdot*rhof*cpf); %Get change in temperature over this metre of trough
    Tf_i = Tf + dT; %Update fluid temperature
    
    %Store trough metrics
    Tf_store = [Tf_store Tf];
    Qdot_trough_store = [Qdot_trough_store Qdot_trough_i];
    rec_eff_store = [rec_eff_store rec_eff];

    L = L + dL; %Increment the length and move to the next 1m segment
    
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
end


end

