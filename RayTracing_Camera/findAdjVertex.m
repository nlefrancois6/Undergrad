function [ivx, ivy, ivz, rvx, rvy, rvz] = findAdjVertex(rx, ry, rz, dx)
%Take as input the actual ray coordinates, and round to the nearest vertex
%coordinate. Return both position (r) and index (i) of the vertex.

ivx = rx/dx; ivy = ry/dx; ivz = rz/dx;
ivx = round(ivx) + 1; ivy = round(ivy) + 1; ivz = round(ivz) + 1;

rvx = ivx*dx; rvy = ivy*dx; rvz = ivz*dx;

end

