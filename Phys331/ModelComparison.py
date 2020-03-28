#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 30 16:31:37 2019

@author: noahlefrancois
"""

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


#Load and prepare data for 5c trajectory
c5X = np.loadtxt('5DcX.csv', delimiter = ',', unpack = True)
c5Y = np.loadtxt('5DcY.csv', delimiter = ',', unpack = True)
c5Z = np.loadtxt('5DcZ.csv', delimiter = ',', unpack = True)

time = c5X[0]
X5c = c5X[1]
Y5c = c5Y[1]
Z5c = c5Z[1]
X5fc = [X5c[len(time)-1]]
Y5fc = [Y5c[len(time)-1]]
Z5fc = [Z5c[len(time)-1]]



#Load and prepare data for 4c trajectory
c4X = np.loadtxt('4DcX.csv', delimiter = ',', unpack = True)
c4Y = np.loadtxt('4DcY.csv', delimiter = ',', unpack = True)
c4Z = np.loadtxt('4DcZ.csv', delimiter = ',', unpack = True)

time = c4X[0]
X4c = c4X[1]
Y4c = c4Y[1]
Z4c = c4Z[1]
X4fc = [X4c[len(time)-1]]
Y4fc = [Y4c[len(time)-1]]
Z4fc = [Z4c[len(time)-1]]


"""
#Load and prepare data for 3b trajectory
b3X = np.loadtxt('3DbX.csv', delimiter = ',', unpack = True)
b3Y = np.loadtxt('3DbY.csv', delimiter = ',', unpack = True)
b3Z = np.loadtxt('3DbZ.csv', delimiter = ',', unpack = True)

time = b3X[0]
X3b = b3X[1]
Y3b = b3Y[1]
Z3b = b3Z[1]
X3fb = [X3b[len(time)-1]]
Y3fb = [Y3b[len(time)-1]]
Z3fb = [Z3b[len(time)-1]]
"""

"""
#Load and prepare data for 3c trajectory
c3X = np.loadtxt('3DcX.csv', delimiter = ',', unpack = True)
c3Y = np.loadtxt('3DcY.csv', delimiter = ',', unpack = True)
c3Z = np.loadtxt('3DcZ.csv', delimiter = ',', unpack = True)

time = c3X[0]
X3c = c3X[1]
Y3c = c3Y[1]
Z3c = c3Z[1]
X3fc = [X3c[len(time)-1]]
Y3fc = [Y3c[len(time)-1]]
Z3fc = [Z3c[len(time)-1]]
"""
"""
#Load and prepare data for 5d trajectory
d5X = np.loadtxt('5DdX.csv', delimiter = ',', unpack = True)
d5Y = np.loadtxt('5DdY.csv', delimiter = ',', unpack = True)
d5Z = np.loadtxt('5DdZ.csv', delimiter = ',', unpack = True)

time = d5X[0]
X5d = d5X[1]
Y5d = d5Y[1]
Z5d = d5Z[1]
X5fd = [X5d[len(time)-1]]
Y5fd = [Y5d[len(time)-1]]
Z5fd = [Z5d[len(time)-1]]
"""


f1 = plt.figure()
ax = f1.gca(projection='3d')
ax.plot(X5c, Y5c, Z5c, label='5D')
ax.plot(X5fc, Y5fc, Z5fc, 'o')

ax.plot(X4c, Y4c, Z4c, label='4D')
ax.plot(X4fc, Y4fc, Z4fc, 'o')

#ax.plot(X3b, Y3b, Z3b, label='3D')
#ax.plot(X3fb, Y3fb, Z3fb, 'o')

#ax.plot(X3c, Y3c, Z3c, label='3D')
#ax.plot(X3fc, Y3fc, Z3fc, 'o')

#ax.plot(X5d,Y5d,Z5d, label='5D')
#ax.plot(X5fd, Y5fd, Z5fd, 'ro')

ax.legend()
plt.xlabel('X')
plt.ylabel('Y')
