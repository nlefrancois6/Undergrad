function [uGrid] = trace2Focus(Yc, Zc, pixels, focusL, LY, LZ)
%For each pixel on the lens, find the direction vector at which a ray
%from the focal pt will exit the lens into the cube

uGrid = zeros(pixels, pixels, 3);
%[Y,Z] = meshgrid(Yc, Zc);

%{
[ux, uy, uz] = directionUnit(focusL, LY/2, LZ/2, 0, Yc, Zc);
%LHS is 256x256x3, RHS is 1x768. Need to reformat [u] as the three layers
%of my rectangle
uGrid(1:length(Zc), 1:length(Yc), :) = [ux uy uz];
%}



for y=1:pixels
    for z=1:pixels
        [ux, uy, uz] = directionUnit(focusL, LY/2, LZ/2, 0, Yc(y), Zc(z));
        uGrid(z, y, :) = [ux uy uz];
        %{
        [theta, phi] = cart2sphUnitVector(ux, uy, uz);
        thetaGrid(z, y) = theta;
        phiGrid(z, y) = phi;
        %}
    end
end

%{
%Unable to perform assignment because the size of the left side is 4096-by-4096-by-3 and
%the size of the right side is 64-by-192.
[y,z]=meshgrid(1:pixels,1:pixels);
[ux, uy, uz] = directionUnit(focusL, LY/2, LZ/2, 0, Yc(y), Zc(z));
uGrid(z, y, :) = [ux uy uz];
%}

end

