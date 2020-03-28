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

numBs = 10
B = np.linspace(10**16,10**18,numBs)

#Which approximations to plot
high = False
low = False

#Specify constants
c = 3*10**8
e0 =  8.85*10**(-12)
m = 9.109*10**(-31)
hbar = 1.055*10**(-34)
a = 5.29*10**(-11)
e = 1.602*10**(-19)
ub = e*hbar/(2*m)

alpha = e**2/(4*math.pi*e0*hbar*c)

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

       
#print(nVals)
#print(lVals)
#print(mlVals)
print(eigStates)

#eval W1, W2, W3 entries and sum them to obtain the full W entries; store them in WMat.
#Obtain the energy corrections for each of the states and store them as rows in WMatDiagBs 
#so that we can plot them
WMatDiagBs = []
WMatDiagBsLow = []
WMatDiagBsHigh = []
for b in range(numBs):
    w, h = spaceDim, spaceDim;
    W1Mat = [[0 for x in range(w)] for y in range(h)] 
    W2Mat = [[0 for x in range(w)] for y in range(h)] 
    W3Mat = [[0 for x in range(w)] for y in range(h)] 
    WMat = [[0 for x in range(w)] for y in range(h)] 
    WLowMat = [[0 for x in range(w)] for y in range(h)] 
    WHighMat = [[0 for x in range(w)] for y in range(h)] 
    for x in range(w):
        xState = eigStates[x]
        for y in range(h):
            yState = eigStates[y]
            if (xState[1]==yState[1])&(xState[2]==yState[2])&(xState[3]==yState[3]):
                if xState[1]==0:
                    W1Mat[y][x] = 0
                else:
                    W1Mat[y][x] = W1(n, xState[1], xState[2], xState[3])
            if xState[1]==yState[1]:
                W2Mat[y][x] = W2(n,xState[1])
            if (xState[2]==yState[2])&(xState[3]==yState[3]):
                W3Mat[y][x] = W3(xState[2], xState[3], B[b])
            WMat[y][x] = W1Mat[y][x] + W2Mat[y][x] + W3Mat[y][x]
            WHighMat[y][x] = W1Mat[y][x] + W2Mat[y][x]
            WLowMat[y][x] = W3Mat[y][x]
    
    #Diagonalize the W matrix to obtain eigenvalues, then extract the correction
    #for each of the states so that we can plot them
    EigVals = np.diag(WMat)
    EigValsLow = np.diag(WLowMat)
    EigValsHigh = np.diag(WHighMat)
    WMatDiagBs.append([])
    WMatDiagBsLow.append([])
    WMatDiagBsHigh.append([])
    for corr in range(spaceDim):
        WMatDiagBs[b].append(EigVals[corr])
        WMatDiagBsLow[b].append(EigValsLow[corr])
        WMatDiagBsHigh[b].append(EigValsHigh[corr])
    WMatDiagBsT = [[WMatDiagBs[j][i] for j in range(len(WMatDiagBs))] for i in range(len(WMatDiagBs[0]))]
    WMatDiagBsTLow = [[WMatDiagBsLow[j][i] for j in range(len(WMatDiagBsLow))] for i in range(len(WMatDiagBsLow[0]))]
    WMatDiagBsTHigh = [[WMatDiagBsHigh[j][i] for j in range(len(WMatDiagBsHigh))] for i in range(len(WMatDiagBsHigh[0]))]
    
#print(WMatDiagBsT)
    
if n==2:
    #plt.title('Zeeman & Fine Structure Energy Splitting, Intermediate Field (n=2)')
    #plt.title('Zeeman & Fine Structure Energy Splitting, Strong Field Approximation (n=2)')
    plt.title('Zeeman & Fine Structure Energy Splitting, Intermediate Field (n=2)')
    plt.ylabel('Energy Correction')
    plt.xlabel('Magnetic Field Strength')
    plt.plot(B, WMatDiagBsT[0], label='E1')
    plt.plot(B, WMatDiagBsT[1], label='E2')
    plt.plot(B, WMatDiagBsT[2], label='E3')
    plt.plot(B, WMatDiagBsT[3], label='E4')
    plt.plot(B, WMatDiagBsT[4], label='E5')
    plt.plot(B, WMatDiagBsT[5], label='E6')
    plt.plot(B, WMatDiagBsT[6], label='E7')
    plt.plot(B, WMatDiagBsT[7], label='E8')
    if low==True:
        plt.plot(B, WMatDiagBsTLow[0], label='E1Low')
        plt.plot(B, WMatDiagBsTLow[1], label='E2Low')
        plt.plot(B, WMatDiagBsTLow[2], label='E3Low')
        plt.plot(B, WMatDiagBsTLow[3], label='E4Low')
        plt.plot(B, WMatDiagBsTLow[4], label='E5Low')
        plt.plot(B, WMatDiagBsTLow[5], label='E6Low')
        plt.plot(B, WMatDiagBsTLow[6], label='E7Low')
        plt.plot(B, WMatDiagBsTLow[7], label='E8Low')
    if high==True:
        plt.plot(B, WMatDiagBsTHigh[0], label='E1High')
        plt.plot(B, WMatDiagBsTHigh[1], label='E2High')
        plt.plot(B, WMatDiagBsTHigh[2], label='E3High')
        plt.plot(B, WMatDiagBsTHigh[3], label='E4High')
        plt.plot(B, WMatDiagBsTHigh[4], label='E5High')
        plt.plot(B, WMatDiagBsTHigh[5], label='E6High')
        plt.plot(B, WMatDiagBsTHigh[6], label='E7High')
        plt.plot(B, WMatDiagBsTHigh[7], label='E8High')
    plt.legend(loc='center left', bbox_to_anchor=(1, 0.5))
elif n==3:
    plt.title('Zeeman & Fine Structure Energy Splitting, Intermediate Field (n=3)')
    plt.ylabel('Energy Correction')
    plt.xlabel('Magnetic Field Strength')
    plt.plot(B, WMatDiagBsT[0], label='E1')
    plt.plot(B, WMatDiagBsT[1], label='E2')
    plt.plot(B, WMatDiagBsT[2], label='E3')
    plt.plot(B, WMatDiagBsT[3], label='E4')
    plt.plot(B, WMatDiagBsT[4], label='E5')
    plt.plot(B, WMatDiagBsT[5], label='E6')
    plt.plot(B, WMatDiagBsT[6], label='E7')
    plt.plot(B, WMatDiagBsT[7], label='E8')
    plt.plot(B, WMatDiagBsT[8], label='E9')
    plt.plot(B, WMatDiagBsT[9], label='E10')
    plt.plot(B, WMatDiagBsT[10], label='E11')
    plt.plot(B, WMatDiagBsT[11], label='E12')
    plt.plot(B, WMatDiagBsT[12], label='E13')
    plt.plot(B, WMatDiagBsT[13], label='E14')
    plt.plot(B, WMatDiagBsT[14], label='E15')
    plt.plot(B, WMatDiagBsT[15], label='E16')
    plt.plot(B, WMatDiagBsT[16], label='E17')
    plt.plot(B, WMatDiagBsT[17], label='E18')
    plt.legend(loc='center left', bbox_to_anchor=(1, 0.5))



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
