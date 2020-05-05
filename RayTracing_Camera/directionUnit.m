function [ux, uy, uz] = directionUnit(rx, ry, rz, sx, sy, sz)
%Define the three components of the directional unit vector towards the
%light source

vx = sx - rx; vy = sy - ry; vz = sz - rz;
directionDist = (vx.^2 + vy.^2 + vz.^2).^(0.5);

ux = vx./directionDist; uy = vy./directionDist; uz = vz./directionDist;


end

