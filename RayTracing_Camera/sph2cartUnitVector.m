function [ux, uy, uz] = sph2cartUnitVector(theta, phi)
%Convert a spherical vector of [theta, phi] to the corresponding cartesian
%direction vector

ux = sin(phi).*cos(theta);
uy = sin(phi).*sin(theta);
uz = cos(phi);

end

