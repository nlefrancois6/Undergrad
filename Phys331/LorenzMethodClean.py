#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 13 11:02:12 2019

@author: noahlefrancois
"""

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

#Calculate State Vector
def step(state, dt):
    x, y, z = state
    #Take Derivatives
    Xdot= -sig*x + sig*y
    Ydot = -x*z + r*x - y
    Zdot = x*y - b*z
    #Return state array after 1 time-step
    return x + Xdot*dt, y + Ydot*dt, z + Zdot*dt

def mpStep(state, dt):
    x, y, z = state
    #Take 2 steps to get N2
    N_1 = step(state, dt)
    N_2 = step(N_1, dt)
    x2, y2, z2 = N_2
    #Return midpoint state vector
    return 0.5*(x+x2), 0.5*(y+y2), 0.5*(z+z2)


#define parameters
sig = 0.5
#aSq = 0.5
b = 8.0/3.0
r=70


#define initial conditions
state = [7,1,0]
t = 0


#Final T, N, dt
T = 100
dt = 0.01
N = int(T/dt)

times = np.empty(N)
states = np.empty([N,3])
statesX = np.empty(N)
statesY = np.empty(N)
statesZ = np.empty(N)

#Simulate
for i in range(N):
    #Record Values
    states[i] = state
    xr = state[0]
    yr = state[1]
    zr = state[2]
    statesX[i] = xr
    statesY[i] = yr
    statesZ[i] = zr
    times[i] = t
    
    #Update State
    state = mpStep(state, dt)
    #Update Time
    t += dt
    


sPlt = np.transpose(states)
f1 = plt.figure()
ax = f1.gca(projection='3d')
ax.plot(sPlt[0], sPlt[1], sPlt[2],'o')
plt.title("r = " + str(r) )
plt.xlabel("X")
plt.ylabel("Y")

print(state)

np.savetxt('3DcX.csv', np.transpose([times, statesX]), delimiter = ",")
np.savetxt('3DcY.csv', np.transpose([times, statesY]), delimiter = ",")
np.savetxt('3DcZ.csv', np.transpose([times, statesZ]), delimiter = ",")