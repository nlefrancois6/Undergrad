# This file reimplements gmsh/tutorial/t1.geo in Python.

# For all the elementary explanations about the general philosphy of entities in
# Gmsh, see the comments in the .geo file. Comments here focus on the specifics
# of the Python API.

# The API is entirely defined in the gmsh module
import gmsh
import numpy as np

# Before using any functions in the Python API, Gmsh must be initialized.
gmsh.initialize()

# By default Gmsh will not print out any messages: in order to output messages
# on the terminal, just set the standard Gmsh option "General.Terminal" (same
# format and meaning as in .geo files):
gmsh.option.setNumber("General.Terminal", 1)

# Next we add a new model named "t1" (if gmsh.model.add() is not called a new
# unnamed model will be created on the fly, if necessary):
gmsh.model.add("t1")

# The Python API provides direct access to the internal CAD kernels. The
# built-in CAD kernel was used in t1.geo: the corresponding API functions have
# the "gmsh.model.geo" prefix. To create geometrical points with the built-in
# CAD kernel, one thus uses gmsh.model.geo.addPoint():
#
# - the first 3 arguments are the point coordinates (x, y, z)
#
# - the next (optional) argument is the target mesh size close to the point
#
# - the last (optional) argument is the point tag
layers = 50
dz = 0.005
corners = np.linspace(1,layers*4, layers*4, dtype=int)

lc = 1e-2

for i in range(layers):
    gmsh.model.geo.addPoint(0, 0, i*dz, lc, corners[i*4 + 0])
    gmsh.model.geo.addPoint(0.1, 0, i*dz, lc, corners[i*4 + 1])
    gmsh.model.geo.addPoint(0.1, 0.3, i*dz, lc, corners[i*4 + 2])
    gmsh.model.geo.addPoint(0, 0.3, i*dz, lc, corners[i*4 + 3])

# The API to create lines with the built-in kernel follows the same
# conventions: the first 2 arguments are point tags, the last (optional one)
# is the line tag.
    
lines = np.linspace(1,layers*8, layers*8, dtype=int)

for i in range(layers):
    gmsh.model.geo.addLine(corners[i*4 + 0], corners[i*4 + 1], lines[i*8 + 0])
    gmsh.model.geo.addLine(corners[i*4 + 2], corners[i*4 + 1], lines[i*8 + 1])
    gmsh.model.geo.addLine(corners[i*4 + 2], corners[i*4 + 3], lines[i*8 + 2])
    gmsh.model.geo.addLine(corners[i*4 + 3], corners[i*4 + 0], lines[i*8 + 3])
    if i>0:
        gmsh.model.geo.addLine(corners[i*4 + 0], corners[(i-1)*4 + 0], lines[i*8 + 4])
        gmsh.model.geo.addLine(corners[i*4 + 1], corners[(i-1)*4 + 1], lines[i*8 + 5])
        gmsh.model.geo.addLine(corners[i*4 + 2], corners[(i-1)*4 + 2], lines[i*8 + 6])
        gmsh.model.geo.addLine(corners[i*4 + 3], corners[(i-1)*4 + 3], lines[i*8 + 7])
        


# The philosophy to construct curve loops and surfaces is similar: the first
# argument is now a vector of integers.
loops = np.linspace(1,(5*layers)+1, (5*layers)+1, dtype=int)
surfs = np.linspace(1,(5*layers)+1, (5*layers)+1, dtype=int)

for i in range(layers):
    #horizontal layer
    gmsh.model.geo.addCurveLoop([lines[i*8 + 3], lines[i*8 + 0], -lines[i*8 + 1], lines[i*8 + 2]], loops[i*5 +0])
    gmsh.model.geo.addPlaneSurface([loops[i*5 + 0]], surfs[i*5 + 0])
    #sides of the layer cube
    if i>0:
        gmsh.model.geo.addCurveLoop([lines[i*8 + 4], lines[(i-1)*8 + 0], -lines[i*8 + 5], -lines[i*8 + 0]], loops[i*5 + 1])
        gmsh.model.geo.addPlaneSurface([loops[i*5 + 1]], surfs[i*5 + 1])
        gmsh.model.geo.addCurveLoop([lines[i*8 + 5], -lines[(i-1)*8 + 1], -lines[i*8 + 6], lines[i*8 + 1]], loops[i*5 + 2])
        gmsh.model.geo.addPlaneSurface([loops[i*5 + 2]], surfs[i*5 + 2])
        gmsh.model.geo.addCurveLoop([lines[i*8 + 6], lines[(i-1)*8 + 2], -lines[i*8 + 7], -lines[i*8 + 2]], loops[i*5 + 3])
        gmsh.model.geo.addPlaneSurface([loops[i*5 + 3]], surfs[i*5 + 3])
        gmsh.model.geo.addCurveLoop([lines[i*8 + 7], lines[(i-1)*8 + 3], -lines[i*8 + 4], -lines[i*8 + 3]], loops[i*5 + 4])
        gmsh.model.geo.addPlaneSurface([loops[i*5 + 4]], surfs[i*5 + 4])
    


# Physical groups are defined by providing the dimension of the group (0 for
# physical points, 1 for physical curves, 2 for physical surfaces and 3 for
# phsyical volumes) followed by a vector of entity tags. The last (optional)
# argument is the tag of the new group to create.
groups = np.linspace(1,layers*3, layers*3, dtype=int)

for i in range(layers):
    gmsh.model.addPhysicalGroup(0, [corners[i*4 + 0], corners[i*4 + 1]], groups[3*i + 0])
    gmsh.model.addPhysicalGroup(1, [lines[i*8 + 0], lines[i*8 + 1]], groups[3*i + 1])
    gmsh.model.addPhysicalGroup(2, [surfs[i*5 + 0], surfs[i*5 + 1], surfs[i*5 + 2], surfs[i*5 + 3], surfs[i*5 + 4]], groups[3*i + 2])




# Physical names are also defined by providing the dimension and tag of the
# entity.
for i in range(layers):
    gmsh.model.setPhysicalName(2, groups[3*i + 2], "Layer " + str(i+1))



# Before it can be meshed, the internal CAD representation must be synchronized
# with the Gmsh model, which will create the relevant Gmsh data structures. This
# is achieved by the gmsh.model.geo.synchronize() API call for the built-in CAD
# kernel. Synchronizations can be called at any time, but they involve a non
# trivial amount of processing; so while you could synchronize the internal CAD
# data after every CAD command, it is usually better to minimize the number of
# synchronization points.
gmsh.model.geo.synchronize()

# We can then generate a 2D mesh...
gmsh.model.mesh.generate(3)

# ... and save it to disk
gmsh.write("t1layers.msh")

# Remember that by default, if physical groups are defined, Gmsh will export in
# the output mesh file only those elements that belong to at least one physical
# group. To force Gmsh to save all elements, you can use
#
# gmsh.option.setNumber("Mesh.SaveAll", 1)

# This should be called at the end:
gmsh.finalize()
