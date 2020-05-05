function [IGrid, LGrid, CGrid, dx] = ray_Tracing(LX, LY, LZ, NP, Temp, tmax, rho, rmax, g, alb, cExt, N, sourceBright, hitTol, stepSize, walls)
%Take as input a 3x3 frame containing the temperature and density fields and
%return the 3x3 radiance and colour grids

xLen = LX*NP+1; yLen = LY*NP+1; zLen = LZ*NP+1;
sxp = linspace(0, LX, xLen); syp = linspace(0, LY, yLen); szp = linspace(0, LZ, zLen);

%myGrid = grid3D(LX*NP, LY*NP, LZ*NP, LX, LY, LZ);
%dx = myGrid.cellwidth(1,1);

dx = LX/NP; %dy = LY/NP; dz = LZ/NP

%Create array for discrete cumulative distribution function of
%Henyey-Greenstein phase function
%phase = @(angle) (1-g^2)/((1+g^2-2*g*cos(angle))^(3/2))
CDF = @(angle) ((1-g.^2)./2*g)*((1+g.^2-2.*g.*cos(angle)).^(-0.5)-(1+g).^(-1));
angles = (1:179);
cdfPhi = CDF(angles.*pi./180);
cdfTheta = CDF(angles.*pi./180);

TVox = exp(-cExt.*rho.*dx);

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
IGrid = directIllumination(lightSource, TVox, rho, rmax, sxp, syp, szp, xLen, yLen, zLen, dx, stepSize);

%Add in radiance due to temperature here
[IGrid] = incandescenceIllumination(Temp, tmax, IGrid);

[LGrid, CGrid] = diffuseScattering(N, alb, cdfPhi, cdfTheta, sourceBright, camPos, TVox, IGrid, hitTol, stepSize, lightSource, LX, LY, LZ, xLen, yLen, zLen, dx, walls);

end

