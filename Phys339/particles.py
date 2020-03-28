# -*- coding: utf-8 -*-
"""
Created on Thu Jan 10 15:37:53 2019

@author: chloe
"""

import matplotlib.pyplot as plt
import random as r
import numpy as np
import math

Nsamp = 10000

binNumber = 20
cumBinNumber = 100
a = 1.0

#Exponential Generator
valuesE = np.zeros(Nsamp)
trialsE = range(Nsamp)
ro = np.zeros(Nsamp)

for i in trialsE:
    ro[i] = r.random()
    valuesE[i] = -(1/a) * np.log(1-ro[i])

#Uniform Generator
valuesU = np.zeros(Nsamp)
thetaU = np.zeros(Nsamp)
trialsU = range(Nsamp)

for i in trialsU:
    valuesU[i] = 1.0/(2*math.pi)
    thetaU[i] = r.random()*2.0*math.pi

#Gaussian Generator
valuesG = np.zeros(Nsamp)

for i in trialsE:
    valuesG[i] = valuesE[i] * valuesU[i]

w = 0.9 #aperture width
sigma = w/6

rad = np.zeros(Nsamp)
xVal = np.zeros(Nsamp)
yVal = np.zeros(Nsamp)

for i in trialsE:
    rad[i] = ((2*valuesE[i])**(1/2))*sigma
    xVal[i] = (((rad[i]*math.cos(thetaU[i]))/8)+0.5)*0.9
    yVal[i] = (((rad[i]*math.sin(thetaU[i]))/8)+0.5)*0.9



particleStart = np.zeros((Nsamp,2))
#particleStartY = np.zeros(Nsamp)
#particleEnd = np.zeros((1,2))
particleEnd = np.zeros((Nsamp,2))
#particleEndY = np.zeros(Nsamp)
particles = range(Nsamp)

for i in particles: 
    particleEnd[i][0] = xVal[i]
    particleEnd[i][1] = yVal[i]
    #particleStart = w*r.random()
    #particleEnd[i] = xVal[i]



f5 = plt.figure

plt.subplot(1,1,1)
plt.plot(xVal,yVal, 'o')

"""
plt.subplot(1,2,2)
plt.hist(particleEnd, bins = binNumber)
"""

np.savetxt('2DParticleScatter.csv', np.transpose([xVal, yVal]), delimiter = ",")
