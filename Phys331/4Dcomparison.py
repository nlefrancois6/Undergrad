#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 30 11:47:39 2019

@author: noahlefrancois
"""


import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

#define parameters
sig = 0.5
d = 3.0
b = 8.0/3.0
r=7


#define initial conditions
dI = 1.0
print(dI)
state = [7,1,0,0]
stateD = [7,1+dI,0,0]
#print(5-state[1])
#stateT = [0,1.1,0]
t = 0

#Calculate State Vector
def step(state, dt):
    x, y, z, w = state
    #Take Derivatives
    Xdot= sig*(y - x + d*w)
    Ydot = -x*z + r*x - y
    Zdot = x*y - b*z
    Wdot = sig*(-d*x-w)
    #Return state array after 1 time-step
    return x + Xdot*dt, y + Ydot*dt, z + Zdot*dt, w + Wdot*dt

def mpStep(state, dt):
    x, y, z, w = state
    #Take 2 steps to get N2
    N_1 = step(state, dt)
    N_2 = step(N_1, dt)
    x2, y2, z2, w2 = N_2
    #Return midpoint state vector
    return 0.5*(x+x2), 0.5*(y+y2), 0.5*(z+z2), 0.5*(w+w2)


#Final T, N, dt
T = 1000
dt = 0.01
N = int(T/dt)

times = np.empty(N)
states = np.empty([N,4])
statesD = np.empty([N,4])
#statesT = np.empty([N,3])
#integral = 0

interval = 0
#Simulate
for i in range(N):
    #Record Values
    states[i] = state
    statesD[i] = stateD
    #statesT[i] = stateT
    times[i] = t
    
    #Update State
    state = mpStep(state, dt)
    stateD = mpStep(stateD, dt)
    #stateT = mpStep(stateT, dt)
    #Update Time
    t += dt


xf = [state[0]] 
yf = [state[1]] 
zf = [state[2]]
xfD = [stateD[0]] 
yfD = [stateD[1]] 
zfD = [stateD[2]] 
sPlt = np.transpose(states)
sPltD = np.transpose(states)
f1 = plt.figure()
ax = f1.gca(projection='3d')
ax.plot(sPlt[0], sPlt[1], sPlt[2],'p')
ax.plot(sPltD[0], sPltD[1], sPltD[2],',')
ax.plot(xf, yf, zf, 'r+')
ax.plot(xfD, yfD, zfD, 'k+')


print(state)
#print(stateT)