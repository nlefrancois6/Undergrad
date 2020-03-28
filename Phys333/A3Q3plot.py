#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Dec  1 19:59:56 2019

@author: noahlefrancois
"""

import numpy as np
import matplotlib.pyplot as plt


nMax = 10**3
def N(x,y):
    Nsum = 0
    for n in range(1,nMax):
        Nsum = Nsum + 1/(np.exp(x*n - y)-1)
    return Nsum

def Nb(x,y):
    return 1/(x-y)

def Nc(x,y):
    n = 1
    return 1/(np.exp(x*n - y)-1)

yval = 0.25
xMax = 10
x = np.linspace(0,xMax,100*xMax)
y = 100*xMax*[yval]

xb = np.linspace(yval+0.001, xMax, 100*xMax)

Navg_y1 = N(xb,y[0])
#Navg_y3 = N(x,y[1])
#Navg_y5 = N(x,y[2])

Nb = Nb(xb,y[1])
Nc = Nc(xb,y[1])




plt.ylabel('$N_{avg}$')
plt.xlabel('$BE_0$')
plt.title('Q3 (d)')
plt.plot(x-y, Navg_y1, label='y=1')
#plt.plot(x, Navg_y3, label='y=3')
#plt.plot(x, Navg_y5, label='y=5')
plt.plot(x-y, Nb, label='x=y approx')
plt.plot(x-y, Nc, label='x>y approx')
plt.yscale("log")
plt.xscale("log")
plt.legend()

