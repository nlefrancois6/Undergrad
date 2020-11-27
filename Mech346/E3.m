Qvtot = 1.5*1e9; N = 30000; L = 3;
dco = 0.01; tc = 0.0005;
r1 = (dco - 2*tc)/2; r2 = dco/2;
Tbi = 400; mdot = 1440; g = 9.81;
ch = 5200; rhoh = 4.81; muh = 2.8*1e-5; kh = 0.22;
kf = 0.7; cf = 950; rhof = 2350;
cs = 500; rhos = 7700; ks = 19;

%A)
Qrod_L = Qvtot/(N*L);
md_r = mdot/N;

dT = Qvtot/(mdot*ch); Tbo = Tbi + dT;

%B)
dp_tot = 120*1e3;
dp_g = rhoh*g*L;
dp_f = dp_tot - dp_g;

LHS = 2*dp_f/(L*rhoh);

Ac = @(s) s^2 - pi*(dco/2)^2; 
P = pi*dco; 
Dh = @(s) 4*Ac(s)/P;
U = @(s) md_r/(rhoh*Ac(s));
Re = @(s) rhoh*U(s)*L/muh;
fD = @(s) (1.8*log10(6.9/Re(s)))^(-2);

RHS = @(s) fD(s)*U(s)^2/Dh(s);

%pitch = 0.2370775;
pitch = 0.0120378;
diff = LHS - RHS(pitch);

%C)
Qvslow = 5*1e8;
Qrod_L = Qvslow/(N*L);
qw = Qrod_L/(P);

dT = Qvslow/(mdot*ch); Tbo_slow = Tbi + dT;

%dTest = 460-400; %max possible value if some of the salt is frozen (mp 460)
%B = 1/400;
%Gr = g*B*dTest*L^3/(muh/rhoh)^2;
%RHS = 35*L/Gr^0.25

Pr = ch*muh/kh; 
ReL = Re(pitch); Uh = U(pitch); DHh = Dh(pitch); fDd = fD(pitch);
Rez = @(z) rhoh*Uh*z/muh;
Nu = (fDd/8)*(ReL-1000)*Pr/(1+12.7*sqrt(fDd/8)*(Pr^(2/3)-1));
h = (dp_f*DHh*2/(L*Uh))*ch/(8*Pr^(2/3));

%Gnielinski
%Tw = @(z) qw*z/(Nu*kh) + Tbi + Qvslow/(mdot*ch)*(z/L);
%Reyn-Colb
Tw = @(z) qw/h + Tbi + Qvslow/(mdot*ch)*(z/L);
%Rf = @(r) (r1 - r)/(kf*2*pi*L*r1);
%Rs = log(r2/r1)/(2*pi*L*ks);

T = @(r,z) Qvslow/(2*N*pi*L)*((r1-r)^2/r1^2)*((r-r1)/(kf*r1) + log(r2/r1)/ks) + Tw(z);

%D)
Tm = 460;
%Twm = @(z, Rm) Tm - Qvslow/(2*N*pi*L)*(r^2/r1^2)*((r-r1)/(kf*r1) + log(r2/r1)/ks)
Rm_store = zeros(31,1);
i = 1;
zpts = 0:0.1:L;
for zp=0:0.1:L
    Tfunc = @(r) Qvslow/(2*N*pi*L)*((r1-r)^2/r1^2)*((r-r1)/(kf*r1) + log(r2/r1)/ks) + Tw(zp) - Tm;
    Rm = fzero(Tfunc, 0.5*r1);
    Rm_store(i,1) = Rm;
    i = 1 + 1;
end


plot(zpts, Rm_store/r1);
xlabel('Height z (m)');
ylabel('Non-Dimensional Molten Fuel Radius Rm/r1 (m)')
title('Non-Dimensional Molten Fuel Radius as a Function of Height')
