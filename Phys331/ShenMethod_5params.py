#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar  7 22:13:55 2019

@author: noahlefrancois
"""


import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


#define parameters
sig = 10
d0 = 3.0
b = 8.0/3.0
r=10


#define initial conditions
state = [7,1,0,0,0]
t = 0

#Calculate State Vector
def step(state, dt):
    x, y, z, y1, z1 = state
    #Take Derivatives
    Xdot= sig*(y - x)
    Ydot = -x*z + r*x - y
    Zdot = x*y - x*y1 - b*z
    Y1dot = x*z - 2*x*z1 -d0*y1
    Z1dot = 2*x*y1 -4*b*z1
    #Return state array after 1 time-step
    return x + Xdot*dt, y + Ydot*dt, z + Zdot*dt, y1 + Y1dot*dt, z1 + Z1dot*dt

def mpStep(state, dt):
    x, y, z, y1, z1 = state
    #Take 2 steps to get N2
    N_1 = step(state, dt)
    N_2 = step(N_1, dt)
    #I have been tricked into this monstrous notation
    x2, y2, z2, y1_2, z1_2 = N_2
    #Return midpoint state vector
    return 0.5*(x+x2), 0.5*(y+y2), 0.5*(z+z2), 0.5*(y1+y1_2), 0.5*(z1+z1_2)


#Final T, N, dt
T = 100
dt = 0.01
N = int(T/dt)

times = np.empty(N)
states = np.empty([N,5])
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
ax.plot(sPlt[0], sPlt[1], sPlt[2])
plt.xlabel('X')
plt.ylabel('Y')
print(state)


np.savetxt('5DdX.csv', np.transpose([times, statesX]), delimiter = ",")
np.savetxt('5DdY.csv', np.transpose([times, statesY]), delimiter = ",")
np.savetxt('5DdZ.csv', np.transpose([times, statesZ]), delimiter = ",")



