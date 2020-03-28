#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb  5 16:34:48 2019

@author: noahlefrancois
"""

import numpy as np
import matplotlib.pyplot as plt
import random as r
import math
from scipy.optimize import curve_fit
from scipy.misc import factorial

N = 1000
mu = 7
Bins = 11

def chiSq(v, Obsarr, ExpectArr):
    print(len(Obsarr))
    print(len(ExpectArr))
    summed = np.empty(len(Obsarr))
    for i in range(len(Obsarr)):
        summed[i] = ((Obsarr[i]-ExpectArr[i])**2)/Obsarr[i]
        
    return sum(summed)/v

# get poisson deviated random numbers
data = np.random.poisson(mu, N)

# the bins should be of integer width, because poisson is an integer distribution
entries, bin_edges, patches = plt.hist(data, bins=11, range=[0, mu+10], normed=True)

# calculate binmiddles
bin_middles = 0.5*(bin_edges[1:] + bin_edges[:-1])

#Remove empty bins
count = 0
for i in range(len(entries)):
    if entries[i]!=0.0:
        count += 1
copy = np.empty(count)
binsCopy = np.empty(count)
count = 0
for i in range(len(entries)):
    if entries[i]!= 0:
        copy[count] = entries[i]
        binsCopy[count] = bin_middles[i]
        count+=1
removed = len(entries) - len(copy)


# poisson function, parameter lamb is the fit parameter
def poisson(k, lamb):
    return (lamb**k/factorial(k)) * np.exp(-lamb)

# gaussian function, parameter sig = sqrt(lamb)
def gaussian(k, sig, lamb):
    return (1/(sig*math.sqrt(2*math.pi)))*np.exp(-0.5*((k-lamb)/sig)**2)

#exponential function


# plot poisson-deviation with fitted parameter
x_plot = np.linspace(0, mu+20, N)

# fit with curve_fit
parametersP, cov_matrixP = curve_fit(poisson, binsCopy, copy) 
parametersG, cov_matrixG = curve_fit(gaussian, binsCopy, copy)

pFit = np.empty(len(copy))
gFit = np.empty(len(copy))
for i in range(len(copy)):
    pFit[i] = poisson(parametersP[0], x_plot[i])
    gFit[i] = gaussian(parametersG[0], parametersG[1], x_plot[i])


#Chi squared tests for G and P fits
chiSqP = chiSq(Bins-2-removed, copy, pFit)
chiSqG = chiSq(Bins-3-removed, copy, gFit)
print("Chi Squared Result for Poisson", chiSqP)
print("Chi Squared Result for Gaussian", chiSqG)


f1 = plt.figure
plt.plot(x_plot, poisson(x_plot, *parametersP), 'cyan', lw=2, label = 'Poisson Fit')
plt.plot(x_plot, gaussian(x_plot, *parametersG), 'purple', lw=2, label = 'Gaussian Fit')
#f1.legend(loc='upper right', bbox_to_anchor=(0.9, 0.9))
plt.title("Fig 4(a): Monte Carlo Histogram, Mean=7")
plt.xlabel("Event Occurences")
plt.ylabel("Normalized Occurence Count")


"""
f2 = plt.figure()
plt.plot(x_plot, gaussian(x_plot, *parametersG), 'r-', lw=2)
plt.title("Gaussian Fit")
plt.xlabel("Event Occurences")
plt.ylabel("Normalized Occurence Count")
"""

