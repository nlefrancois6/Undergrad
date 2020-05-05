function [pixelGrid] = rayTracingImage(pixels, LX, LY, LZ, NP, Temp, Tmax, rho, rmax)
%Take a 2D RGB picture of a 3D smoke field with a given temperature and density
%field

%Set parameters
g = 0.7;
alb = 0.6;
cExt = 1;
N = 10000;
sourceBright = 1;
CLight = [1 1 1];
hitTol = 5;
stepSize = 0.02;
focusL = -LX/8;

xWalls = [0 0 0]./256; yWalls = [30 55 10]./256; floor = [30 20 40]./256; ceiling = [0 0 0]./256;
walls = [xWalls yWalls floor ceiling];

[~, LGrid, CGrid, dx] = ray_Tracing(LX, LY, LZ, NP, Temp, Tmax, rho, rmax, g, alb, cExt, N, sourceBright, hitTol, stepSize, walls);

[pixelGrid] = lensCapturingImage(LGrid, CGrid, rho, LX, LY, LZ, dx, stepSize, focusL, pixels, walls, CLight);

end

