#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 29 14:54:42 2019

@author: noahlefrancois
"""

import numpy as np
import matplotlib.pyplot as plt
import random as r

N = 1000
c = [156, 70, 0]
        
p1 = 0.5
pUni = 0.48/11.0
pLow = 0.02/4.0

probVect = [pLow, pLow, pLow, pLow, pUni, pUni, pUni, pUni, pUni, pUni, pUni, pUni, pUni, pUni, pUni, p1]
cumVect = np.cumsum(probVect)

values = np.zeros(N)
trials = range(N)
brightness = np.zeros(N)
bVals = np.zeros(16)
bInt = 1.0/16
length = 15
cumLength = 0

for i in range(16):
    bVals[i] = bInt*i

for i in trials:
    values[i] = r.random()
    if(values[i]<cumVect[0]):
        brightness[i] = bVals[0]
    elif(cumVect[0]<=values[i]<cumVect[1]):
        brightness[i] = bVals[1]
    elif(cumVect[1]<=values[i]<cumVect[2]):
        brightness[i] = bVals[2]
    elif(cumVect[2]<=values[i]<cumVect[3]):
        brightness[i] = bVals[3]
    elif(cumVect[3]<=values[i]<cumVect[4]):
        brightness[i] = bVals[4]
    elif(cumVect[4]<=values[i]<cumVect[5]):
        brightness[i] = bVals[5]
    elif(cumVect[5]<=values[i]<cumVect[6]):
        brightness[i] = bVals[6]
    elif(cumVect[6]<=values[i]<cumVect[7]):
        brightness[i] = bVals[7]
    elif(cumVect[7]<=values[i]<cumVect[8]):
        brightness[i] = bVals[8]
    elif(cumVect[8]<=values[i]<cumVect[9]):
        brightness[i] = bVals[9]
    elif(cumVect[9]<=values[i]<cumVect[10]):
        brightness[i] = bVals[10]
    elif(cumVect[10]<=values[i]<cumVect[11]):
        brightness[i] = bVals[11]
    elif(cumVect[11]<=values[i]<cumVect[12]):
        brightness[i] = bVals[12]
    elif(cumVect[12]<=values[i]<cumVect[13]):
        brightness[i] = bVals[13]
    elif(cumVect[13]<=values[i]<cumVect[14]):
        brightness[i] = bVals[14]
    elif(cumVect[14]<=values[i]<cumVect[15]):
        brightness[i] = bVals[15]
        
binNumber = 16

histValues, binEdges = np.histogram(brightness, binNumber)
cumHistValues = np.cumsum(histValues)/float(N)

binCenter = np.zeros(len(binEdges)-1)

for i in range(len(binEdges)-1):
    binCenter[i] = 0.5 * (binEdges[i] + binEdges[i+1])


f1 = plt.figure


plt.subplot(2,1,1)

plt.plot(trials, brightness, 'o')

plt.subplot(2,1,2)
plt.hist(brightness, bins=binNumber)

"""
np.savetxt('BrightnessScatter.csv', np.transpose([trials, brightness]), delimiter = ",")
np.savetxt('BrightnessHist.csv', np.transpose([binCenter, histValues]), delimiter = ",")
"""

