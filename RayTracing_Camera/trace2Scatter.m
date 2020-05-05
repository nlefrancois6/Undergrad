function [rx, ry, rz, theta, phi, LGrid, CGrid, TRay, hits] = trace2Scatter(LX, LY, ~, rx, ry, rz, LGrid, CGrid, IGrid, stepSize, TVox, phi, theta, TRay, alb, sourceBright, hits, dx, lightSource, walls)
%Find the direct illumination for each vertex of our cubic grid by tracing
%a ray to the source and attenuate exponentially as a function of density
%at a fixed interval that scales with stepSize


%March one step and update the ray transparency
pathLength = stepSize*10*rand;
[ux, uy, uz] = sph2cartUnitVector(theta, phi);
rx = rx + ux*pathLength; ry = ry + uy*pathLength; rz = rz + uz*pathLength;
%disp(rz)

%If we hit a wall, reflect and move the position through the bounce since
%we don't need to update our L, C, or TRay at the wall
%will likely update 'handleWallBounce' to eventually just be 'handleBounce' and
%be able to also handle objects
[rx, ry, rz, ~, ~, ~, theta, phi, hits, rayColour] = handleWallBounce(LX, LY, rx, ry, rz, ux, uy, uz, theta, phi, hits, walls);

 
if rz < lightSource(3)
    %Round to nearest vertex to get location and index position
    [ivx, ivy, ivz, ~, ~, ~] = findAdjVertex(rx, ry, rz, dx);
    %Need to decide if i want to use rx or rvx for TVox position, but we must
    %use ivx for accessing I, L, and C
    %If we want to use the actual ray position for TVox and not the rounded
    %position, we'll need to interpolate since rho will be given on a set
    %grid sample for each frame.
    %indexes = [ivx, ivy, ivz, rx, ry, rz];
    %disp(indexes)
    LGrid(ivx, ivy, ivz) = alb*sourceBright*(1-TVox(ivx, ivy, ivz))*TRay + LGrid(ivx, ivy, ivz);
    CGrid(ivx, ivy, ivz, 1) = (1-TVox(ivx, ivy, ivz))*TRay*IGrid(ivx, ivy, ivz).*rayColour(1) + CGrid(ivx, ivy, ivz, 1);
    CGrid(ivx, ivy, ivz, 2) = (1-TVox(ivx, ivy, ivz))*TRay*IGrid(ivx, ivy, ivz).*rayColour(2) + CGrid(ivx, ivy, ivz, 2);
    CGrid(ivx, ivy, ivz, 3) = (1-TVox(ivx, ivy, ivz))*TRay*IGrid(ivx, ivy, ivz).*rayColour(3) + CGrid(ivx, ivy, ivz, 3);
    TRay = TRay*TVox(ivx, ivy, ivz);
end

end

