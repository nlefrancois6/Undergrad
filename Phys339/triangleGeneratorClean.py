#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan  9 11:16:04 2019

@author: noahlefrancois
"""


import matplotlib.pyplot as plt
import random as r
import numpy as np
import math

Nsamp = 1000

data = np.zeros(Nsamp)
trials = range(Nsamp)
values = np.zeros(Nsamp)
A = 4


for i in trials:
    data[i] = r.random() 
    if (data[i] <= 0.5):
        values[i] = (data[i]/2)**(1/2)
    
    else:
        data[i] = data[i] - 0.5
        values[i] = -(-2+(1-2*data[i])**(1/2))/2

binNumber = 20
cumBinNumber = 100

print('mean', np.mean(values))
print('std', np.std(values))

"""
def triangleModel(a, x):
    X = np.array(x)
    Y = np.zeros(len(x))
    for i in X:
        if(X[i]>=0.5):
            Y[i] = a*X[i]
        else:
            Y[i] = a*(1-X[i])
    return Y
"""

histValues, binEdges = np.histogram(values, cumBinNumber)
cumHistValues = np.cumsum(histValues)/float(Nsamp)

binCenter = np.zeros(len(binEdges)-1)

for i in range(len(binEdges)-1):
    binCenter[i] = 0.5 * (binEdges[i] + binEdges[i+1])


f1 = plt.figure


plt.subplot(2,2,1)

plt.plot(trials, values, 'o')
plt.subplot(2,2,2)
plt.hist(values, bins=binNumber)

plt.subplot(2,2,3)
plt.plot(binCenter, cumHistValues, 'o')

plt.subplot(2,2,4)
#plt.plot(binCenter, triangleModel(4,binCenter),'o')
#plt.xlabel('value')
#plt.ylabel('cumulative counts')









