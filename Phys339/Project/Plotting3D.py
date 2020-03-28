#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr  4 13:32:40 2019

@author: noahlefrancois
"""

import os
import serial
import time as t
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter

os.chdir('/Users/maureenpollard/Documents/School/Phys339/Project/Important stuff/cross')
image = np.loadtxt('2D_surf_cross_quartCmrez_d10cm_comb1.txt', delimiter = ',', unpack = True)
#print(image)
"""
#Input coordinates manually
X = 
Y = 
Z = 
"""
N = len(image)

#Input expected target distance, background wall distance, and distance tolerance for binary conversion
targetDist = 10.0
wallDist = 65.0
tolDist = 10.0
Zbinary = np.empty([N])
X = np.zeros([N])
Y = np.zeros([N])



#Convert 3D to 2D, hit==1 miss==0
"""
for i in range(N):
    for j in range(len(image[0])):
        #to simplify, change condition to NOTTARGET and get rid of else
        if image[i,j]-targetDist < tolDist and image[i,j]-targetDist > -tolDist:
            image[i,j] = image[i,j]
            X[i] = i
            Y[i] = j
    
        elif image[i,j]-wallDist < tolDist and image[i,j]-wallDist > -tolDist:
            image[i,j] = image[i,j]
            X[i] = i
            Y[i] = j
        
        else:
            image[i,j] = None
            X[i] = i
            Y[i] = j
  """  
"""
if image[i,j]-targetDist < tolDist and image[i,j]-targetDist > -tolDist:
            Zbinary[i] = image[i,j]
            X[i] = i
            Y[i] = j
        if image[i,j]-wallDist < tolDist and image[i,j]-wallDist > -tolDist:
            Zbinary[i] = 0
            X[i] = i
            Y[i] = j
"""

#
#
#Plot the surface
xyLim = [70,70]
lev = np.arange(0,30,4)
#norml = matplotlib.colors.BoundaryNorm(lev, 256)


fig = plt.figure()
ax = fig.gca(projection='3d')
# Plot the surface.
xdat,ydat = np.meshgrid(range(xyLim[0]),range(xyLim[1]))
object = ax.plot_surface(xdat, ydat, image, cmap=cm.jet,linewidth=0, norm = matplotlib.colors.BoundaryNorm(lev, 256), antialiased=False, shade=False)

# Customize the z axis.
ax.set_zlim(0, 70)
ax.set_xlim(0,70)
ax.set_ylim(0,70)
plt.xlabel('X')
plt.ylabel('Y')
#ax.zaxis.set_major_locator(LinearLocator(10))
#ax.zaxis.set_major_formatter(FormatStrFormatter('%.02f'))

# Add a color bar which maps values to colors.
fig.colorbar(object, shrink=0.5, aspect=5)

#
#
#

"""
#Print 3D Results
f1 = plt.figure()
ax = f1.gca(projection='3d')
ax.plot(X, Y, image, 'o')
#ax.plot(X, Y, Z,'o')
plt.xlabel('X')
plt.ylabel('Y')
plt.title('3D Image')
"""

"""
#Print 2D Results
f2= plt.figure()
plt.plot(X, Y,'o')
plt.xlabel('X')
plt.ylabel('Y')
plt.title('2D Image')
"""

