// Gmsh project created on Fri Mar 27 09:08:28 2020
SetFactory("OpenCASCADE");
//+
Sphere(1) = {0, 0, 0, 5, -Pi/2, Pi/2, 2*Pi};
//+
Sphere(2) = {0, 0, 0, 10, -Pi/2, Pi/2, 2*Pi};
//+
BooleanDifference{ Volume{2}; Delete; }{ Volume{1}; Delete; }
