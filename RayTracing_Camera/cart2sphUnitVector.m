function [theta, phi] = cart2sphUnitVector(ux, uy, uz)
%Convert a cartesian vector of [x, y, z] to the corresponding spherical
%direction unit vector of [theta, phi]

ur = (ux.^2 + uy.^2 + uz.^2).^(0.5);
tanArg = uy./ux; cosArg = uz./ur;
theta = atan2d(uy, ux);
phi = acosd(cosArg);

end

