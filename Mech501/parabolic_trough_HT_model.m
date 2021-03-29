function [Qdot_loss_rad, Qdot_loss_conv, Qdot_loss, rec_eff, Ta] = parabolic_trough_HT_model(QdotS,D2,alpha_e,ve,ke,Be,Te,Tf,eps_a,eps_s,verbose)
%Perform the heat transfer analysis on our parabolic trough model to
%evaluate losses, receiver efficiency, absorber temperature, ...

g = 9.81; sig = 5.67*1e-8;
%% Calculate dimensionless numbers for convection
%Probably want to treat everything as Qdot/L instead of Qdot

Ta = Tf; %Set absorber outer temperature equal to fluid temperature, since the absorber is thin and the
%inner diameter of the pipe is small, so the resistance between Ta and Ts is negligible

%Write forced convection, look up average wind speed in Abu Dhabi
natural_conv = true;

%Dimensionless numbers of air
if natural_conv
    Pr_e = 0.694; %direct from Yunus&Cengel
    Ra_e = (g*Be*(Ta-Te)*D2^3)/(alpha_e*ve);

    Nu_e = (0.6 + 0.387*(Ra_e/(1+(0.559/Pr_e)^(9/16))^(16/9))^(1/6))^2; %natural convection
end

%% Calculate heat losses

R_conv_e = 1/(Nu_e*ke*pi); %R_conv_e = 1/(Nu_e*ke*pi*L);
Qdot_loss_conv = (Ta-Te)/R_conv_e;

Ts = Te-20;
Qdot_loss_rad = pi*D2*sig*(eps_a*(Ta+273)^4 - eps_s*(Ts+273)^4);

Qdot_loss = Qdot_loss_conv + Qdot_loss_rad;
%Qdot_loss = Qdot_loss_rad;

rec_eff = 1 - Qdot_loss/QdotS;

if verbose
    message = ['Incoming Solar Radiation:', num2str(QdotS),' W/m, Heat Losses:',num2str(Qdot_loss),' W/m'];
    disp(message)
end
    
end

