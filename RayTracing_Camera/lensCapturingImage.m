function [pixelGrid] = lensCapturingImage(LGrid, CGrid, rho, LX, LY, LZ, dx, stepSize, focusL, pixels, walls, CLight)
%Generate 2D RGB image by tracing rays from focal pt through lens into L and C
%grids defined inside the cube

%pixels = 8;
%focusL = -LX/2;

%Create a grid defined by the coordinates Yc and Zc which represents the
%location of each pixel on our lens
[Yc, Zc] = cameraLens(LY, LZ, pixels);

%Store the cartesian direction vector at each pixel for a ray drawn from the
%focal pt. Note that z is upside down when reading directly from the array
%values
[uGrid] = trace2Focus(Yc, Zc, pixels, focusL, LY, LZ);

%Accumulate [grids] along uGrid ray directions to form final 2-D picture
%need to find the accumulation formula and write the function takePicture
[pixelGrid] = takePicture(uGrid, LGrid, CGrid, rho, pixels, LX, LY, LZ, Yc, Zc, stepSize, dx, walls, CLight);

%{
TPlot = imagesc([Yc(1) Yc(end)], [Zc(1) Zc(end)], pixelGrid);

shading interp
colormap(TPlot.Parent, hot)
set(gca, 'YDir', 'normal');
grid off
title('Temperature')
%}

end

