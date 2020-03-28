#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Dec  1 19:59:56 2019

@author: noahlefrancois
"""

import numpy as np
import matplotlib.pyplot as plt
import math

#Specify level and size of degen subspace
n = 2
spaceDim = 2*n**2

#Specify constants
c = 3*10**8
e0 =  8.85*10**(-12)
m = 9.109*10**(-31)
hbar = 1.055*10**(-34)
a = 5.29*10**(-11)
e = 1.602*10**(-19)
ub = e*hbar/(2*m)

#Define W entries function
def W1(n, l, ml, ms):
    return (e**2/(8*math.pi*e0*m**2*c**2))*(hbar**2*ml*ms)/(l*(l+0.5)*(l+1)*n**3*a**3)

def W2(n, l):
    return -(-m*(e**2/(4*math.pi*e0))**2/(2*hbar**2))*(4*n/(l+0.5)-3)/(2*m*c**2*n**4)

def W3(ml, ms, B):
    return ub*B*(ml+2*ms)

def W(n, l, ml, ms, B):
    return W1(n, l, ml, ms) + W2(n, l) + W3(ml, ms, B)

#print(W(2,1,1,0.5,10**10))

#To get all possible n,l,ml,ms for specified n value
nVals = [n]
lVals = []
mlVals = []
msVals = [0.5,-0.5]


lVals.append(0)
mlVals.append([0])
for i in range(n):
    if i>0:
        lVals.append(i)
        mlVals.append([0])
        for j in range(i+1):
            if j>0:
                mlVals[i].append(j)
                mlVals[i].append(-(j))

#Generate basis states for our quantum numbers
eigStates = []
state = 0
for lInd in range(n):
    #l=0 states, ms = +-0.5
    if lInd == 0:
        eigStates.append([n])
        eigStates[state].append(lVals[lInd])
        eigStates[state].append(mlVals[lInd][0])
        eigStates[state].append(msVals[0])
        state = state + 1
        
        eigStates.append([n])
        eigStates[state].append(lVals[lInd])
        eigStates[state].append(mlVals[lInd][0])
        eigStates[state].append(msVals[1])
        state = state + 1
        
    #l>0 states, ms = +-0.5
    if lInd>0:
        for mlInd in range(2*lVals[lInd]+1):
            eigStates.append([n])
            eigStates[state].append(lVals[lInd])
            eigStates[state].append(mlVals[lInd][mlInd])
            eigStates[state].append(msVals[0])
            state = state + 1
            
            eigStates.append([n])
            eigStates[state].append(lVals[lInd])
            eigStates[state].append(mlVals[lInd][mlInd])
            eigStates[state].append(msVals[1])
            state = state + 1
        

       
print(nVals)
print(lVals)
print(mlVals)
print(eigStates)


'''
x = np.linspace(-0.5,0.5,100)

lnW = lnW(N, x)/N



plt.ylabel('# of Microstates Normalized')
plt.xlabel('x=f-0.5')
plt.plot(x, lnW, label='W(x)')
plt.legend()
'''

"""
#To get n,l,ml,ms for all n values
nVals = []
lVals = []
mlVals = []
msVals = [0.5,-0.5]
for i in range(n):
    nVals.append(i+1)
    lVals.append([0])
    mlVals.append([])
    mlVals[i].append([0])
    print(mlVals)
    for j in range(i+1):
        if j>0:
            lVals[i].append(j)
            mlVals[i].append([0])
            for k in range(j):
                mlVals[i][j].append(j)
                mlVals[i][j].append(-(j))
"""
