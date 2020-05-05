%Test the two direction unit vector versions

stepSize = 0.01;
r = [1 0 0]; s = [0 1 0];
[ux, uy, uz] = directionUnit(r(1), r(2), r(3), s(1), s(2), s(3));
[u] = directionUnitLists(r, s);
rx = r(1) + ux*stepSize; ry = r(2) + uy*stepSize; rz = r(3) + uz*stepSize;
r = r + u*stepSize;