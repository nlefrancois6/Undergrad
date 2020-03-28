#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan  9 11:25:50 2019

@author: noahlefrancois
"""

import matplotlib.pyplot as plt
import random as r
import numpy as np
import math

Nsamp = 1000

binNumber = 20
cumBinNumber = 100
a = 1.0

#Exponential Generator
valuesE = np.zeros(Nsamp)
trials = range(Nsamp)

for i in trials:
    ro = r.random()
    valuesE[i] = -(1.0/a) * np.log(1.0-ro)

#Uniform Generator
#valuesU = np.zeros(Nsamp)
thetaU = np.zeros(Nsamp)

for i in trials:
    #valuesU[i] = 1.0/(2*math.pi)
    thetaU[i] = r.random()*2.0*math.pi

#Gaussian Generator
#valuesG = np.zeros(Nsamp)

#for i in trials:
    #valuesG[i] = valuesE[i] * valuesU[i]

sigma = 1.0

rad = np.zeros(Nsamp)
xVal = np.zeros(Nsamp)
yVal = np.zeros(Nsamp)


for i in trials:
    rad[i] = ((2.0*valuesE[i])**(1.0/2.0))*sigma
    xVal[i] = rad[i]*math.cos(thetaU[i])
    yVal[i] = rad[i]*math.sin(thetaU[i])

print('X mean', np.mean(xVal))
print('X std', np.std(xVal))

print('Y mean', np.mean(yVal))
print('Y std', np.std(yVal))