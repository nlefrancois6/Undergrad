function [Qdot_loss_rad, Qdot_loss_conv, Qdot_loss, rec_eff, Ta] = parabolic_trough_HT_model(mdot,QdotS,muf,cpf,kf,rough,r1,r2,D1,D2,k_al,alpha_e,ve,ke,Be,Te,Tf,eps_a,eps_s,verbose)
%Perform the heat transfer analysis on our parabolic trough model to
%evaluate losses, receiver efficiency, absorber temperature, ...

g = 9.81; sig = 5.67*1e-8;
%% Calculate dimensionless numbers for convection
%Probably want to treat everything as Qdot/L instead of Qdot

%Dimensionless numbers of HTF
Re_f = (4*mdot)/(muf*pi*D1);
Pr_f = (cpf*muf)/kf;

if Re_f < 2300
    if verbose
        disp('Laminar flow inside pipe')
    end
    %for laminar flow with constant wall flux
    Nu_f = 4.364;
else
    if verbose
        disp('Turbulent flow inside pipe')
    end
    %Haaland's explicit correlation, valid 4000<Re_f<1e8 and rough/D<0.05
    if (Re_f<4000) || (rough/D1 > 0.05)
        if verbose
            disp('Darcy correlation may not be valid for these parameters')
        end
    end
    fdarcy = (1.8*log10(6.9/Re_f + (rough/(3.7*D1))^(1.11)))^(-2);
    %Gnielinski Correlation for turbulent flow
    Nu_f = ((fdarcy/8)*(Re_f-1000)*Pr_f)/(1+12.7*(fdarcy/8)^(1/2)*(Pr_f^(2/3)-1));
end

%Calculate external absorber temperature in order to calculate Nu_e
R_cond = log(r2/r1)/(2*pi*k_al); %R_cond = log(r2/r1)/(2*pi*k_al*L);
R_conv_f = 1/(Nu_f*kf*pi); %R_conv_f = 1/(Nu_f*kf*pi*L);
Ta = Tf + (R_cond+R_conv_f)*QdotS; %I think there is something wrong here

%Dimensionless numbers of air
Pr_e = 0.694; %direct from Yunus&Cengel
Ra_e = (g*Be*(Ta-Te)*D2^3)/(alpha_e*ve);

Nu_e = (0.6 + 0.387*(Ra_e/(1+(0.559/Pr_e)^(9/16))^(16/9))^(1/6))^2; %natural convection

%% Calculate heat losses

R_conv_e = 1/(Nu_e*ke*pi); %R_conv_e = 1/(Nu_e*ke*pi*L);
Qdot_loss_conv = (Ta-Te)/R_conv_e;

Ts = Te-20;
Qdot_loss_rad = pi*D2*sig*(eps_a*(Ta+273)^4 - eps_s*(Ts+273)^4);

%Qdot_loss = Qdot_loss_conv + Qdot_loss_rad;
Qdot_loss = Qdot_loss_rad;

rec_eff = 1 - Qdot_loss/QdotS;

%Qdot_balance = QdotS - Qdot_loss; %redundant, can calculate from QdotS*rec_eff

if verbose
    message = ['Incoming Solar Radiation:', num2str(QdotS),' W/m, Heat Losses:',num2str(Qdot_loss),' W/m'];
    disp(message)
end
    
end

