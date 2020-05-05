function Ray_Tracing_test
%UNTITLED Summary of this function goes here


close all

LX = 1;
LY = 1;
LZ = 1;

NP = 16;
xLen = LX*NP+1; yLen = LY*NP+1; zLen = LZ*NP+1;
sxp = linspace(0, LX, xLen); syp = linspace(0, LY, yLen); szp = linspace(0, LZ, zLen);


myGrid = grid3D(LX*NP, LY*NP, LZ*NP, LX, LY, LZ);
dx = myGrid.cellwidth(1,1);

%%Generate density&temperature 
% set up mollifier
cutoff = @(z) (abs(z)<1);
moll = @(z) exp(-1./(1-(z.*cutoff(z)).^2)).*cutoff(z).*exp(1); % compact support in [-1,1]
mollR = @(s, R) moll(2*s./R);

gauss = @(x, y, z, sig) exp(-(x.^2 + y.^2 + z.^2)./(sig.^2))./(4*pi*sig.^2); % gaussian centered at 0


cosbump1D = @(s, width) cos(pi/2.*s./width).*mollR(s, pi*width/2);
cosbumpz = @(x, y, z, width) cosbump1D(z, width);
cosbumpcirc = @(x, y, z, width) cosbump1D(sqrt(x.^2 + y.^2 + z.^2), width);


Tmax = 1; 
Temp = @(x, y, z) Tmax.*cosbumpcirc(x-0.5, y-0.5, z-0.5, 0.25); 

rmax = 0.05;
rho = @(x, y, z) rmax*cosbumpz(x, y, z-0.5, 0.5);



%Set parameters
g = 0.7;
alb = 0.9;
cExt = 1;
N = 100;
sourceBright = 1;
hitTol = 5;
stepSize = 0.02;

%Create array for discrete cumulative distribution function of
%Henyey-Greenstein phase function
%phase = @(angle) (1-g^2)/((1+g^2-2*g*cos(angle))^(3/2))
CDF = @(angle) ((1-g.^2)./2*g)*((1+g.^2-2.*g.*cos(angle)).^(-0.5)-(1+g).^(-1));
angles = (1:179);
cdfPhi = CDF(angles.*pi./180);
cdfTheta = CDF(angles.*pi./180);

TVox = @(x, y, z) exp(-cExt*rho(x, y, z)*dx);

%Set light source & camera positions
cx = 0;
cy = LY/2;
cz = LZ/2;
camPos = [cx cy cz];
%for now light source will just be z = LZ (box w/open ceiling) for
%diffusion termination, but for direct illumination we assign a point
%source
lsx = LX/2;
lsy = LY/2;
lsz = LZ;
lightSource = [lsx lsy lsz];

%I needs to be a 3D grid with the illumination value at each vertex
IGrid = directIllumination(lightSource, TVox, rho, rmax, sxp, syp, szp, xLen, yLen, zLen, stepSize);


[LGrid, CGrid] = diffuseScattering(N, alb, cdfPhi, cdfTheta, sourceBright, camPos, TVox, IGrid, hitTol, stepSize, lightSource, LX, LY, LZ, xLen, yLen, zLen, dx);
IGrid;
LGrid;
CGrid;
[X,Y,Z] = ndgrid(1:size(LGrid,1), 1:size(LGrid,2), 1:size(LGrid,3));
pointsize = 30;
scatter3(X(:), Y(:), Z(:), pointsize, LGrid(:), 'filled');

end

