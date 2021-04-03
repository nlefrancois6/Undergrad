function [Qdot_loss_rad, Qdot_loss_conv, Qdot_loss, rec_eff, Ta, Tg] = parabolic_trough_HT_model(QdotS,D2,Dg,alpha_e,ve,ke,Be,Te,Tf,eps_a,eps_s,eps_g,verbose,natural_conv,cover,u_wind)
%Perform the heat transfer analysis on our parabolic trough model to
%evaluate losses, receiver efficiency, absorber temperature, glass temperature

g = 9.81; sig = 5.67*1e-8; %Physical constants
%% Calculate dimensionless numbers for convection
%Probably want to treat everything as Qdot/L instead of Qdot

Ta = Tf; %Set absorber outer temperature equal to fluid temperature

%Dimensionless numbers of air
if natural_conv
    Pr_e = 0.694; %from Yunus&Cengel
    Ra_e = (g*Be*(Ta-Te)*D2^3)/(alpha_e*ve);
    %natural convection correlation
    Nu_e = (0.6 + 0.387*(Ra_e/(1+(0.559/Pr_e)^(9/16))^(16/9))^(1/6))^2; 
else
    k_film = 0.0365; Pr_film = 0.699; v_film = 3.21*1e-5; %properties at film temperature, from Yunus&Cengel
    ke = k_film; 
    %forced convection correlation
    Re_e = u_wind*D2/v_film;
    Nu_e = 0.3 + ((0.62*Re_e^(1/2)*Pr_film^(1/3))/(1+(0.4/Pr_film)^(2/3))^(1/4))*(1+(Re_e/282000)^(5/8))^(4/5);
end


%% Calculate heat losses
if cover
    %Get thermal resistances
    R_rad_g = ((1-eps_a)/(D2*eps_a) + 1/D2 + (1-eps_g)/(Dg*eps_g))/pi;
    R_conv_e = 1/(Nu_e*ke*pi);
    R_rad_s = ((1-eps_g)/eps_g + 1)/(pi*Dg);
    
    Ts = Te-10; %Sky is modelled as blackbody ~10 degrees cooler than ambient
    TsK = Ts + 273; TaK = Ta + 273; TeK = Te + 273; %Convert C to K
    
    TgK_est = ((TaK^4 + R_rad_g*TsK^4/R_rad_s)/(R_rad_g/R_rad_s + 1))^(1/4); %Tg estimate with only rad

    %{
    %Qdot_loss_est = sig*(TgK_est^4 - TsK^4)/R_rad_s + (TgK_est - TeK)/R_conv_e; %Qdot_loss estimate using Tg estimate
    
    TgK = (TaK^4 - R_rad_g*Qdot_loss_est/sig)^(1/4); %Update our improved Tg estimate
    if isreal(TgK) ~= 1
        disp('TgK is complex')
    end
    %}
    %Get the flux loss components and total
    Qdot_loss_rad = sig*(TgK_est^4 - TsK^4)/R_rad_s;
    Qdot_loss_conv = (TgK_est - TeK)/R_conv_e;
    Qdot_loss = Qdot_loss_rad + Qdot_loss_conv;
    
    Tg = TgK_est - 273; %Convert back to C
else
    R_conv_e = 1/(Nu_e*ke*pi); 
    Qdot_loss_conv = (Ta-Te)/R_conv_e;

    Ts = Te-10;
    Qdot_loss_rad = pi*D2*sig*(eps_a*(Ta+273)^4 - eps_s*(Ts+273)^4);

    Qdot_loss = Qdot_loss_conv + Qdot_loss_rad; %Get the total flux losses
    
    Tg = 0; %Dummy output, not used since we have no glass in the uncovered case
end

rec_eff = 1 - Qdot_loss/QdotS; %Calculate receiver efficiency

if verbose
    message = ['Incoming Solar Radiation:', num2str(QdotS),' W/m, Heat Losses:',num2str(Qdot_loss),' W/m'];
    disp(message)
end
    
end

