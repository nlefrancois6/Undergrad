# This file reimplements gmsh/tutorial/t5.geo in Python.

import gmsh
import math



gmsh.initialize()
gmsh.option.setNumber("General.Terminal", 1)

model = gmsh.model
factory = model.geo

model.add("t5")


lcar1 = 0.3

#addPoint(vertex, mesh density scale = constant, start index)
factory.addPoint(0,0,0, lcar1, 11)
factory.addPoint(0,1,0, lcar1, 12)
factory.addPoint(1,1,0, lcar1, 13)
factory.addPoint(0,0,1, lcar1, 14)
factory.addPoint(0,1,1, lcar1, 15)
factory.addPoint(1,1,1, lcar1, 16)
factory.addPoint(1,0,1, lcar1, 17)
factory.addPoint(1,0,0, lcar1, 18)

#addLine(vertex 1, vertex 2, start index)
factory.addLine(11,12,1);  factory.addLine(12,13,2);
factory.addLine(13,18,3);  factory.addLine(18,11,4);
factory.addLine(18,17,5);  factory.addLine(16,13,6);
factory.addLine(12,15,7);  factory.addLine(14,11,8);
factory.addLine(17,16,9);  factory.addLine(16,15,10);
factory.addLine(15,14,11);  factory.addLine(14,17,12);

#Adds faces (2 lines coupled here) 
# line1 is : addCurveLoop(edgeIndices[], indexOfFace) # this is just a loop
# line 2: addPlaneSurface(indexOfFace, indexOfSU2Face) # This is a fully defined face
factory.addCurveLoop([1,2,3,4], 21)
factory.addPlaneSurface([21], 31)
factory.addCurveLoop([5,9,6,3], 22)
factory.addPlaneSurface([22], 32)
factory.addCurveLoop([12,9,10,11], 23)
factory.addPlaneSurface([23], 33)
factory.addCurveLoop([-2,7,-10,6], 24)
factory.addPlaneSurface([24], 34)
factory.addCurveLoop([1,7,11,8], 25)
factory.addPlaneSurface([25], 35)
factory.addCurveLoop([4,-8,12,-5], 26)
factory.addPlaneSurface([26], 36)



shells = []

# When the tag is not specified, a new one is automatically provided
sl = factory.addSurfaceLoop([31,32,33,34,35,36])
shells.append(sl)
"""
def cheeseHole(x, y, z, r, lc, shells):
    p1 = factory.addPoint(x,  y,  z,   lc)
    p2 = factory.addPoint(x+r,y,  z,   lc)
    p3 = factory.addPoint(x,  y+r,z,   lc)
    p4 = factory.addPoint(x,  y,  z+r, lc)
    p5 = factory.addPoint(x-r,y,  z,   lc)
    p6 = factory.addPoint(x,  y-r,z,   lc)
    p7 = factory.addPoint(x,  y,  z-r, lc)

    c1 = factory.addCircleArc(p2,p1,p7)
    c2 = factory.addCircleArc(p7,p1,p5)
    c3 = factory.addCircleArc(p5,p1,p4)
    c4 = factory.addCircleArc(p4,p1,p2)
    c5 = factory.addCircleArc(p2,p1,p3)
    c6 = factory.addCircleArc(p3,p1,p5)
    c7 = factory.addCircleArc(p5,p1,p6)
    c8 = factory.addCircleArc(p6,p1,p2)
    c9 = factory.addCircleArc(p7,p1,p3)
    c10 = factory.addCircleArc(p3,p1,p4)
    c11 = factory.addCircleArc(p4,p1,p6)
    c12 = factory.addCircleArc(p6,p1,p7)

    l1 = factory.addCurveLoop([c5,c10,c4])
    l2 = factory.addCurveLoop([c9,-c5,c1])
    l3 = factory.addCurveLoop([c12,-c8,-c1])
    l4 = factory.addCurveLoop([c8,-c4,c11])
    l5 = factory.addCurveLoop([-c10,c6,c3])
    l6 = factory.addCurveLoop([-c11,-c3,c7])
    l7 = factory.addCurveLoop([-c2,-c7,-c12])
    l8 = factory.addCurveLoop([-c6,-c9,c2])

    s1 = factory.addSurfaceFilling([l1])
    s2 = factory.addSurfaceFilling([l2])
    s3 = factory.addSurfaceFilling([l3])
    s4 = factory.addSurfaceFilling([l4])
    s5 = factory.addSurfaceFilling([l5])
    s6 = factory.addSurfaceFilling([l6])
    s7 = factory.addSurfaceFilling([l7])
    s8 = factory.addSurfaceFilling([l8])

    slEarth = factory.addSurfaceLoop([s1, s2, s3, s4, s5, s6, s7, s8])
    v = factory.addVolume([slEarth])
    shells.append(slEarth)
    return slEarth

x= 0.5; y= 0.5; z= 0.5; r = 0.1;
slEarth = cheeseHole(x, y, z, r, lcar1, shells)
#model.addPhysicalGroup(3, [v], 11)

model.addPhysicalGroup(2, [slEarth], 3)
model.setPhysicalName(2,3,"Earth Surf")
"""

"""
x = 0; y = 0.75; z = 0; r = 0.09
for t in range(1, 1):
    x += 0.166
    z += 0.166
    v = cheeseHole(x, y, z, r, lcar3, shells)
    model.addPhysicalGroup(3, [v], t)
"""
factory.addVolume(shells, 40)

model.addPhysicalGroup(2, [31,32,33,34,35,36], 1)
model.setPhysicalName(2,1,"Outer Atmos")
model.addPhysicalGroup(3, [40], 2)


factory.synchronize()

model.mesh.generate(3)
gmsh.write("squBox.msh")

gmsh.finalize()
