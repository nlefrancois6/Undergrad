function [pixelGrid] = takePicture(uGrid, LGrid, CGrid, rho, pixels, LX, LY, LZ, Yc, Zc, stepSize, dx, walls, CLight)
%Trace the ray from each pixel in the uGrid(i,j,:) direction and assign the
%resultant colour value to pixel (i,j)

pixelGrid = zeros(pixels, pixels, 3);
opacityGrid = zeros(pixels, pixels, 1);
pixelWalls = zeros(pixels, pixels, 3);
pixelLGrid = zeros(pixels, pixels, 1);
pixelCGrid = zeros(pixels, pixels, 3);

%ux = uGrid(:,:,1); uy = uGrid(:,:,2); uz = uGrid(:,:,3);
%rx = 0; ry = Yc; rz = Zc;
%[pixelOpacity, pixelWall, pixelL, pixelC] = tracePixel(ux, uy, uz, rx, ry, rz, dx, LGrid, CGrid, rho, LX, LY, LZ, stepSize, walls);


for i=1:pixels
    for j=1:pixels
        ux = uGrid(i,j,1); uy = uGrid(i,j,2); uz = uGrid(i,j,3);
        rx = 0; ry = Yc(j); rz = Zc(i);
        [pixelOpacity, pixelWall, pixelL, pixelC] = tracePixel(ux, uy, uz, rx, ry, rz, dx, LGrid, CGrid, rho, LX, LY, LZ, stepSize, walls);
        opacityGrid(i,j,1) = pixelOpacity;
        pixelWalls(i,j,:) = pixelWall;
        pixelLGrid(i,j,1) = pixelL;
        pixelCGrid(i,j,1) = pixelC(1); pixelCGrid(i,j,2) = pixelC(2); pixelCGrid(i,j,3) = pixelC(3);
    end
end


%{
[i,j]=meshgrid(1:pixels,1:pixels);
ux = uGrid(i,j,1); uy = uGrid(i,j,2); uz = uGrid(i,j,3);
rx = 0; ry = Yc(j); rz = Zc(i);
[pixelOpacity, pixelWall, pixelL, pixelC] = tracePixel(ux, uy, uz, rx, ry, rz, dx, LGrid, CGrid, rho, LX, LY, LZ, stepSize, walls);
opacityGrid(i,j,1) = pixelOpacity;
pixelWalls(i,j,:) = pixelWall;
pixelLGrid(i,j,1) = pixelL;
pixelCGrid(i,j,1) = pixelC(1); pixelCGrid(i,j,2) = pixelC(2); pixelCGrid(i,j,3) = pixelC(3);
%}

%Could use sourceBright to scale pixelLGrid instead of having the
%coefficient controlled from here
opacityGrid = normGrid(opacityGrid);
pixelLGrid = 0.25*normGrid(pixelLGrid);
pixelCGrid = 0.07*normGrid(pixelCGrid);
SWBright = 1.5;
%{
normOpacity = opacityGrid - min(opacityGrid(:));
opacityGrid = normOpacity ./ max(normOpacity(:));


%pixelGrid(:,:,1) = 0.6.*opacityGrid + pixelWalls(1).*(1-opacityGrid) + 1*pixelLGrid;
%pixelGrid(:,:,2) = 0.5.*opacityGrid + pixelWalls(2).*(1-opacityGrid) + 1*pixelLGrid;
%pixelGrid(:,:,3) = 0.4.*opacityGrid + pixelWalls(3).*(1-opacityGrid) + 1*pixelLGrid;
%}

%should be able to get rid of the very big/small coefficients for L and C
%grids by normalizing them, not sure if there's an efficient/clean way to
%normalize the RGB values
pixelGrid(:,:,1) = SWBright*(0.6.*opacityGrid + pixelWalls(:,:,1).*(1-opacityGrid)) + CLight(1)*pixelLGrid + pixelCGrid(:,:,1);
pixelGrid(:,:,2) = SWBright*(0.5.*opacityGrid + pixelWalls(:,:,2).*(1-opacityGrid)) + CLight(2)*pixelLGrid + pixelCGrid(:,:,2);
pixelGrid(:,:,3) = SWBright*(0.4.*opacityGrid + pixelWalls(:,:,3).*(1-opacityGrid)) + CLight(3)*pixelLGrid + pixelCGrid(:,:,1);

%normpix = pixelGrid - min(pixelGrid(:));
%pixelGrid = normpix ./ max(normpix(:));
pixelGrid = normGrid(pixelGrid);
end

