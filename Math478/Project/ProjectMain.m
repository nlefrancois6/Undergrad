close all
%Set up the domain and x&y nodes
LX = 1;
LY = 1;

NP = 16;
xLen = LX*NP+1; yLen = LY*NP+1;
sxp = linspace(0, LX, xLen); syp = linspace(0, LY, yLen);

%Def rho ICs
%rho0 = @(x,y) (x + y);
rho = zeros(xLen, yLen);

for i=1:xLen
    for j=1:yLen
        %rho(i,j) = rho0(sxp(i), syp(j));
        rho(i,j) = sin(2*pi/LX.*sxp(i)).*sin(1*pi/LY.*syp(j));
    end
end

surf(rho)


