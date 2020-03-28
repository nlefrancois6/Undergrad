#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 29 15:41:27 2019

@author: noahlefrancois
"""


import numpy as np
import random as r

N = 10

p0 = 0.15
p = (1.0-p0)/3
probVectC = [p0, p, p, p]
cumVectC = np.cumsum(probVectC)

valCs = np.zeros(N)
trials = range(N)
colours = np.empty([N,3])
c1 = [246, 227, 94]
c2 = [156, 70, 0]
c3 = [156, 20, 0]
c4 = [150, 20, 10]

for i in trials:
    valCs[i] = r.random()
    if(valCs[i]<cumVectC[0]):
        colours[i] = c1
    elif(cumVectC[0]<=valCs[i]<cumVectC[1]):
        colours[i] = c2
    elif(cumVectC[1]<=valCs[i]<cumVectC[2]):
        colours[i] = c3
    elif(cumVectC[2]<=valCs[i]<cumVectC[3]):
        colours[i] = c4
        
print(colours)

"""
np.savetxt('BrightnessScatter.csv', np.transpose([trials, brightness]), delimiter = ",")
np.savetxt('BrightnessHist.csv', np.transpose([binCenter, histValues]), delimiter = ",")
"""

