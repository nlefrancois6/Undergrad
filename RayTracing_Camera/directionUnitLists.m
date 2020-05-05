function [u] = directionUnitLists(r, s)
%Define the three components of the directional unit vector towards the
%light source

v = s - r;
directionDist = (sum((v.^2))^(0.5));

u = v./directionDist;


end

