#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 24 11:00:26 2019

@author: noahlefrancois
"""

import numpy as np
import matplotlib.pyplot as plt
import spinmob as sm
import mcphysics as mp

x = np.array([0.23,0.25,0.27,0.29,0.31])
t = np.array([51,72,100,146,217])
#counts = np.array([4651,4762,4574,4409,4615])
counts = np.array([4635.6, 4648.0, 4415.0, 4464.4, 4642.2])
countRate = counts/t
print(countRate*-16.8)
#cRu = np.array([30,46,25,26,26])/t
cRu = np.array([29.856992480824324, 102.44998779892558, 18.750999973334757, 62.764958376469906, 68.6772160181235])/t
u = cRu + 0.5*np.array([1527.02117647, 1084.53333333, 741.72, 513.71178082, 359.39612903])
#cRu = 200/t
print(u)

"""
x = np.array([0.23,0.25,0.27,0.29,0.31,0.36])
t = np.array([51,72,100,146,217,416])
#counts = np.array([4651,4762,4574,4409,4615,4470])
counts = np.array([4635.6, 4648.0, 4415.0, 4464.4, 4642.2, 4498.2])
countRate = counts/t
print(countRate*-16.8)
cRu = np.array([30,46,25,26,26,24])/t
#cRu = np.array([29.856992480824324, 102.44998779892558, 18.750999973334757, 62.764958376469906, 68.6772160181235, 52.70825362312813])/t
u = cRu + 0.5*np.array([1527.02117647, 1084.53333333, 741.72, 513.71178082, 359.39612903, 181.65807692])
#cRu = 200/t
print(u)
"""

"""
x = np.array([0.23,0.25,0.27,0.29,0.31,0.36])
t = np.array([51,72,100,146,217,416])
counts = 5000
countRate = counts/t
cRu = np.sqrt(counts)/t
"""

#def function(x,I0,b):
#    return I0*np.exp(-b*x)
f = sm.data.fitter()
f.set_functions('I0*exp(-b*x)', p = 'I0,b')
f.set(I0=100, b = 2)
f.set_data(x, countRate, cRu)
f.fit()
f.set(xlabel='Concrete Thickness (m)', ylabel='Count Rate (1/s)')


"""
plt.figure()
plt.plot(x,countRate,'o')
plt.ylabel('Counts per second in peak channel')
plt.xlabel('Concrete Thickness (m)')
"""