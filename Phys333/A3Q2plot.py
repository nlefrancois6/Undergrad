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
        Nsum = Nsum + 1/(np.exp(x*n - y)+1)
    return Nsum

def Nb(x,y):
    return (1/x)*(np.log(1+np.exp(x-y))+y-x)
    #return y/x

def Nc(x,y):
    n = 1
    return 1/(np.exp(x*n - y)+1)

xMax = 10
x = np.linspace(0,xMax,100*xMax)
y = [1,3,5]


Navg_y1 = N(x,y[0])
Navg_y3 = N(x,y[1])
Navg_y5 = N(x,y[2])

Nb = Nb(x,20)
Nc = Nc(x,y[1])



plt.ylabel('$N_{avg}$')
plt.xlabel('$BE_0$')
plt.title('Q2 (d)')
plt.plot(x, Navg_y1, label='y=1')
plt.plot(x, Navg_y3, label='y=3')
plt.plot(x, Navg_y5, label='y=5')
plt.plot(x, Nb, label='x<y approx')
plt.plot(x, Nc, label='x>y approx')
plt.yscale("log")
plt.legend()

