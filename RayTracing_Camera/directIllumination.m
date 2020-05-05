function [IGrid] = directIllumination(lightSource, TVox, rho, rmax, sxp, syp, szp, xLen, yLen, zLen, dx, stepSize)
%Trace the direct illumination of each pt with non-zero density and return
%the resultant 3D grid

%Initialize the grid for storing non-zero density coordinates
denGrid = findDensePts(rho, rmax);

%Trace ray to source for each non-zero density pt
IGrid = trace2Source(xLen, yLen, zLen, sxp, syp, szp, dx, denGrid, lightSource, stepSize, TVox);

end

