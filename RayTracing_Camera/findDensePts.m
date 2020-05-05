function [denGrid] = findDensePts(rho, rmax)
%Find points with a non-zero density and return a boolean 3D array
%containing a 1 at all such points and zeros elsewhere

%denGrid = zeros(xLen, yLen, zLen);

%Find all pts with non-zero density
denGrid = rho > (0.05*rmax);

%{
for x=1:xLen
    for y=1:yLen
        for z=1:zLen
            if rho(x, y, z) > (0.05*rmax)
                %denGrid is a boolean table indicating presence of non-zero density
                denGrid(x, y, z) = 1;
                %Not sure if this is less efficient than just calling TVox
                %each time, but it probably is
                %TVoxGrid(x, y, z) = TVox(x,y,z)
            end
        end
    end
end
%}

end

