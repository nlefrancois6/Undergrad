function [pixelOpacity, pixelWall, pixelL, pixelC] = tracePixel(ux, uy, uz, rx, ry, rz, dx, LGrid, CGrid, rho, LX, LY, LZ, stepSize, walls)
%Follow the ray through each pixel and accumulate the opacity along the
%path, also return the wall that the ray hits at the end

pixelOpacity = 0;
pixelL = 0;
pixelC = [0 0 0];

%first step
rx = rx + ux.*stepSize; ry = ry + uy.*stepSize; rz = rz + uz.*stepSize;
[hit, wall] = checkWallHit(rx, ry, rz, LX, LY, LZ, walls);
                
while(hit == false)
    %March one step and update the ray transparency
    [ivx, ivy, ivz, ~, ~, ~] = findAdjVertex(rx, ry, rz, dx);
    pixelOpacity = pixelOpacity + rho(ivx, ivy, ivz);
    pixelL = pixelL + LGrid(ivx, ivy, ivz);
    pixelC(1) = pixelC(1) + CGrid(ivx, ivy, ivz, 1);
    pixelC(2) = pixelC(2) + CGrid(ivx, ivy, ivz, 2);
    pixelC(3) = pixelC(3) + CGrid(ivx, ivy, ivz, 3);
    rx = rx + ux.*stepSize; ry = ry + uy.*stepSize; rz = rz + uz.*stepSize;
    [hit, wall] = checkWallHit(rx, ry, rz, LX, LY, LZ, walls);
end

pixelWall = wall;

end

%{
pixelR = pixelR + 0.6*rho(ivx, ivy, ivz) + 0*LGrid(ivx, ivy, ivz);
    pixelG = pixelG + 0.5*rho(ivx, ivy, ivz) + 0*LGrid(ivx, ivy, ivz);
    pixelB = pixelB + 0.4*rho(ivx, ivy, ivz) + 0*LGrid(ivx, ivy, ivz);
%}