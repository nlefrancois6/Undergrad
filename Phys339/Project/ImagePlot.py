#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr  2 15:48:14 2019

@author: noahlefrancois
"""

import numpy as np
import matplotlib.pyplot as plt

#Input coordinates manually
X = np.array([41.21,43.82,46.79,47.01,48.95,50.83,52.44,54.0,55.17,55.82,54.48,54.43,53.28,52.41,52.46,50.25,49.77,48.04,46.49,45.26,43.08,41.67,42.77,43.34,44.59,45.72,47.32,48.74,49.7,51.45,52.12,53.1,53.64,55.41,55.72,55.46,55.03,54.52,52.22,51.21,49.94,48.43,46.99,46.17,44.74,43.9,42.67,41.97,41.18,42.12,])            
Y = np.array([11.23,11.22,11.23,11.23,11.34,11.3,11.30,11.3,11.16,12.45,12.45,12.45,12.47,12.99,12.47,12.59,12.48,12.61,12.52,12.61,12.62,13.51,13.51,13.5,13.5,13.48,13.67,13.06,13.48,13.53,13.05,13.45,13.45,13.45,13.41,14.08,14.11,14.18,14.18,14.1,14.18,14.11,14.12,14.2,14.15,14.13,14.13,14.15,14.94,14.94,])                       
Z = np.array([63.71,69.47,32.31,33.28,31.81,31.97,32.09,62.72,63.06,61.52,61.96,31.64,31.78,32.34,31.86,31.8,31.8,31.74,31.14,32.21,65.27,67.57,68.96,32.79,31.49,31.18,32.07,32.73,32.26,32.04,31.88,32.05,32.21,33.58,67.55,63.8,32.6,32.04,32.4,32.04,31.34,32.79,31.37,31.32,31.61,31.86,32.6,60.76,60.5,33.46,])
N = len(Z)

#Input expected target distance, background wall distance, and distance tolerance for binary conversion
targetDist = 40.0
wallDist = 70.0
tolDist = 10
Zbinary = np.empty([N])
X2D = np.zeros([N])
Y2D = np.zeros([N])

#Convert 3D to 2D, hit==1 miss==0
for i in range(N):
    if Z[i]-targetDist < tolDist and Z[i]-targetDist > -tolDist:
        Zbinary[i] = 70
        X2D[i] = X[i]
        Y2D[i] = Y[i]
        
    else:
        Zbinary[i] = 0
        


#Print 3D Results
f1 = plt.figure()
ax = f1.gca(projection='3d')
#ax.plot(X, Y, Zbinary, 'o')
ax.plot(X, Y, Z,'o')
plt.xlabel('X')
plt.ylabel('Y')
plt.title('3D Image')

#Print 2D Results
f2= plt.figure()
plt.plot(X2D, Y2D,'o')
plt.xlabel('X')
plt.ylabel('Y')
plt.title('2D Image')