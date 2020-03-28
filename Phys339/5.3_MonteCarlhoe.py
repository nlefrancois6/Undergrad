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
"""
N = 10000
mu = 2
"""
Bins = 9

def chiSq(v, Obsarr, ExpectArr):
    print(len(Obsarr))
    print(len(ExpectArr))
    summed = np.empty(len(Obsarr))
    for i in range(len(Obsarr)):
        summed[i] = ((Obsarr[i]-ExpectArr[i])**2)/Obsarr[i]
        
    return sum(summed)/v

# get poisson deviated random numbers
raw = np.loadtxt('2019_02_14_16_18_36_period0.2_int1000_rep1_COUNTING_DATA.csv' , delimiter = ',')

"""
#To trim to 100 data points
data = np.empty(100)
for i in range(len(data)):
    data[i] = raw[i]

mu = np.mean(data)
print(mu)
print(np.std(data))
"""

# the bins should be of integer width, because poisson is an integer distribution
entries, bin_edges, patches = plt.hist(data, bins=Bins, range=[0, mu+7], normed=True)

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

def exp(a,k):
    return a*np.exp(a*k)


# plot poisson-deviation with fitted parameter
x_plot = np.linspace(0, 10, len(data))

# fit with curve_fit
parametersP, cov_matrixP = curve_fit(poisson, binsCopy, copy) 
parametersG, cov_matrixG = curve_fit(gaussian, binsCopy, copy)
#parametersE, cov_matrixG = curve_fit(exp, binsCopy, copy)
print(parametersP)
print(parametersG)

pFit = np.empty(len(entries))
gFit = np.empty(len(entries))
#eFit = np.empty(len(copy))
for i in range(len(entries)):
    pFit[i] = poisson(parametersP[0], x_plot[i])
    gFit[i] = gaussian(parametersG[0], parametersG[1], x_plot[i])
    #eFit[i] = exp(parametersE[0], x_plot[i])


#Chi squared tests for G and P fits
chiSqP = chiSq(Bins-2-removed, copy, pFit)
chiSqG = chiSq(Bins-3-removed, copy, gFit)
#chiSqE = chiSq(Bins-2-removed, copy, eFit)
print("Chi Squared Result for Poisson", chiSqP)
print("Chi Squared Result for Gaussian", chiSqG)
#print("Chi Squared Result for Exponential", chiSqE)

f1 = plt.figure()
plt.plot(x_plot, poisson(x_plot, *parametersP), 'cyan', lw=2, label = 'Poisson Fit')
plt.plot(x_plot, gaussian(x_plot, *parametersG), 'purple', lw=2, label = 'Gaussian Fit')
plt.hist(data, bins=Bins, range=[0, 10], normed=True)
f1.legend(loc='upper right', bbox_to_anchor=(0.9, 0.9))
#plt.plot(x_plot,x_plot)
#plt.plot(x_plot, exp(x_plot, *parametersE), 'orange', lw=2)
plt.title("Fig 7: Counting Experiment Histogram")
plt.xlabel("Event Occurences")
plt.ylabel("Normalized Occurence Count")


"""
f2 = plt.figure()
plt.plot(x_plot, gaussian(x_plot, *parametersG), 'r-', lw=2)
plt.title("Gaussian Fit")
plt.xlabel("Event Occurences")
plt.ylabel("Normalized Occurence Count")
"""



