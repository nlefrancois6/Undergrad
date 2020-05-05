function [rx, ry, rz, ux, uy, uz, theta, phi, hits, wallColour] = handleWallBounce(LX, LY, rx, ry, rz, ux, uy, uz, theta, phi, hits, walls)
%Check all possible wall collision conditions and bounce each of them by
%reversing the perpendicular direction component

%do i need to handle rx = 0, etc, or will it be fine? Boundary should be
%included in the domain so if rx = 0 it should be a point in the array
%at which we can compute our values
wallColour = [0 0 0];
%{
reflDepth = 0.3*rand(0.3);
while(reflDepth>0.5)
    reflDepth = 0.3*exprnd(0.3);
end
%}
reflDepth = 0.15;

if (rx > LX)
    ux = -ux;
    [theta, phi] = cart2sphUnitVector(ux, uy, uz);
    rx = 2*LX - (rx+reflDepth); %ry = ry + uy*pathLength; rz = rz + uz*pathLength;
    hits = hits + 1;
    wallColour = walls(1:3);
elseif (rx < 0)
    ux = -ux; %need to update phi and theta
    [theta, phi] = cart2sphUnitVector(ux, uy, uz);
    rx = -rx+reflDepth; %ry = ry + uy*pathLength; rz = rz + uz*pathLength;
    hits = hits + 1;
    wallColour = walls(1:3);
end
if (ry > LY)
    uy = -uy;
    [theta, phi] = cart2sphUnitVector(ux, uy, uz);
    ry = 2*LY - (ry+reflDepth); %rx = rx + ux*pathLength; rz = rz + uz*pathLength;
    hits = hits + 1;
    wallColour = walls(4:6);
elseif (ry < 0)
    uy = -uy;
    [theta, phi] = cart2sphUnitVector(ux, uy, uz);
    ry = -ry+reflDepth; %rx = rx + ux*pathLength; rz = rz + uz*pathLength;
    hits = hits + 1;
    wallColour = walls(4:6);
end
if (rz < 0)
    uz = -uz;
    [theta, phi] = cart2sphUnitVector(ux, uy, uz);
    rz = -rz+reflDepth; %rx = rx + ux*pathLength; ry = ry + uy*pathLength;
    hits = hits + 1;
    wallColour = walls(7:9);
end

end

