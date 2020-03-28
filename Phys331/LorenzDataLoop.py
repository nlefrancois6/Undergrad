#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 21 12:34:43 2019

@author: noahlefrancois
"""

import numpy as np
np.set_printoptions(threshold=np.nan)

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

#Testing Params
Ts = [10,100,1000]
Y_0s = [1,5]
dY_0s = [0,0.001,0.01]
statesF = np.empty([len(Ts)*len(Y_0s)*len(dY_0s),3])
times = np.empty(len(Ts)*len(Y_0s)*len(dY_0s))

#define parameters
sig = 10
#aSq = 0.5
b = 8.0/3.0
r=28

#Generate Simulation Data Across all Paramaters and Record Final States and Times
index = 0
for i in range(len(dY_0s)):
    perturb = dY_0s[i]
    for j in range(len(Y_0s)):
        Y_0 = Y_0s[j]+ perturb

        for k in range(len(Ts)):
            #define initial conditions
            state = [0,Y_0,0]
            print(state)
            t = 0
            
            #Final T, N, dt
            T = Ts[k]
            dt = 0.01
            N = int(T/dt)

            #Simulate
            for l in range(N):
                #Update State
                state = mpStep(state, dt)
                #Update Time
                t += dt
            #Record Final State and Time
            statesF[i] = state
            times[i] = t
            print(t)
            #increment data index

print(statesF)

