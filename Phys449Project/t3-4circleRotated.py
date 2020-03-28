# This files reimplements gmsh/tutorial/t3.geo in Python.

import gmsh
import math

model = gmsh.model
factory = model.geo

gmsh.initialize()
gmsh.option.setNumber("General.Terminal", 1)

model.add("t3-4")

"""
# Copied from t1.py...
lc = 1e-2
factory.addPoint(0, 0, 0, lc, 1)
factory.addPoint(.1, 0,  0, lc, 2)
factory.addPoint(.1, .3, 0, lc, 3)
factory.addPoint(0, .3, 0, lc, 4)
factory.addLine(1, 2, 1)
factory.addLine(3, 2, 2)
factory.addLine(3, 4, 3)
factory.addLine(4, 1, 4)
factory.addCurveLoop([4, 1, -2, 3], 1)
factory.addPlaneSurface([1], 1)
model.addPhysicalGroup(0, [1, 2], 1)
model.addPhysicalGroup(1, [1, 2], 2)
model.addPhysicalGroup(2, [1], 6)
model.setPhysicalName(2, 6, "My surface")
# ...end of copy
"""

lc = 1e-2
factory.addPoint(0, 0, 0, lc, 1)
factory.addPoint(.1, 0,  0, lc, 2)
factory.addPoint(.2, 0, 0, lc, 3)
factory.addCircleArc(1, 2, 3, 1)
factory.addLine(1, 3, 2)

#Hole
factory.addPoint(0.05, 0, 0, lc, 4)
factory.addPoint(.1, 0,  0, lc, 5)
factory.addPoint(.15, 0, 0, lc, 6)
factory.addCircleArc(4, 5, 6, 3)
factory.addLine(1, 3, 4)

factory.addCurveLoop([1, -2], 1)
factory.addPlaneSurface([1], 1)

factory.addCurveLoop([3, -2], 2)
factory.addPlaneSurface([2], 2)

model.addPhysicalGroup(2, [2], 6)

h = 0.1
angle = 45.

ov = factory.extrude([(2,1)], 0, 0, 0.001, [1,1], [0.5,1])
ov = factory.revolve([(2,1)], 0,0,0, 1,0,0, -2*math.pi/1.0001, [10], [], True)
"""
h = 0.1
angle = 90.

# Extruding the mesh in addition to the geometry works as in .geo files: the
# number of elements for each layer and the (end) height of each layer are
# specified in two vectors.
ov = factory.extrude([(2,1)], 0, 0, 0.001, [1,2], [0.5,1])

#/ Rotational and twisted extrusions are available as well with the built-in CAD
# kernel. The last (optional) argument for the Extrude/Revolve/Twist commands
# specified whether the extruded mesh should be recombined or not.
ov = factory.revolve([(1,2)], -0.1,0,0.1, 0,1,0, -2*math.pi/1.0001, [50], [], True)
#ov = factory.twist([(2,50)], 0,0.15,0.25, -2*h,0,0, 1,0,0, angle*math.pi/180.,
                   #[10], [], True)

model.addPhysicalGroup(3, [1, 2, ov[1][1]], 101)
"""
model.addPhysicalGroup(3, [1, 2, ov[1][1]], 1)

factory.synchronize()
model.mesh.generate(3)
gmsh.write("t3-4.msh")
gmsh.finalize()