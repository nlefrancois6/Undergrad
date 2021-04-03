function [L, Tf_store, Tg_store, Qdot_trough_store, rec_eff_store] = get_trough_performance(Ti,To,mdot,QdotS,cpf,rhof,D2,Dg,alpha_e,ve,ke,Be,Te,eps_a,eps_s,eps_g,verbose,plot_trough,natural_conv,cover,u_wind)
%Calculate the length of the trough needed to acheive desired Ti, To, and mdot values
%Also return the net flux, Tf, and rec_eff at each differential length element

%Initialize storage arrays for trough metrics
Tf_store = [];
Qdot_trough_store = [];
rec_eff_store = [];
Tg_store = [];

L = 0; %Initialize pipe length
dL = 1; %Differential element length for computing change in temperature

Tf_i = Ti; %Set the initial fluid temp to the inlet temp
while Tf_i < To
    Tf = Tf_i; %Set the incoming fluid temperature of this 1m segment
    %Evaluate the heat transfer model for this segment
    [~, ~, ~, rec_eff, ~, Tg] = parabolic_trough_HT_model(QdotS,D2,Dg,alpha_e,ve,ke,Be,Te,Tf,eps_a,eps_s,eps_g,verbose,natural_conv,cover,u_wind);
    Qdot_trough_i = QdotS*rec_eff; %Energy collected by segment
    dT = (Qdot_trough_i*dL)/(mdot*rhof*cpf); %Get change in temperature over this segment
    Tf_i = Tf + dT; %Update fluid temperature
    
    %Store trough metrics
    Tf_store = [Tf_store Tf];
    Tg_store = [Tg_store Tg];
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
    
    if cover
        subplot(2,2,4)
        plot(Tg_store);
        ylabel('Glass Temperature (K)')
        xlabel('Trough Length (m)')
    end
end


end

