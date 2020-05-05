function [Yc, Zc] = cameraLens(LY, LZ, pixels)
%Take the wall dimensions for the (x=0) Y-Z plane, and create a grid
%representing the pixel locations of a camera lens with width = 0.25 the wall
%width

Ymin = LY/2 - LY/8; Ymax = LY/2 + LY/8;
Zmin = LZ/2 - LZ/8; Zmax = LZ/2 + LZ/8;

Yc = linspace(Ymin, Ymax, pixels);
Zc = linspace(Zmin, Zmax, pixels);

end

